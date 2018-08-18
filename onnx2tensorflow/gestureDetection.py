import onnx
from onnx_tf.backend import prepare
import numpy as np
from scipy.misc import imread, imresize
import cv2

def py_cpu_nms(dets, thresh):
    """Pure Python NMS baseline."""
    x1 = dets[:, 0]
    y1 = dets[:, 1]
    x2 = dets[:, 2]
    y2 = dets[:, 3]
    scores = dets[:, 4]  # bbox打分

    areas = (x2 - x1 + 1) * (y2 - y1 + 1)
    # 打分从大到小排列，取index
    order = scores.argsort()[::-1]
    keep = []  # keep为最后保留的边框
    while order.size > 0:
        i = order[0]    # order[0]是当前分数最大的窗口，肯定保留
        keep.append(i)  # 计算窗口i与其他所有窗口的交叠部分的面积
        xx1 = np.maximum(x1[i], x1[order[1:]])
        yy1 = np.maximum(y1[i], y1[order[1:]])
        xx2 = np.minimum(x2[i], x2[order[1:]])
        yy2 = np.minimum(y2[i], y2[order[1:]])

        w = np.maximum(0.0, xx2 - xx1 + 1)  # 取两个向量的较小值
        h = np.maximum(0.0, yy2 - yy1 + 1)  # 取两个向量的较大值，不大于0就取0
        inter = w * h    # 两个框的交集
        # 交/并得到iou值
        ovr = inter / (areas[i] + areas[order[1:]] - inter)
        # inds为所有与窗口i的iou值小于threshold值的窗口的index，其他窗口此次都被窗口i吸收
        inds = np.where(ovr <= thresh)[0]
        # order里面只保留与窗口i交叠面积小于threshold的那些窗口，由于ovr长度比order长度少1(不包含i)，所以inds+1对应到保留的窗口
        order = order[inds + 1]

    return keep


def detectGesture():
    """交警动作识别"""
    gestureModel = onnx.load('assets/gesture.onnx')
    gestureTF = prepare(gestureModel)  # tf_rep是一个python类，里面包含predict_net
    #
    pedModel = onnx.load('assets/pedNet.onnx')
    ped_tf = prepare(pedModel)
    #
    isPoliceModel = onnx.load('assets/isPoliceman.onnx')
    isPoliceTF = prepare(isPoliceModel)

    imgRaw = imread('assets/test.jpg', mode='RGB')
    imgHt = 480
    imgWd = 640
    img = imresize(imgRaw, (imgHt, imgWd))  # [高度，宽度，深度]
    VrHt = [imgHt - 30, imgHt]

    nmsThresh = 0.1
    labels = {0: 'go_straight', 1: 'park_right', 2: 'stop', 3: 'turn_right'}

    patchHt = 300
    patchWd = patchHt / 3

    PatchCount = ((imgWd - patchWd) / 20) + 2
    maxPatchCount = int(PatchCount * 2)
    Itmp = np.zeros((64, 32, 3, maxPatchCount))
    ltMin = np.zeros((maxPatchCount))
    lttop = np.zeros((maxPatchCount))

    idx = 0  # To count number of image patches obtained from sliding window
    cnt = 0  # To count number of patches predicted as pedestrians

    bbox = np.zeros((maxPatchCount, 5))  # 前四个为坐标，第五个为候选框的打分

    # Region proposal for two bands
    for VrStride in range(2):
        for HrStride in range(1, (imgWd - 60), 20):  # Obtain horizontal patches with stride 20.
            ltMin[idx] = HrStride
            rtMax = min(ltMin[idx] + patchWd, imgWd)
            lttop[idx] = (VrHt[VrStride] - patchHt)
            cropHeightStart = (int)(lttop[idx])
            cropHeightEnd = VrHt[VrStride]
            cropWidthStart = (int)(ltMin[idx])
            cropWidthEnd = (int)(rtMax)
            It = img[cropHeightStart:cropHeightEnd, cropWidthStart:cropWidthEnd]
            imageRezied = imresize(It, (64, 32))
            idx = idx + 1

            transposeTmpImg = imageRezied.transpose((-1, 0, 1))  # transpose image shape from (H, W, D) to (D, H, W)
            imageExtended = np.asarray(transposeTmpImg, dtype=np.float32)[np.newaxis, :, :]
            score = ped_tf.run(imageExtended)
            score = score.softmax
            score = score[0][1]
            if (score > 0.80):
                bbox[cnt][0] = cropHeightStart
                bbox[cnt][1] = cropWidthStart
                bbox[cnt][2] = cropHeightStart + patchHt
                bbox[cnt][3] = cropWidthStart + patchWd
                bbox[cnt][4] = score
                cnt = cnt + 1

    keepBBoxIndex = py_cpu_nms(bbox, nmsThresh)  # 非最大值抑制来合并相似的候选框

    for imgIndex in keepBBoxIndex:
        selectedBox = bbox[imgIndex]
        if selectedBox[4] > 0.80:
            print(bbox[imgIndex])
            leftUpX = (int)(selectedBox[0])
            leftUpY = (int)(selectedBox[1])
            rightDownX = (int)(selectedBox[2])
            rightDownY = (int)(selectedBox[3])
            cv2.rectangle(img, (leftUpY, leftUpX), (rightDownY, rightDownX), (0, 255, 0), 4)  # 将检测出的行人框出来（显示在图上）

            cropImg = img[leftUpX:rightDownX, leftUpY:rightDownY]  # 裁剪出行人的图片

            cropImg = imresize(cropImg, (224, 224))  # 缩放成检测警察的网络所适应的大小
            pedestrianImg = cropImg.transpose((-1, 0, 1))  # transpose image shape from (H, W, D) to (D, H, W)
            pedestrianImg = np.asarray(pedestrianImg, dtype=np.float32)[np.newaxis, :, :]

            predictPolice = isPoliceTF.run(pedestrianImg)  # 判断是否是警察
            predictPolice = predictPolice.softmax
            if predictPolice[0][1] > predictPolice[0][0]:
                isPoliceText = "police: " + str(predictPolice[0][1])
            else:
                isPoliceText = "pedestrian: " + str(predictPolice[0][0])
            cv2.putText(img, isPoliceText, (leftUpY, leftUpX), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

            predictRes = gestureTF.run(pedestrianImg)
            acitonProbs = predictRes.softmax
            maxPosition = np.argmax(acitonProbs)  # 取最大元素的下标
            cv2.putText(img, 'action: ' + labels[maxPosition], (leftUpY, leftUpX + 30), cv2.FONT_HERSHEY_SIMPLEX, 1,
                        (0, 0, 255), 2)

    cv2.imshow('img', img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()


if __name__ == '__main__':
    detectGesture()
