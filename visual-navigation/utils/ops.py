import math
import random

def log_uniform(lo, hi, rate):
  """
    draw a sample from a log-uniform distribution in [lo, hi]
  """
  log_lo = math.log(lo)
  log_hi = math.log(hi)
  v = log_lo * (1-rate) + log_hi * rate
  return math.exp(v)

def sample_action(prob_values):
  """
    draw a sample from softmax distribution
  """
  values = []
  sum = 0.0
  for rate in prob_values:
    sum = sum + rate
    value = sum
    values.append(value)
  r = random.random() * sum
  for i in range(len(values)):
    if values[i] >= r:
      return i;
  #fail safe
  return len(values)-1
