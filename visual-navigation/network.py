# -*- coding: utf-8 -*-
import tensorflow as tf
import numpy as np


# Actor-Critic Network Base Class
# The policy network and value network architecture
# should be implemented in a child class of this one
class ActorCriticNetwork(object):
    def __init__(self,
                 action_size,
                 device="/cpu:0"):
        self._device = device
        self._action_size = action_size

    def prepare_loss(self, entropy_beta, scopes):
        # drop task id (last element) as all tasks in
        # the same scene share the same output branch 降序排列任务ID（所有的任务在相同的场景共享相同的输出分支
        scope_key = self._get_key(scopes[:-1])

        with tf.device(self._device):
            # 采取动作 taken action (input for policy)
            self.a = tf.placeholder("float", [None, self._action_size])

            # 时间差分 temporary difference (R-V) (input for policy)
            self.td = tf.placeholder("float", [None])

            # 避免由于裁剪出现NaN avoid NaN with clipping when value in pi becomes zero
            log_pi = tf.log(tf.clip_by_value(self.pi[scope_key], 1e-20, 1.0))

            # 策略熵 policy entropy
            entropy = -tf.reduce_sum(self.pi[scope_key] * log_pi, axis=1)

            # 输出策略损失 policy loss (output)
            policy_loss = - tf.reduce_sum(
                tf.reduce_sum(tf.multiply(log_pi, self.a), axis=1) * self.td + entropy * entropy_beta)

            # 输入值得奖励 R (input for value)
            self.r = tf.placeholder("float", [None])

            # 输出值损失 value loss (output)
            # 评价者的学习率是动作者的一半 learning rate for critic is half of actor's
            value_loss = 0.5 * tf.nn.l2_loss(self.r - self.v[scope_key])

            # 将策略和值得梯度进行累加 gradienet of policy and value are summed up
            self.total_loss = policy_loss + value_loss

    def run_policy_and_value(self, sess, s_t, task):
        raise NotImplementedError()

    def run_policy(self, sess, s_t, task):
        raise NotImplementedError()

    def run_value(self, sess, s_t, task):
        raise NotImplementedError()

    def get_vars(self):
        raise NotImplementedError()

    def sync_from(self, src_netowrk, name=None):  # 与全局网络进行同步
        src_vars = src_netowrk.get_vars()
        dst_vars = self.get_vars()

        local_src_var_names = [self._local_var_name(x) for x in src_vars]
        local_dst_var_names = [self._local_var_name(x) for x in dst_vars]

        # keep only variables from both src and dst
        src_vars = [x for x in src_vars
                    if self._local_var_name(x) in local_dst_var_names]
        dst_vars = [x for x in dst_vars
                    if self._local_var_name(x) in local_src_var_names]

        sync_ops = []

        with tf.device(self._device):
            with tf.name_scope(name, "ActorCriticNetwork", []) as name:
                for (src_var, dst_var) in zip(src_vars, dst_vars):
                    sync_op = tf.assign(dst_var, src_var)
                    sync_ops.append(sync_op)

                return tf.group(*sync_ops, name=name)

    # variable (global/scene/task1/W_fc:0) --> scene/task1/W_fc:0
    def _local_var_name(self, var):
        return '/'.join(var.name.split('/')[1:])

    # weight initialization based on muupan's code
    # https://github.com/muupan/async-rl/blob/master/a3c_ale.py
    def _fc_weight_variable(self, shape, name='W_fc'):
        input_channels = shape[0]
        d = 1.0 / np.sqrt(input_channels)
        initial = tf.random_uniform(shape, minval=-d, maxval=d)
        return tf.Variable(initial, name=name)

    def _fc_bias_variable(self, shape, input_channels, name='b_fc'):
        d = 1.0 / np.sqrt(input_channels)
        initial = tf.random_uniform(shape, minval=-d, maxval=d)
        return tf.Variable(initial, name=name)

    def _conv_weight_variable(self, shape, name='W_conv'):
        w = shape[0]
        h = shape[1]
        input_channels = shape[2]
        d = 1.0 / np.sqrt(input_channels * w * h)
        initial = tf.random_uniform(shape, minval=-d, maxval=d)
        return tf.Variable(initial, name=name)

    def _conv_bias_variable(self, shape, w, h, input_channels, name='b_conv'):
        d = 1.0 / np.sqrt(input_channels * w * h)
        initial = tf.random_uniform(shape, minval=-d, maxval=d)
        return tf.Variable(initial, name=name)

    def _conv2d(self, x, W, stride):
        return tf.nn.conv2d(x, W, strides=[1, stride, stride, 1], padding="VALID")

    def _get_key(self, scopes):
        return '/'.join(scopes)


# Actor-Critic Feed-Forward Network(AC前馈网络)
class ActorCriticFFNetwork(ActorCriticNetwork):
    """
      Implementation of the target-driven deep siamese actor-critic network from [Zhu et al., ICRA 2017]
      We use tf.variable_scope() to define domains for parameter sharing
    """

    def __init__(self,
                 action_size,
                 device="/cpu:0",
                 network_scope="network",
                 scene_scopes=["scene"]):
        ActorCriticNetwork.__init__(self, action_size, device)

        self.pi = dict()
        self.v = dict()

        self.W_fc1 = dict()
        self.b_fc1 = dict()

        self.W_fc2 = dict()
        self.b_fc2 = dict()

        self.W_fc3 = dict()
        self.b_fc3 = dict()

        self.W_policy = dict()  # 场景层的策略
        self.b_policy = dict()

        self.W_value = dict()
        self.b_value = dict()

        with tf.device(self._device):  # 指定运行设备

            # state (input) 机器人观测到到的图片的特征
            self.s = tf.placeholder("float", [None, 2048, 4])  # 从ResNet-50产生2048维特征

            self.t = tf.placeholder("float", [None, 2048, 4])
            # target (input) 输入目标

            with tf.variable_scope(network_scope):  # 生成一个上下文管理器，并指明需求的变量在这个上下文管理器中，就可以直接通过tf.get_variable获取已经生成的变量
                # network key
                key = network_scope

                # 将输入变成一维向量 flatten input
                self.s_flat = tf.reshape(self.s, [-1, 8192])  # -1所代表的含义是我们不用亲自去指定这一维的大小，函数会自动进行计算，但是列表中只能存在一个-1
                self.t_flat = tf.reshape(self.t, [-1, 8192])

                # 共享的孪生层 shared siamese layer
                self.W_fc1[key] = self._fc_weight_variable([8192, 512])
                self.b_fc1[key] = self._fc_bias_variable([512], 8192)

                h_s_flat = tf.nn.relu(tf.matmul(self.s_flat, self.W_fc1[key]) + self.b_fc1[key])
                h_t_flat = tf.nn.relu(tf.matmul(self.t_flat, self.W_fc1[key]) + self.b_fc1[key])
                h_fc1 = tf.concat(values=[h_s_flat, h_t_flat], axis=1)

                # shared fusion layer
                self.W_fc2[key] = self._fc_weight_variable([1024, 512])
                self.b_fc2[key] = self._fc_bias_variable([512], 1024)
                h_fc2 = tf.nn.relu(tf.matmul(h_fc1, self.W_fc2[key]) + self.b_fc2[key])

                for scene_scope in scene_scopes:  # 针对不同场景
                    # scene-specific key
                    key = self._get_key([network_scope, scene_scope])

                    with tf.variable_scope(scene_scope):
                        # 特定场景适应层 scene-specific adaptation layer
                        self.W_fc3[key] = self._fc_weight_variable([512, 512])
                        self.b_fc3[key] = self._fc_bias_variable([512], 512)
                        h_fc3 = tf.nn.relu(tf.matmul(h_fc2, self.W_fc3[key]) + self.b_fc3[key])

                        # 策略输出层的权重 weight for policy output layer
                        self.W_policy[key] = self._fc_weight_variable([512, action_size])
                        self.b_policy[key] = self._fc_bias_variable([action_size], 512)

                        # 策略输出 policy (output)
                        pi_ = tf.matmul(h_fc3, self.W_policy[key]) + self.b_policy[key]
                        self.pi[key] = tf.nn.softmax(pi_)

                        # 输出层的权重值 weight for value output layer
                        self.W_value[key] = self._fc_weight_variable([512, 1])
                        self.b_value[key] = self._fc_bias_variable([1], 512)

                        # 输出的值 value (output)
                        v_ = tf.matmul(h_fc3, self.W_value[key]) + self.b_value[key]
                        self.v[key] = tf.reshape(v_, [-1])

    def run_policy_and_value(self, sess, state, target, scopes):
        k = self._get_key(scopes[:2])
        pi_out, v_out = sess.run([self.pi[k], self.v[k]], feed_dict={self.s: [state], self.t: [target]})
        return (pi_out[0], v_out[0])

    def run_policy(self, sess, state, target, scopes):
        k = self._get_key(scopes[:2])
        pi_out = sess.run(self.pi[k], feed_dict={self.s: [state], self.t: [target]})
        return pi_out[0]

    def run_value(self, sess, state, target, scopes):
        k = self._get_key(scopes[:2])
        v_out = sess.run(self.v[k], feed_dict={self.s: [state], self.t: [target]})
        return v_out[0]

    def get_vars(self):
        var_list = [
            self.W_fc1, self.b_fc1,
            self.W_fc2, self.b_fc2,
            self.W_fc3, self.b_fc3,
            self.W_policy, self.b_policy,
            self.W_value, self.b_value
        ]
        vs = []
        for v in var_list:
            vs.extend(v.values())
        return vs
