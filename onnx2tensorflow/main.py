import onnx
from onnx_tf.backend import prepare
import numpy as np
from scipy.misc import imread, imresize

model = onnx.load('assets/gesture.onnx')
tf_rep = prepare(model)  # tf_rep是一个python类，里面包含predict_net
print(tf_rep.predict_net)

img = imread('assets/stop.jpg', mode='RGB')
img = imresize(img, (224, 224))  # [高度，宽度，深度]

transposeImg = img.transpose((-1, 0, 1))  # transpose image shape from (H, W, D) to (D, H, W)
disposedImg = np.asarray(transposeImg, dtype=np.float32)[np.newaxis, :, :]

predictRes = tf_rep.run(disposedImg)
probs = predictRes.softmax

maxPosition = np.argmax(probs)  # 取最大元素的下标
labels = {0:'go_straight', 1:'park_right', 2:'stop', 3:'turn_right'}
print(labels[maxPosition])



# 为推断准备输入
# import numpy as np
# from PIL import Image
# img = Image.open('assets/super-res-input.jpg').resize((224, 224))  # 将图片调整为神经网络能够接受的输入大小
# # display(img) # show the image
# # Y'和Y是不同的，而Y就是所谓的流明(luminance)，表示光的浓度且为非线性，使用伽马修正(gamma correction)编码处理
# img_ycbcr = img.convert("YCbCr")  #　Y'为颜色的亮度(luma)成分、而CB和CR则为蓝色和红色的浓度偏移量成份
# img_y, img_cb, img_cr = img_ycbcr.split()
# doggy_y = np.asarray(img_y, dtype=np.float32)[np.newaxis, np.newaxis, :, :]
#
#
# # 运行神经网络
# big_doggy = tf_rep.run(doggy_y)._0
# print(big_doggy.shape)
#
#
# # 检测神经网络推断结果
# img_out_y = Image.fromarray(np.uint8(big_doggy[0, 0, :, :].clip(0, 255)), mode='L')
# result_img = Image.merge("YCbCr", [
#     img_out_y,
#     img_cb.resize(img_out_y.size, Image.BICUBIC),
#     img_cr.resize(img_out_y.size, Image.BICUBIC),
# ]).convert("RGB")
# display(result_img)
# result_img.save('output/super_res_output.jpg')

