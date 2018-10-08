
import numpy as np

a = np.array([[[1, 2, 3], [4, 5, 6]], [[1, 2, 3], [4, 5, 6]]])
c = np.array([[[5, 6, 7], [7, 8, 9]], [[4, 5, 6], [5, 6, 7]]])

print(a.shape)
print(c.shape)

print(np.concatenate((a, c), axis=2))
