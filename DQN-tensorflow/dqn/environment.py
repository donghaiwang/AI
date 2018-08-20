import gym
import random
import numpy as np
from .utils import rgb2gray, imresize

class Environment(object):
  def __init__(self, config):
    self.env = gym.make(config.env_name)  # 创建仿真环境

    screen_width, screen_height, self.action_repeat, self.random_start = \
        config.screen_width, config.screen_height, config.action_repeat, config.random_start

    self.display = config.display
    self.dims = (screen_width, screen_height)

    self._screen = None
    self.reward = 0
    self.terminal = True

  def new_game(self, from_random_game=False):
    if self.lives == 0:
      self._screen = self.env.reset()   # 一次尝试结束后，智能体需要从头开始
    self._step(0)
    self.render()
    return self.screen, 0, 0, self.terminal

  def new_random_game(self):
    self.new_game(True)
    for _ in range(random.randint(0, self.random_start - 1)):
      self._step(0)
    self.render()
    return self.screen, 0, 0, self.terminal

  def _step(self, action):
    """物理引擎；智能体与环境的交互"""
    self._screen, self.reward, self.terminal, _ = self.env.step(action)

  def _random_step(self):
    action = self.env.action_space.sample()
    self._step(action)

  @ property  # 该属性很可能不是直接暴露的，而是通过getter和setter方法来实现的
  def screen(self):
    return imresize(rgb2gray(self._screen)/255., self.dims)  # utils.py里的工具函数
    #return cv2.resize(cv2.cvtColor(self._screen, cv2.COLOR_BGR2YCR_CB)/255., self.dims)[:,:,0]

  @property
  def action_size(self):
    return self.env.action_space.n

  @property
  def lives(self):
    self.env = self.env.unwrapped
    return self.env.ale.lives()

  @property
  def state(self):
    return self.screen, self.reward, self.terminal

  def render(self):
    if self.display:
      self.env.render()

  def after_act(self, action):
    self.render()


"""强化学习仿真环境"""
class GymEnvironment(Environment):
  def __init__(self, config):
    super(GymEnvironment, self).__init__(config)

  def act(self, action, is_training=True):
    """在仿真环境中执行动作"""
    cumulated_reward = 0
    start_lives = self.lives

    for _ in range(self.action_repeat):
      self._step(action)  # 物理引擎，输入是动作a，输出是：下一步状态、立刻回报、是否终止、调试项
      cumulated_reward = cumulated_reward + self.reward

      if is_training and start_lives > self.lives:
        cumulated_reward -= 1
        self.terminal = True

      if self.terminal:
        break

    self.reward = cumulated_reward

    self.after_act(action)    # 动作执行后使用图像引擎来显示环境中的物体对象
    return self.state


"""简化的强化学习仿真环境：没有奖励累积操作"""
class SimpleGymEnvironment(Environment):
  def __init__(self, config):
    super(SimpleGymEnvironment, self).__init__(config)

  def act(self, action, is_training=True):
    self._step(action)

    self.after_act(action)
    return self.state
