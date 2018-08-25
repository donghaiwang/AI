from __future__ import print_function
import random
import tensorflow as tf

from dqn.agent import Agent
from dqn.environment import GymEnvironment, SimpleGymEnvironment
from config import get_config

flags = tf.app.flags

# 添加命令行的可选参数，可以在命令行使用-h查看帮助信息
# 加载的模型
flags.DEFINE_string('model', 'm1', 'Type of model')  # 模型类型
flags.DEFINE_boolean('dueling', False, 'Whether to use dueling deep q-network')  # 决定是否使用竞争深度Q网络（默认不使用）
flags.DEFINE_boolean('double_q', False, 'Whether to use double q-learning')      # 决定是否使用双Q网络（默认不使用）

# 仿真环境(Pong-v0, MontezumaRevengeNoFrameskip-v0)
# flags.DEFINE_string('env_name', 'Breakout-v0', 'The name of gym environment to use')  # 使用的gym仿真环境（默认是打砖块游戏）
flags.DEFINE_string('env_name', 'MontezumaRevengeNoFrameskip-v0', 'The name of gym environment to use')  # 使用的gym仿真环境（默认是打砖块游戏）
flags.DEFINE_integer('action_repeat', 4, 'The number of action to be repeated')       # 重复执行动作的次数（默认4次）

# Etc
flags.DEFINE_boolean('use_gpu', False, 'Whether to use gpu or not')                        # 是否使用GPU（默认使用GPU）
flags.DEFINE_string('gpu_fraction', '1/1', 'idx / # of gpu fraction e.g. 1/3, 2/3, 3/3')  # GPU使用的比例（默认使用尽可能多的显存）
flags.DEFINE_boolean('display', True, 'Whether to do display the game screen or not')    # 是否显示游戏画面（默认不显示）
flags.DEFINE_boolean('is_train', True, 'Whether to do training or testing')               # 是否进行训练和测试（默认进行训练和测试）
flags.DEFINE_integer('random_seed', 123, 'Value of random seed')                          # 使用的随机种子（默认123）

FLAGS = flags.FLAGS

# 设置随机种子
tf.set_random_seed(FLAGS.random_seed)
random.seed(FLAGS.random_seed)

if FLAGS.gpu_fraction == '':
  raise ValueError("--gpu_fraction should be defined")

def calc_gpu_fraction(fraction_string):    # 从输入的字符串（2/3）中分析出CPU的使用率
  idx, num = fraction_string.split('/')
  idx, num = float(idx), float(num)        # 比如说2/3表示：从3个GPU中使用两个，那么GPU的使用率是：2/3=1.5=150%

  fraction = 1 / (num - idx + 1)
  print(" [*] GPU : %.4f" % fraction)
  return fraction

def main(_):
  gpu_options = tf.GPUOptions(
      per_process_gpu_memory_fraction=calc_gpu_fraction(FLAGS.gpu_fraction))

  with tf.Session(config=tf.ConfigProto(gpu_options=gpu_options)) as sess:
    config = get_config(FLAGS) or FLAGS    # 通过config.py的get_config方法加载配置选项

    if config.env_type == 'simple':
      env = SimpleGymEnvironment(config)
    else:
      env = GymEnvironment(config)

    if not tf.test.is_gpu_available() and FLAGS.use_gpu:  # 如果能检查到就使用GPU；如果设置了使用GPU但是没有检测到GPU则报错。
      raise Exception("use_gpu flag is true when no GPUs are available")

    if not FLAGS.use_gpu:
      config.cnn_format = 'NHWC'  # 输入的格式：[batch, in_height, in_width, in_channels]
    # 另一种数据输入格式NCHW：[batch, in_channels, in_height, in_width]

    agent = Agent(config, env, sess)    # 新建DQN的智能体

    if FLAGS.is_train:
      agent.train()
    else:
      agent.play()  # 不进行训练（仅仅演示）

if __name__ == '__main__':
  tf.app.run()
