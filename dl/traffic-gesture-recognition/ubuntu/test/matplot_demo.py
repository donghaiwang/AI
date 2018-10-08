import matplotlib.pyplot as plt
import matplotlib.image as mtimg
import matplotlib
import pylab

import numpy as np


def rgb2gray(rgb):
    return np.dot(rgb[..., :3], [0.299, 0.587, 0.114])


print(matplotlib.get_backend())

image = mtimg.imread('/home/dong/PycharmProjects/traffic-gesture-recognition/models/police.png')

gray = rgb2gray(image)

img = plt.imshow(gray, cmap='Greys_r')

plt.axis('off')
plt.show()
matplotlib.pyplot.show()
# pylab.show()
