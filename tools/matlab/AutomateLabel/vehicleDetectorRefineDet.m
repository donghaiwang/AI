function detector = vehicleDetectorRefineDet(varargin)

refineDetProjectDir = [pwd filesep 'TF_RefineDet_CIDI3'];
if count(py.sys.path, refineDetProjectDir) == 0
    insert(py.sys.path, int32(0), refineDetProjectDir);
end

% https://ww2.mathworks.cn/matlabcentral/answers/265247-importing-custom-python-module-fails?s_tid=srchtitle
% conda uninstall hdf5
% conda uninstall h5py
% pip uninstall hdf5
% pip uninstall h5py
refineDet = py.importlib.import_module('RefineDet');
py.importlib.reload(refineDet);
detector = refineDet.init();

% image_name_1 = '/home/laoli/rl/VisualTracking_DRL/car/tmp/1.jpg';
% test_image_1 = imread(image_name_1);
% % Conversion of MATLAB 'uint8' to Python is only supported for 1-N vectors.
% detectRes1 = refineDetModel.detect(py.str(image_name_1));
% 
% disp(detectRes1);
% for i = 1 : length(detectRes1)
%     boxList = detectRes1{i};
%     x1 = double(boxList{1});
%     y1 = double(boxList{2});
%     x2 = double(boxList{3});
%     y2 = double(boxList{4});
%     test_image_1 = insertObjectAnnotation(test_image_1, 'rectangle', [x1 y1 x2-x1 y2-y1], '', 'Color', 'yellow', ...
%         'FontSize', 10, 'TextBoxOpacity', .8, 'LineWidth', 2);
% end
% imshow(test_image_1);
% disp(length(detectRes1));

% detector = loadModel(name);


