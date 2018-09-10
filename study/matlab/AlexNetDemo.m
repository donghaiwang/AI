% camList = webcamlist;     % 查看可以得到的摄像头的列表
camera = webcam;            % 和摄像头建立连接
% preview(camera);          % 仅仅查看摄像头的显示情况
nnet = alexnet;

fig = figure;
% set(fig, 'CloseRequestFcn', @my_closereq)
while true
    picture = camera.snapshot;
    picture = imresize(picture, [227, 227]);
    label = classify(nnet, picture);
    imshow(picture);
    title(char(label));
    drawnow;        % 立即更新图形显示，并处理待处理的回调
end

clear camera; % 关闭摄像头
