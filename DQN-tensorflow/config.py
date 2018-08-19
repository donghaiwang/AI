# 智能体的配置文件
class AgentConfig(object):
  scale = 10000
  display = False    # 是否显示游戏画面

  max_step = 5000 * scale
  memory_size = 100 * scale               # 内存大小

  batch_size = 32
  random_start = 30
  cnn_format = 'NCHW'                     # GPU的输入图片格式
  discount = 0.99                         # 折扣因子
  target_q_update_step = 1 * scale        # 目标Q值更新的频率
  learning_rate = 0.00025
  learning_rate_minimum = 0.00025         # 最小学习率
  learning_rate_decay = 0.96              # 学习率衰减因子
  learning_rate_decay_step = 5 * scale    # 学习率衰减的频率

  ep_end = 0.1
  ep_start = 1.
  ep_end_t = memory_size

  history_length = 4          # 考虑历史帧的数目
  train_frequency = 4
  learn_start = 5. * scale

  min_delta = -1
  max_delta = 1

  double_q = False
  dueling = False

  _test_step = 5 * scale
  _save_step = _test_step * 10

class EnvironmentConfig(object):
  env_name = 'Breakout-v0'

  screen_width  = 84  # 游戏屏幕的宽度
  screen_height = 84  # 高度
  max_reward = 1.     # 最大奖励+1
  min_reward = -1.    # 最小奖励-1

class DQNConfig(AgentConfig, EnvironmentConfig):
  model = ''
  pass

class M1(DQNConfig):
  backend = 'tf'  # 默认的模型类型（m1）使用的后端是tensorflow
  env_type = 'detail'
  action_repeat = 1

def get_config(FLAGS):  # main.py用来加载配置的方法（FLAGS用来传递所加载的选项）
  if FLAGS.model == 'm1':
    config = M1
  elif FLAGS.model == 'm2':
    config = M2

  for k, v in FLAGS.__dict__['__flags'].items():
    if k == 'gpu':
      if v == False:                # 在TensorFlow中张量的默认Channel维度在末尾（在CPU代码里运行）
        config.cnn_format = 'NHWC'  # 使用CPU的话就用输入数据格式：NHWC
      else:
        config.cnn_format = 'NCHW'  # GPU对应的数据格式（和Tensorflow不一样）使用NCHW（通道靠前）

    if hasattr(config, k):
      setattr(config, k, v)

  return config
