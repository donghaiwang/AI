

import os
# import click
# import glob
# from models.inception_v4 import create_inception_v4, load_weights, Dense
# from models.inception_v4 import create_inception_v4, Dense
import tensorflow as tf

from tensorflow.python.keras.layers import Input, concatenate, Dropout, Dense, Flatten, Activation
from tensorflow.python.keras.layers import MaxPooling2D, Convolution2D, AveragePooling2D
from tensorflow.python.keras.layers import BatchNormalization
from tensorflow.python.keras.models import Model

from tensorflow.python.keras import backend as K   # noqa


DATASETS_HOME = "/home/dong/PycharmProjects/traffic-gesture-recognition/datasets/"
# TH_BACKEND_TH_DIM_ORDERING = "/home/dong/PycharmProjects/traffic-gesture-recognition/datasets/inception_v4_weights_th_dim_ordering_th_kernels.h5"
# TH_BACKEND_TF_DIM_ORDERING = "/home/dong/PycharmProjects/traffic-gesture-recognition/datasets/inception_v4_weights_tf_dim_ordering_th_kernels.h5"
# TF_BACKEND_TF_DIM_ORDERING = "/home/dong/PycharmProjects/traffic-gesture-recognition/datasets/inception_v4_weights_tf_dim_ordering_tf_kernels.h5"
# TF_BACKEND_TH_DIM_ORDERING = "/home/dong/PycharmProjects/traffic-gesture-recognition/datasets/inception_v4_weights_th_dim_ordering_tf_kernels.h5"
# download to the directory: /home/dong/.keras/models/*.h5
TH_BACKEND_TH_DIM_ORDERING = "https://github.com/titu1994/Inception-v4/releases/download/v1.2/inception_v4_weights_th_dim_ordering_th_kernels.h5"
TH_BACKEND_TF_DIM_ORDERING = "https://github.com/titu1994/Inception-v4/releases/download/v1.2/inception_v4_weights_tf_dim_ordering_th_kernels.h5"   # Contains the weights of Inception v4 Tensorflow-TF and Theano-TH ported by @kentsommer)
TF_BACKEND_TF_DIM_ORDERING = "https://github.com/titu1994/Inception-v4/releases/download/v1.2/inception_v4_weights_tf_dim_ordering_tf_kernels.h5"
TF_BACKEND_TH_DIM_ORDERING = "https://github.com/titu1994/Inception-v4/releases/download/v1.2/inception_v4_weights_th_dim_ordering_tf_kernels.h5"


def inception_C(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    c1 = conv_block(input, 256, 1, 1)

    c2 = conv_block(input, 384, 1, 1)
    c2_1 = conv_block(c2, 256, 1, 3)
    c2_2 = conv_block(c2, 256, 3, 1)
    c2 = concatenate([c2_1, c2_2], axis=channel_axis)

    c3 = conv_block(input, 384, 1, 1)
    c3 = conv_block(c3, 448, 3, 1)
    c3 = conv_block(c3, 512, 1, 3)
    c3_1 = conv_block(c3, 256, 1, 3)
    c3_2 = conv_block(c3, 256, 3, 1)
    c3 = concatenate([c3_1, c3_2], axis=channel_axis)

    c4 = AveragePooling2D((3, 3), strides=(1, 1), padding='same')(input)
    c4 = conv_block(c4, 256, 1, 1)

    m = concatenate([c1, c2, c3, c4], axis=channel_axis)
    return m


def reduction_A(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    r1 = conv_block(input, 384, 3, 3, strides=(2, 2), padding='valid')

    r2 = conv_block(input, 192, 1, 1)
    r2 = conv_block(r2, 224, 3, 3)
    r2 = conv_block(r2, 256, 3, 3, strides=(2, 2), padding='valid')

    r3 = MaxPooling2D((3, 3), strides=(2, 2), padding='valid')(input)

    m = concatenate([r1, r2, r3], axis=channel_axis)
    return m


def reduction_B(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    r1 = conv_block(input, 192, 1, 1)
    r1 = conv_block(r1, 192, 3, 3, strides=(2, 2), padding='valid')

    r2 = conv_block(input, 256, 1, 1)
    r2 = conv_block(r2, 256, 1, 7)
    r2 = conv_block(r2, 320, 7, 1)
    r2 = conv_block(r2, 320, 3, 3, strides=(2, 2), padding='valid')

    r3 = MaxPooling2D((3, 3), strides=(2, 2), padding='valid')(input)

    m = concatenate([r1, r2, r3], axis=channel_axis)
    return m


def create_inception_v4(nb_classes=1001, input=None):
    '''
    Creates a inception v4 network

    :param nb_classes: number of classes.txt
    :return: Keras Model with 1 input and 1 output
    '''
    if not input:
        if K.image_data_format() == 'channels_first':
            init = Input((3, 299, 299))
        else:
            init = Input((299, 299, 3))

    # Input Shape is 299 x 299 x 3 (tf) or 3 x 299 x 299 (th)
    x = inception_stem(init)

    # 4 x Inception A
    for i in range(4):
        x = inception_A(x)

    # Reduction A
    x = reduction_A(x)

    # 7 x Inception B
    for i in range(7):
        x = inception_B(x)

    # Reduction B
    x = reduction_B(x)

    # 3 x Inception C
    for i in range(3):
        x = inception_C(x)

    # Average Pooling
    x = AveragePooling2D((8, 8))(x)

    # Dropout
    x = Dropout(0.8)(x)
    x = Flatten(name="logits")(x)

    # Output
    out = Dense(units=nb_classes, activation='softmax')(x)

    model = Model(init, out, name='Inception-v4')

    return model


def conv_block(x, nb_filter, nb_row, nb_col, padding='same', strides=(1, 1), bias=False):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    x = Convolution2D(nb_filter, (nb_row, nb_col), strides=strides, padding=padding, use_bias=bias)(x)
    x = BatchNormalization(axis=channel_axis)(x)
    x = Activation('relu')(x)
    return x


def inception_stem(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    # Input Shape is 299 x 299 x 3 (th) or 3 x 299 x 299 (th)
    x = conv_block(input, 32, 3, 3, strides=(2, 2), padding='valid')
    x = conv_block(x, 32, 3, 3, padding='valid')
    x = conv_block(x, 64, 3, 3)

    x1 = MaxPooling2D((3, 3), strides=(2, 2), padding='valid')(x)
    x2 = conv_block(x, 96, 3, 3, strides=(2, 2), padding='valid')

    x = concatenate([x1, x2], axis=channel_axis)

    x1 = conv_block(x, 64, 1, 1)
    x1 = conv_block(x1, 96, 3, 3, padding='valid')

    x2 = conv_block(x, 64, 1, 1)
    x2 = conv_block(x2, 64, 1, 7)
    x2 = conv_block(x2, 64, 7, 1)
    x2 = conv_block(x2, 96, 3, 3, padding='valid')

    x = concatenate([x1, x2], axis=channel_axis)

    x1 = conv_block(x, 192, 3, 3, strides=(2, 2), padding='valid')
    x2 = MaxPooling2D((3, 3), strides=(2, 2), padding='valid')(x)

    x = concatenate([x1, x2], axis=channel_axis)
    return x


def inception_A(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    a1 = conv_block(input, 96, 1, 1)

    a2 = conv_block(input, 64, 1, 1)
    a2 = conv_block(a2, 96, 3, 3)

    a3 = conv_block(input, 64, 1, 1)
    a3 = conv_block(a3, 96, 3, 3)
    a3 = conv_block(a3, 96, 3, 3)

    a4 = AveragePooling2D((3, 3), strides=(1, 1), padding='same')(input)
    a4 = conv_block(a4, 96, 1, 1)

    m = concatenate([a1, a2, a3, a4], axis=channel_axis)
    return m


def inception_B(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    b1 = conv_block(input, 384, 1, 1)

    b2 = conv_block(input, 192, 1, 1)
    b2 = conv_block(b2, 224, 1, 7)
    b2 = conv_block(b2, 256, 7, 1)

    b3 = conv_block(input, 192, 1, 1)
    b3 = conv_block(b3, 192, 7, 1)
    b3 = conv_block(b3, 224, 1, 7)
    b3 = conv_block(b3, 224, 7, 1)
    b3 = conv_block(b3, 256, 1, 7)

    b4 = AveragePooling2D((3, 3), strides=(1, 1), padding='same')(input)
    b4 = conv_block(b4, 128, 1, 1)

    m = concatenate([b1, b2, b3, b4], axis=channel_axis)
    return m


def inception_C(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    c1 = conv_block(input, 256, 1, 1)

    c2 = conv_block(input, 384, 1, 1)
    c2_1 = conv_block(c2, 256, 1, 3)
    c2_2 = conv_block(c2, 256, 3, 1)
    c2 = concatenate([c2_1, c2_2], axis=channel_axis)

    c3 = conv_block(input, 384, 1, 1)
    c3 = conv_block(c3, 448, 3, 1)
    c3 = conv_block(c3, 512, 1, 3)
    c3_1 = conv_block(c3, 256, 1, 3)
    c3_2 = conv_block(c3, 256, 3, 1)
    c3 = concatenate([c3_1, c3_2], axis=channel_axis)

    c4 = AveragePooling2D((3, 3), strides=(1, 1), padding='same')(input)
    c4 = conv_block(c4, 256, 1, 1)

    m = concatenate([c1, c2, c3, c4], axis=channel_axis)
    return m


def reduction_A(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    r1 = conv_block(input, 384, 3, 3, strides=(2, 2), padding='valid')

    r2 = conv_block(input, 192, 1, 1)
    r2 = conv_block(r2, 224, 3, 3)
    r2 = conv_block(r2, 256, 3, 3, strides=(2, 2), padding='valid')

    r3 = MaxPooling2D((3, 3), strides=(2, 2), padding='valid')(input)

    m = concatenate([r1, r2, r3], axis=channel_axis)
    return m


def reduction_B(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    r1 = conv_block(input, 192, 1, 1)
    r1 = conv_block(r1, 192, 3, 3, strides=(2, 2), padding='valid')

    r2 = conv_block(input, 256, 1, 1)
    r2 = conv_block(r2, 256, 1, 7)
    r2 = conv_block(r2, 320, 7, 1)
    r2 = conv_block(r2, 320, 3, 3, strides=(2, 2), padding='valid')

    r3 = MaxPooling2D((3, 3), strides=(2, 2), padding='valid')(input)

    m = concatenate([r1, r2, r3], axis=channel_axis)
    return m


def create_inception_v4(nb_classes=1001, input=None):
    '''
    Creates a inception v4 network

    :param nb_classes: number of classes.txt
    :return: Keras Model with 1 input and 1 output
    '''
    if not input:
        if K.image_data_format() == 'channels_first':
            init = Input((3, 299, 299))
        else:
            init = Input((299, 299, 3))

    # Input Shape is 299 x 299 x 3 (tf) or 3 x 299 x 299 (th)
    x = inception_stem(init)

    # 4 x Inception A
    for i in range(4):
        x = inception_A(x)

    # Reduction A
    x = reduction_A(x)

    # 7 x Inception B
    for i in range(7):
        x = inception_B(x)

    # Reduction B
    x = reduction_B(x)

    # 3 x Inception C
    for i in range(3):
        x = inception_C(x)

    # Average Pooling
    x = AveragePooling2D((8, 8))(x)

    # Dropout
    x = Dropout(0.8)(x)
    x = Flatten(name="logits")(x)

    # Output
    out = Dense(units=nb_classes, activation='softmax')(x)

    model = Model(init, out, name='Inception-v4')

    return model


def conv_block(x, nb_filter, nb_row, nb_col, padding='same', strides=(1, 1), bias=False):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    x = Convolution2D(nb_filter, (nb_row, nb_col), strides=strides, padding=padding, use_bias=bias)(x)
    x = BatchNormalization(axis=channel_axis)(x)
    x = Activation('relu')(x)
    return x


def inception_stem(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    # Input Shape is 299 x 299 x 3 (th) or 3 x 299 x 299 (th)
    x = conv_block(input, 32, 3, 3, strides=(2, 2), padding='valid')
    x = conv_block(x, 32, 3, 3, padding='valid')
    x = conv_block(x, 64, 3, 3)

    x1 = MaxPooling2D((3, 3), strides=(2, 2), padding='valid')(x)
    x2 = conv_block(x, 96, 3, 3, strides=(2, 2), padding='valid')

    x = concatenate([x1, x2], axis=channel_axis)

    x1 = conv_block(x, 64, 1, 1)
    x1 = conv_block(x1, 96, 3, 3, padding='valid')

    x2 = conv_block(x, 64, 1, 1)
    x2 = conv_block(x2, 64, 1, 7)
    x2 = conv_block(x2, 64, 7, 1)
    x2 = conv_block(x2, 96, 3, 3, padding='valid')

    x = concatenate([x1, x2], axis=channel_axis)

    x1 = conv_block(x, 192, 3, 3, strides=(2, 2), padding='valid')
    x2 = MaxPooling2D((3, 3), strides=(2, 2), padding='valid')(x)

    x = concatenate([x1, x2], axis=channel_axis)
    return x


def inception_A(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    a1 = conv_block(input, 96, 1, 1)

    a2 = conv_block(input, 64, 1, 1)
    a2 = conv_block(a2, 96, 3, 3)

    a3 = conv_block(input, 64, 1, 1)
    a3 = conv_block(a3, 96, 3, 3)
    a3 = conv_block(a3, 96, 3, 3)

    a4 = AveragePooling2D((3, 3), strides=(1, 1), padding='same')(input)
    a4 = conv_block(a4, 96, 1, 1)

    m = concatenate([a1, a2, a3, a4], axis=channel_axis)
    return m


def inception_B(input):
    if K.image_data_format() == "channels_first":
        channel_axis = 1
    else:
        channel_axis = -1

    b1 = conv_block(input, 384, 1, 1)

    b2 = conv_block(input, 192, 1, 1)
    b2 = conv_block(b2, 224, 1, 7)
    b2 = conv_block(b2, 256, 7, 1)

    b3 = conv_block(input, 192, 1, 1)
    b3 = conv_block(b3, 192, 7, 1)
    b3 = conv_block(b3, 224, 1, 7)
    b3 = conv_block(b3, 224, 7, 1)
    b3 = conv_block(b3, 256, 1, 7)

    b4 = AveragePooling2D((3, 3), strides=(1, 1), padding='same')(input)
    b4 = conv_block(b4, 128, 1, 1)

    m = concatenate([b1, b2, b3, b4], axis=channel_axis)
    return m


def load_weights(model):

    get_file = tf.contrib.keras.utils.get_file
    if K.backend() == "theano":
        if K.image_data_format() == "channels_first":
            weights = get_file('inception_v4_weights_th_dim_ordering_th_kernels.h5', TH_BACKEND_TH_DIM_ORDERING,
                               cache_subdir='models')
        else:
            weights = get_file('inception_v4_weights_tf_dim_ordering_th_kernels.h5', TH_BACKEND_TF_DIM_ORDERING,
                               cache_subdir='models')
    else:
        if K.image_data_format() == "channels_first":
            weights = get_file('inception_v4_weights_th_dim_ordering_tf_kernels.h5', TF_BACKEND_TH_DIM_ORDERING,
                               cache_subdir='models')
        else:
            weights = get_file('inception_v4_weights_tf_dim_ordering_tf_kernels.h5', TH_BACKEND_TF_DIM_ORDERING,
                               cache_subdir='models')
    model.load_weights(weights, by_name=True)
    print("Model weights loaded." , weights)


def load_model(nb_classes, weights=None, freeze_until=None):
    model = create_inception_v4()
    model = tf.keras.models.Model(model.inputs, model.get_layer("logits").output)
    # load_weights(model)
    model.load_weights(filepath=weights, by_name=True)   # 从HDF5文件中加载权重到当前模型中, 默认情况下模型的结构将保持不变。如果想将权重载入不同的模型（有些层相同）中，则设置by_name=True，只有名字匹配的层才会载入权重
    if freeze_until:
        for layer in model.layers[:model.layers.index(model.get_layer(freeze_until))]:
            layer.trainable = False
    out = Dense(units=nb_classes, activation='softmax')(model.output)
    model = tf.keras.models.Model(model.inputs, out)
    return model



# data_path: raw data path(is_policeman or chinese_traffic_gesture_dataset?)
def create_data_generator(data_path):
    # labels = [
    #     "0",
    #     "1"
    # ]
    labels = [
        "pedestrian",
        "polilceman"
    ]

    # samplewise_center：布尔值，使输入数据的每个样本均值为0。
    # rescale: 将在执行其他处理前乘到整个图像上，我们的图像在RGB通道都是0~255的整数，这样的操作可能使图像的值过高或过低，所以我们将这个值定为0~1之间的数。
    train_generator = tf.keras.preprocessing.image.ImageDataGenerator(samplewise_center=True, rescale=1. / 128)
    train_gen = train_generator.flow_from_directory(
        os.path.join(data_path, "train"),      # directory: 是包含一个子目录下的所有图片这种格式，只要写到标签路径上面的那个路径即可。
        target_size=(299, 299),                # target_size：可是实现对图片的尺寸转换
        # classes=['pedestrian', 'polilceman'],
        # classes=labels,
        batch_size=8,
        shuffle=True
    )

    valid_generator = tf.keras.preprocessing.image.ImageDataGenerator(samplewise_center=True, rescale=1. / 128)
    valid_gen = valid_generator.flow_from_directory(
        os.path.join(data_path, "valid"),
        target_size=(299, 299),
        # classes=labels,
        # classes=['pedestrian', 'polilceman'],
        shuffle=True,
        batch_size=8
    )
    print(train_gen.class_indices)
    return train_gen, valid_gen



def main():
    print("haha")
    predict_gusture = 1
    if predict_gusture == 1:
        data_path = "/home/pq/gusture/traffic-gesture-recognition/datasets/chinese_traffic_gesture_dataset/"
    else:
        data_path = "/home/pq/gusture/traffic-gesture-recognition/datasets/is_policeman_dataset/"
    # data_path = "/home/pq/gusture/traffic-gesture-recognition/datasets/is_policeman_dataset/"
    # data_path = "/home/pq/gusture/traffic-gesture-recognition/datasets/chinese_traffic_gesture_dataset/"
    # save_path = "/home/pq/gusture/traffic-gesture-recognition/datasets/is_policeman_dataset/"
    save_path = "/home/pq/gusture/traffic-gesture-recognition/datasets/chinese_traffic_gesture_dataset/"
    weight_path = "/home/pq/gusture/traffic-gesture-recognition/datasets/inception_v4_weights_tf_dim_ordering_th_kernels.h5"
    epochs = 3000
    freeze_until = None

    train_gen, valid_gen = create_data_generator(data_path)

    model = load_model(nb_classes=len(train_gen.class_indices), weights=weight_path, freeze_until=freeze_until)
    model.compile(
        loss="categorical_crossentropy",
        optimizer=tf.keras.optimizers.RMSprop(lr=0.002, decay=0.001),
        metrics=["accuracy"]
    )
    model.fit_generator(
        train_gen,
        steps_per_epoch=100, # steps_per_epoch: 一个epoch分成多少个batch_size
        validation_data=valid_gen,
        validation_steps=20,
        epochs=epochs,
        callbacks=[
            tf.keras.callbacks.ModelCheckpoint(os.path.join(save_path, "weights.{epoch:02d}-{val_loss:.2f}.hdf5"), monitor='val_loss', verbose=0, save_best_only=False, save_weights_only=False, mode='auto', period=100),
        ]
    )
    print("save model")
    if predict_gusture == 1:
        model.save("/home/pq/gusture/traffic-gesture-recognition/datasets/gesture.h5")
    else:
        model.save("/home/pq/gusture/traffic-gesture-recognition/datasets/policeman.h5")
    # model.save("/home/pq/gusture/traffic-gesture-recognition/datasets/policeman.h5")
    # model.save("/home/pq/gusture/traffic-gesture-recognition/datasets/gesture.h5")
    # model.save("gesture.h5")


# sudo pip3 --default-timeout=100 install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com tensorflow-gpu==1.4.0
if __name__ == "__main__":
    main()
