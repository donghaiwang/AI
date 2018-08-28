
%% Detect Vehicles on Highway
% Detect cars in a single image and annotate the image with the detection scores. To detect cars, use a Faster R-CNN object detector that was trained using images of vehicles.
% Load the pretrained detector.
fasterRCNN = vehicleDetectorFasterRCNN('full-view');

% Use the detector on a loaded image. Store the locations of the bounding boxes and their detection scores.
% I = imread('highway.png');
% [bboxes,scores] = detect(fasterRCNN, I);

% Annotate the image with the detections and their scores.
% I = insertObjectAnnotation(I,'rectangle',bboxes,scores);
% figure
% imshow(I)
% title('Detected Vehicles and Detection Scores')

%% Use own image
saveVideoName = fullfile('..', 'data', 'test', 'image.avi');
aviobj = VideoWriter(saveVideoName);
open(aviobj);

testImagePath = fullfile('..', 'data', 'test', 'image');
testImageDataStore = imageDatastore(testImagePath);
testImageFiles = testImageDataStore.Files;
figure;
for i = 1 : length(testImageFiles)
    testImage = imread(testImageFiles{i});
    [bboxes, scores] = detect(fasterRCNN, testImage);
    testImage = insertObjectAnnotation(testImage, 'rectangle', bboxes, scores);
    imshow(testImage);
    writeVideo(aviobj, testImage);
end
close(aviobj);

