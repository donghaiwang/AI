import cv2
import os

from tools import _const as const

datasets_path = os.path.join(const.PROJECT_HOME, 'datasets')

my_img_path = os.path.join(datasets_path, 'my')  # crop image destination
raw_imgs_path = os.path.join(my_img_path, 'img')

raw_data_path = os.path.join(datasets_path, 'raw')
# video_path = os.path.join(raw_data_path, 'xiongjingjing_20180621_094606.mp4')
videos_path = os.listdir(raw_data_path)
for video_name in videos_path:
    video_full_path = os.path.join(raw_data_path, video_name)

    video_capture = cv2.VideoCapture(video_full_path)

    frame_count = 1
    time_interval = 1
    if video_capture.isOpened():
        ret_val, frame = video_capture.read()
    else:
        ret_val = False

    raw_img_path = os.path.join(raw_imgs_path, os.path.splitext(video_name)[0])
    if not os.path.exists(raw_img_path):
        os.mkdir(raw_img_path)
    while ret_val:
        ret_val, frame = video_capture.read()
        if frame_count % time_interval == 0:
            cv2.imwrite(os.path.join(raw_img_path, str(frame_count) + '.jpg'), frame)
        frame_count = frame_count + 1
        cv2.waitKey(1)
    video_capture.release()









