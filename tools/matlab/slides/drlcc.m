function drlcc()
%DRLCC PPT-based report
%
%   This report is based on the open source project: "Multi-Target, 
%   Multi-Camera Tracking". That report was generated using MATLAB Publish.
%   This report is generated using the PPT API. This report is intended to
%   illustrate a simple use of the API.
%
%   drlcc() generates a MS PowerPoint presentation.

% This statement eliminates the need to qualify the names of PPT
% objects in this function, e.g., you can refer to 
% mlreportgen.ppt.Presentation simply as Presentation.
import mlreportgen.ppt.*;

% Create a cell array to hold images generate for this presentation. 
% That will facilitate deleting the images at the end of presentation
% generation when they are no longer needed.
images = {};
pptHome = 'D:\doc\demonstration\2019_3_25_DRLCC';
imgPath = fullfile(pptHome, 'img');

%% Create a presentation.

% Use the default template
dos('taskkill /F /IM POWERPNT.EXE');  % close opened powerpoint
pre = Presentation('drlcc');

%% Add the first slide to the presentation, based on the Title Slide layout.
% In general, PowerPoint presentations are structured in slides created 
% from predefined layouts that contains place holders which users will fill 
% in with generated content. The predefined layouts belong to a template 
% slide master that defines the styles.
slide = add(pre, 'Title Slide');

% Replace the title and subtitle in the slide, using the replace method 
% providing the placeholder name
replace(slide, 'Title', 'Multi-Target, Multi-Camera Tracking');
replace(slide, 'Subtitle', 'Haidong Wang(haidong@hnu.edu.cn)');


%% 1.1 Add the second slide to the presentation based on Title and Content layout.
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'Tracking Modeling Approach');
% Add some bullets text to the Content placeholder, using a cell array
replace(slide, 'Content', { ...
    'Single object tracking using Action-Decision Network(ADNet)' ...
	'Mutil-object tracking using Collaborative Deep Reinforcement Learning(CDRL)' ...
	'Multi-Target, Multi-Camera Tracking' ...
	'Multi-Target, Multi-Camera Tracking using Hierarchy Deep Reinforcement Learning'});


%% 1.2 Dataset
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'The Dataset for Multi-Target, Multi-Camera Tracking');

% mapLargeImg = fullfile(imgPath, '1_0_map_large.png');
% replace(slide, 'Content', Picture(mapLargeImg));
sampleVideo = fullfile(imgPath, 'video_samples.mp4');
p = Paragraph('This is a link to the sample video');
link = ExternalLink(sampleVideo,' Duke University');
append(p,link);
replace(slide, 'Content', p);

%% 1.3 Multi-Target Multi-Camera Tracking and Re-Identification
slide = add(pre, 'Comparison');
replace(slide, 'Title', 'Multi-Target Multi-Camera Tracking and Re-Identification');

replace(slide, 'Left Text', 'Tracking Results');
leftImg = fullfile(imgPath, '1_1_example.bmp');
replace(slide, 'Left Content', Picture(leftImg));

replace(slide, 'Right Text', 'Tracking Pipeline');
rightImg = fullfile(imgPath, '1_2_stream.PNG');
replace(slide, 'Right Content', Picture(rightImg));


%% 2.1 Add the fourth slide to the presentation based on Comparison layout.
slide = add(pre, 'Comparison');
replace(slide, 'Title', 'Single object tracking using Action-Decision Network');

replace(slide, 'Left Text', 'Action Sequence');
actionSequenceImg = fullfile(imgPath, '2_1_adnetActionSequence.png');
replace(slide, 'Left Content', Picture(actionSequenceImg));

% Replace Right Text and Right Content.
replace(slide, 'Right Text', 'Network Architecture');
adnetArchitectureImg = fullfile(imgPath, '2_2_adnetNet.png');
replace(slide, 'Right Content', Picture(adnetArchitectureImg));

%% 3.1 Add the last slide to the presentation based on Title and Content layout.
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'Multi-Object Tracking Using Collaborative Deep Reinforcement Learning');

cdrlImg = fullfile(imgPath, '3_1_CDRL.PNG');
replace(slide, 'Content', Picture(cdrlImg));

%% 4.1 RiID
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'Multi-shot Pedestrian Re-identification using Deep Reinforcement Learning');

cdrlImg = fullfile(imgPath, '4_1_reid.PNG');
replace(slide, 'Content', Picture(cdrlImg));

%% 5.1 drlcc
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'Multi-Target, Multi-Camera Tracking using Hierarchy Deep Reinforcement Learning');

cdrlImg = fullfile(imgPath, '5_drlcc.png');
replace(slide, 'Content', Picture(cdrlImg));



%% Finally, close the presentation and open it in Windows
close(pre);
if ispc
    winopen(pre.OutputPath);
end

% Closing the presentation causes the images needed for the
% presentation to be copied into it. So we can now delete them.
for i = 1:length(images)
    delete(images{i});
end

end


%%
function imgname = printPlot(name)
% Convert the specified plot to an image.
% Return the image name so it can be deleted at the
% end of presentation generation.
import mlreportgen.ppt.*;

% Select an appropriate image type, depending
% on the platform.
if ~ispc
    imgtype = '-dpng';
    imgname= [name '.png'];
else
    % This Microsoft-specific vector graphics format
    % can yield better quality images in Word documents.
    imgtype = '-dmeta';
    imgname = [name '.emf'];
end

% Convert figure to the specified image type.
print(imgtype, imgname);

% Delete plot figure window.
delete(gcf);

end


