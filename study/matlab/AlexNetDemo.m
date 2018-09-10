% camList = webcamlist;     % �鿴���Եõ�������ͷ���б�
camera = webcam;            % ������ͷ��������
% preview(camera);          % �����鿴����ͷ����ʾ���
nnet = alexnet;

fig = figure;
% set(fig, 'CloseRequestFcn', @my_closereq)
while true
    picture = camera.snapshot;
    picture = imresize(picture, [227, 227]);
    label = classify(nnet, picture);
    imshow(picture);
    title(char(label));
    drawnow;        % ��������ͼ����ʾ�������������Ļص�
end

clear camera; % �ر�����ͷ
