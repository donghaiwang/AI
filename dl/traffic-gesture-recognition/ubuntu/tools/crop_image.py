import cv2
import os
from math import *

from tools import _const as const

# crop frame image

is_rotated = True

user_name = 'yangxuefeng'
command = 'turn_right'
sub_imgage_width = 400
sub_image_height = 870
sub_image_center_x = 485
sub_image_center_y = 1290


proc_path_prefix = os.path.join(const.PROJECT_HOME, 'datasets/my/')
crop_source_image_path = proc_path_prefix + command + '_full_image/'
crop_source_image_path = os.path.join(crop_source_image_path, user_name)
crop_dest_image_path = os.path.join(proc_path_prefix, command)  # '/home/dong/PycharmProjects/traffic-gesture-recognition/datasets/my/stop/'
crop_dest_image_path = os.path.join(crop_dest_image_path, user_name)

files = os.listdir(crop_source_image_path)
for file in files:
    print(file)
    img = cv2.imread(os.path.join(crop_source_image_path, file))

    if is_rotated:
        height, width = img.shape[:2]
        degree = -90
        # 旋转后的尺寸
        heightNew = int(width * fabs(sin(radians(degree))) + height * fabs(cos(radians(degree))))
        widthNew = int(height * fabs(sin(radians(degree))) + width * fabs(cos(radians(degree))))

        matRotation = cv2.getRotationMatrix2D((width / 2, height / 2), degree, 1)

        matRotation[0, 2] += (widthNew - width) / 2  # 重点在这步，目前不懂为什么加这步
        matRotation[1, 2] += (heightNew - height) / 2  # 重点在这步

        img = cv2.warpAffine(img, matRotation, (widthNew, heightNew), borderValue=(255, 255, 255))

    # crop image(Size patchSize：获取矩形的大小, Point2f center：获取的矩形在原图像中的位置)
    # target_img = cv2.getRectSubPix(imgRotation, (900, 1000), (550, 1100))  # go straight
    # img = cv2.getRectSubPix(img, (1080, 1200), (500, 1000))  # go straight(wanghaidong)
    img = cv2.getRectSubPix(img, (sub_imgage_width, sub_image_height), (sub_image_center_x, sub_image_center_y))  # go straight(wuyiqiang)

    if not os.path.exists(crop_dest_image_path):
        os.makedirs(crop_dest_image_path)
        #  /home/dong/PycharmProjects/traffic-gesture-recognition/datasets/my/go_straight_full_image
        #  /home/dong/PycharmProjects/traffic-gesture-recognition/datasets/my/park_right/yangluxing
    cv2.imwrite(os.path.join(crop_dest_image_path, file), img)

    # cv2.imshow('img', target_img)
    # cv2.waitKey()
