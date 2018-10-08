function selectedBbox = pedDetect_predict(img)
%#codegen

% Copyright 2017 The MathWorks, Inc.

% function for predicting the pedestrians
% A persistent object pednet is used to load the series network object.
% At the first call to this function, the persistent object is constructed and
% setup. When the function is called subsequent times, the same object is reused 
% to call predict on inputs, thus avoiding reconstructing and reloading the
% network object.

coder.gpu.kernelfun;

persistent pednet;
if isempty(pednet) 
    pednet = coder.loadDeepLearningNetwork(coder.const('PedNet.mat'),'Pedestrian_Detection');
end

[imgHt , imgWd , ~] = size(img);
VrHt = [imgHt - 30 , imgHt]; % 利用人身高的先验（类似标定板）获得两条线 Two bands of vertical heights are considered

% patchHt and patchWd are obtained from heat maps (heat map here refers to
% pedestrians data represented in the form of a map with different
% colors. Different colors indicate presence of pedestrians at various
% scales).
patchHt = 300; 
patchWd = patchHt/3;

% PatchCount is used to estimate number of patches per image
PatchCount = ((imgWd - patchWd)/20) + 2;  % 估计每幅图像候选框的数目(29)
maxPatchCount = PatchCount * 2;           % 每幅图像最多候选框的数目(58)
Itmp = zeros(64 , 32 , 3 , maxPatchCount);  % 存放候选框数组(64x32x3x58)
ltMin = zeros(maxPatchCount);               % 58x58
lttop = zeros(maxPatchCount);               % 58x58

idx = 1; % 统计从滑动窗口中获得的候选行人的数目 To count number of image patches obtained from sliding window
cnt = 1; % 统计当前图像中预测为行人的数目 To count number of patches predicted as pedestrians

bbox = zeros(maxPatchCount , 4);            % 存放检测出来行人框(58x4)
value = zeros(maxPatchCount , 1);           % 存放检测出来行人框对应的置信度(58x1)

%% Region proposal for two bands
for VrStride = 1 : 2  % 垂直方向获取候选框的步长为2
    for HrStride = 1 : 20 : (imgWd - 60)  % 以步长为20获得水平方向的候选行人框 Obtain horizontal patches with stride 20.
        ltMin(idx) = HrStride + 1;
        rtMax = min(ltMin(idx) + patchWd , imgWd);
        lttop(idx) = (VrHt(VrStride) - patchHt);  % 候选框离原图顶部的距离
        It = img(lttop(idx): VrHt(VrStride) , ltMin(idx) : rtMax , :);
        Itmp(:,:,:,idx) = imresize(It,[64,32]);  % 将切分获得的候选行人框缩放到[64x32]
        idx = idx + 1;
    end
end

for j = 1 : size (Itmp,4)
    score = pednet.predict(Itmp(:,:,:,j)); % Classify ROI
    % accuracy of detected box should be greater than 0.90
    if (score(1,2) > 0.80)
        bbox(cnt,:) = [ltMin(j),lttop(j), patchWd , patchHt];
        value(cnt,:) = score(1,2);
        cnt = cnt + 1;
    end
    
end

%% NMS to merge similar boxes
if ~isempty(bbox)
    [selectedBbox,~] = selectStrongestBbox(bbox(1:cnt-1,:),...
        value(1:cnt-1,:),'OverlapThreshold',0.002);
end
    
