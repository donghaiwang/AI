import os
import shutil


def remove_dir(dir):
    dir = dir.replace('\\', '/')
    if (os.path.isdir(dir)):
        for p in os.listdir(dir):
            remove_dir(os.path.join(dir, p))
        if (os.path.exists(dir)):
            os.rmdir(dir)
    else:
        if (os.path.exists(dir)):
            os.remove(dir)


def mkdir(path):
    # 去除首位空格
    path = path.strip()
    # 去除尾部 \ 符号
    path = path.rstrip("\\")
    # 判断路径是否存在
    # 存在     True
    # 不存在   False
    isExists = os.path.exists(path)
    # 判断结果
    if not isExists:
        # 如果不存在则创建目录  　# 创建目录操作函数
        os.makedirs(path)
        print('create directory' + path + 'success!')
        return True
    else:
        # remove_dir(path)
        return False


if __name__ == "__main__":
    datasets_path = "/home/pq/gusture/traffic-gesture-recognition/datasets/chinese_traffic_gesture_dataset/"
    classes = ['go_straight', 'park_right', 'stop', 'turn_right']
    train_path = os.path.join(datasets_path, 'train')
    valid_path = os.path.join(datasets_path, 'valid')
    for index, value in enumerate(classes):
        class_data_path = os.path.join(datasets_path, value)
        train_dest_path = os.path.join(train_path, value)
        valid_dest_path = os.path.join(valid_path, value)
        mkdir(train_dest_path)
        mkdir(valid_dest_path)
        path_dir = os.listdir(class_data_path)
        for i, file_name in enumerate(path_dir):
            print(file_name)
            if i < 0.75 * len(path_dir):
                shutil.copyfile(os.path.join(class_data_path, file_name), os.path.join(train_dest_path, file_name))
            else:
                shutil.copyfile(os.path.join(class_data_path, file_name), os.path.join(valid_dest_path, file_name))

    # mkdir(train_path)
    # mkdir(valid_path)

    classes = ['go_straight', 'park_right', 'stopo', 'turn_right']
