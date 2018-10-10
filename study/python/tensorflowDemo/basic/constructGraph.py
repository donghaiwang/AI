import tensorflow as tf

matrix1 = tf.constant([[3., 3.]])
matrix2 = tf.constant([[2.], [2.]])
product = tf.matmul(matrix1, matrix2)
#
# sess = tf.Session()
# result = sess.run(product)
#
# print(result)
#
# sess.close()

with tf.Session() as sess:
    result = sess.run(product)
    print(result)


class Sample:
    def __init__(self):
        pass

    def __enter__(self):
        print("In __enter__()")
        return "Foo"

    def __exit__(self, exc_type, exc_val, exc_tb):
        print("In __exit__()")


def get_sample():
    return Sample()


with get_sample() as sample:
    print("sample:"), sample
