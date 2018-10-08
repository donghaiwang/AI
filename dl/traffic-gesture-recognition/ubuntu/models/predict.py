import numpy as np
import os
# import cv2 as cv
import matplotlib.pyplot as plt # plt 用于显示图片
import matplotlib.image as mpimg # mpimg 用于读取图片

import tensorflow as tf
from tensorflow.python.keras.preprocessing import image
#from tensorflow.python.keras.applications.xception import preprocess_input
# from tensorflow.python.keras.applications.inception_v3 import preprocess_input


# img_rect is of type autoware_msgs::image_rect
# def correct_size(self, image, img_rect):
#     x_right = img_rect.x + img_rect.width
#     y_bottom = img_rect.y + img_rect.height
#     img = image[img_rect.y:y_bottom, img_rect.x:x_right, :]
#
#     zero_mean = (img - np.mean(img, axis=0))/128.
#
#     print("Image shape", zero_mean.shape)
#
#     scaled_img = cv.resize(zero_mean, self.network_size)
#     return scaled_img


def preprocess_input(x):
    x /= 255.
    x -= 0.5
    x *= 2.
    return x


def is_max(predict, index):
    _position = np.argmax(predict)
    if _position == index:
        return True
    else:
        return False


# {'pedestrian': 0, 'policeman': 1}
# {'stop': 2, 'turn_right': 3, 'go_straight': 0, 'park_right': 1}
if __name__ == "__main__":
    predict_gusture = 1

    project_home = "/home/dong/PycharmProjects/traffic-gesture-recognition/"
    model_path_prefix = os.path.join(project_home, "datasets")
    test_image_path = os.path.join(project_home, 'models')
    police_image_path = os.path.join(test_image_path, 'police.png')
    pedestrian_path = os.path.join(test_image_path, 'pedestrian.png')
    stop_image_path = os.path.join(test_image_path, 'stop.png')

    if predict_gusture == 1:
        gesture_dectector = tf.keras.models.load_model(os.path.join(model_path_prefix, "gesture.h5"))
        # test go straight video
        go_straight_image_path = os.path.join(test_image_path, 'go_straight')
        # my video go straight image path
        # go_straight_image_path = '/home/dong/PycharmProjects/traffic-gesture-recognition/datasets/my/go_straight/'
        # load_image_path = '/home/dong/PycharmProjects/traffic-gesture-recognition/datasets/my/stop/'
        load_image_path = '/home/dong/PycharmProjects/traffic-gesture-recognition/models/stop/'
        files = os.listdir(load_image_path)
        good_predict_cnt = 0
        for file in files:
            file_path = os.path.join(load_image_path, file)
            print(file_path)
            load_image = image.load_img(file_path, target_size=(299, 299))
            load_image = image.img_to_array(load_image)
            load_image = np.expand_dims(load_image, axis=0)
            load_image = preprocess_input(load_image)
            go_straight_predicted = gesture_dectector.predict(load_image)
            print("Predict result: ", go_straight_predicted)
            print(go_straight_predicted[0])
            if is_max(go_straight_predicted[0], 2):     # 0: go straight; 2:stop
                good_predict_cnt = good_predict_cnt + 1
                print("Good predict!!!")
        print("File number: ", len(files))
        print("Accuracy: ", good_predict_cnt / len(files))
        exit()

        # stop_image = image.load_img(stop_image_path, target_size=(299, 299))
        # stop = image.img_to_array(stop_image)
        # stop = np.expand_dims(stop, axis=0)
        # stop = preprocess_input(stop)
        # stop_predicted = gesture_dectector.predict(stop)
        # print('Is stop: ', stop_predicted)
    else:
        # 加载训练好的模型
        policeman_verifier = tf.keras.models.load_model(os.path.join(model_path_prefix, "policeman.h5"))
        # 加载图像
        print(police_image_path)
        police_image = image.load_img(police_image_path, target_size=(299, 299))
        # 图像预处理
        police = image.img_to_array(police_image)
        police = np.expand_dims(police, axis=0)
        police = preprocess_input(police)
        # 对图像进行分类
        police_predicted = policeman_verifier.predict(police, batch_size=32)
        # 输出预测概率
        print('Is police:', police_predicted)

        pedestrian = image.load_img(pedestrian_path, target_size=(299, 299))
        pedestrian = image.img_to_array(pedestrian)
        pedestrian = np.expand_dims(pedestrian, axis=0)
        pedestrian = preprocess_input(pedestrian)
        pedestrian_predicted = policeman_verifier.predict(pedestrian)
        print('Is pedestrian: ', pedestrian_predicted)




