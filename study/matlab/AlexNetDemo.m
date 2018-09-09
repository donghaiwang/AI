% �鿴���Եõ�������ͷ���б�
% camList = webcamlist;
camera = webcam;
nnet = alexnet;

figure;
while true
    picture = camera.snapshot;
    picture = imresize(picture, [227, 227]);
    label = classify(nnet, picture);
    imshow(picture);
    title(char(label));
    drawnow;
end

clear camera;
