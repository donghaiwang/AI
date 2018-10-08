load('gesture.mat', 'net');
exportONNXNetwork(net, 'gesture.onnx');

% %% Export to ONNX model format 
% net = squeezenet; % Pretrained Model to be exported 
% filename = 'squeezenet.onnx'; 
% exportONNXNetwork(net,filename);
% 
% %% Import the network that was exported 
% net2 = importONNXNetwork('squeezenet.onnx', 'OutputLayerType', 'classification'); 
% 
% % Compare the predictions of the two networks on a random input image 
% img = rand(net.Layers(1).InputSize); 
% y = predict(net, img); 
% y2 = predict(net2,img); 
% 
% max(abs(y-y2))