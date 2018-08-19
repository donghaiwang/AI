import numpy as np

# 历史信息
class History:
  def __init__(self, config):
    self.cnn_format = config.cnn_format

    batch_size, history_length, screen_height, screen_width = \
        config.batch_size, config.history_length, config.screen_height, config.screen_width

    self.history = np.zeros(
        [history_length, screen_height, screen_width], dtype=np.float32)

  def add(self, screen):
    """增加帧到历史库中的最前面"""
    self.history[:-1] = self.history[1:]
    self.history[-1] = screen

  def reset(self):
    """重置历史库"""
    self.history *= 0

  def get(self):
    """获得历史库"""
    if self.cnn_format == 'NHWC':  # CPU
      return np.transpose(self.history, (1, 2, 0))  # 将NCHW(GPU)转化为NHWC(CPU)
    else:
      return self.history
