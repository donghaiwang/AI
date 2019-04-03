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
import mlreportgen.report.*

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


%% 5.1 drlcc
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'Multi-Target, Multi-Camera Tracking using Hierarchy Deep Reinforcement Learning');

cdrlImg = fullfile(imgPath, '5_drlcc.png');
replace(slide, 'Content', Picture(cdrlImg));


%% 2.1 
slide = add(pre, 'Comparison');
replace(slide, 'Title', 'Single object tracking using Action-Decision Network');

replace(slide, 'Left Text', 'Action Sequence');
actionSequenceImg = fullfile(imgPath, '2_1_adnetActionSequence.png');
replace(slide, 'Left Content', Picture(actionSequenceImg));

% Replace Right Text and Right Content.
replace(slide, 'Right Text', 'Network Architecture');
adnetArchitectureImg = fullfile(imgPath, '2_2_adnetNet.png');
replace(slide, 'Right Content', Picture(adnetArchitectureImg));

%% 3.1 CDRL
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'Multi-Object Tracking Using Collaborative Deep Reinforcement Learning');

cdrlImg = fullfile(imgPath, '3_1_CDRL.PNG');
replace(slide, 'Content', Picture(cdrlImg));

% collaborative
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'Collaborative Deep Reinforcement Learning');

% ,'BoxOpacity',0,'FontSize',50,'TextColor','r'
figure;
tb1_1 = insertText(ones(200,1000)*255,[50 50],'Distance from surrounding objects', 'FontSize',50);
imshow(tb1_1);
tb2_1 = insertText(ones(200,900)*255,[50 50],'Distance from detection results', 'FontSize',50);
subplot(2, 2, 1);
imshow(tb1_1);
subplot(2, 2, 3);
imshow(tb2_1);

latexstr = 'd(p_i,p_j)=\alpha(1-g(p_i,p_j))+(1-\frac{f_i^Tf_j}{\left \| f_i \right \|_2 \left \| f_j \right \|_2})';
distance2NeighborhoodImg = latex2image(latexstr);
distance2DetectionLatex = 'd(p_i,p_j^*)=\alpha(1-g(p_i,p_j^*))+(1-\frac{f_i^Tf_j^*}{\left \| f_i \right \|_2 \left \| f_j^2 \right \|_2})';
distance2DetectionImg = latex2image(distance2DetectionLatex);
subplot(2, 2, 2);
imshow(distance2NeighborhoodImg);
subplot(2, 2, 4);
imshow(distance2DetectionImg);
img = printPlot('plot1');
replace(slide, 'Content', Picture(img));
images = [images {img}];

% action table
slide = add(pre, 'Title and Table');
replace(slide, 'Title', 'Collaborative Deep Reinforcement Learning');

table1 = Table(4);

% row 1
tr1 = TableRow();
tr1.Style = {Bold(true)};

te1tr1 = TableEntry();
p = Paragraph('Visibility');
p.FontColor = 'blue';
append(te1tr1,p);

te2tr1 = TableEntry();
te3tr1.Style = {FontColor('red')};
append(te2tr1,'Reliability of Detection');

te3tr1 = TableEntry();
te3tr1.Style = {FontColor('green')};
append(te3tr1,'Content');

te4tr1 = TableEntry();
te4tr1.Style = {FontColor('green')};
append(te4tr1,'Action');

append(tr1,te1tr1);
append(tr1,te2tr1);
append(tr1,te3tr1);
append(tr1,te4tr1);

% row 2
tr2 = TableRow();
te1tr2 = TableEntry();
p = Paragraph('visible');
append(te1tr2,p);

te2tr2 = TableEntry();
append(te2tr2,'reliable');

te3tr2 = TableEntry();
append(te3tr2,'detection+tracking');

te4tr2 = TableEntry();
append(te4tr2,'update');

append(tr2,te1tr2);
append(tr2,te2tr2);
append(tr2,te3tr2);
append(tr2,te4tr2);

% row 3
tr3 = TableRow();
te1tr3 = TableEntry();
p = Paragraph('visible');
append(te1tr3,p);

te2tr3 = TableEntry();
append(te2tr3,'not reliable');

te3tr3 = TableEntry();
append(te3tr3,'tracking');

te4tr3 = TableEntry();
append(te4tr3,'ignore');

append(tr3,te1tr3);
append(tr3,te2tr3);
append(tr3,te3tr3);
append(tr3,te4tr3);

% row 4
tr4 = TableRow();
te1tr3 = TableEntry();
p = Paragraph('invisible');
append(te1tr3,p);

te2tr3 = TableEntry();
append(te2tr3,'');

te3tr3 = TableEntry();
append(te3tr3,'keep the appearance feature, use the movement model');

te4tr3 = TableEntry();
append(te4tr3,'blocked');

append(tr4,te1tr3);
append(tr4,te2tr3);
append(tr4,te3tr3);
append(tr4,te4tr3);

% row 5
tr5 = TableRow();
te1tr3 = TableEntry();
p = Paragraph('invisible');
append(te1tr3,p);

te2tr3 = TableEntry();
append(te2tr3,'');

te3tr3 = TableEntry();
append(te3tr3,'delete the object');

te4tr3 = TableEntry();
append(te4tr3,'disappears');

append(tr5,te1tr3);
append(tr5,te2tr3);
append(tr5,te3tr3);
append(tr5,te4tr3);


append(table1,tr1);
append(table1,tr2);
append(table1,tr3);
append(table1,tr4);
append(table1,tr5);

contents = find(slide,'Table');
replace(contents(1),table1);


% reward
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'Reward');
figure;
tb1_1 = insertText(ones(200,1000)*255,[10 10],'Action reward', 'FontSize', 90);
subplot(6, 2, 1);
imshow(tb1_1);
latexstr = 'r_{i,t}^*=r_{i,t}+\beta r_{j,t+1}';
formulaImg = latex2image(latexstr);
subplot(6, 2, 2);
imshow(formulaImg);

tb1_1 = insertText(ones(200,1000)*255,[10 10],'Update,ignore,block', 'FontSize', 90);
subplot(6, 2, 3);
imshow(tb1_1);
latexstr = 'r_{i,t}=1 \ \ if \ IoU\ge0.7';
formulaImg = latex2image(latexstr); %imshow(formulaImg);
subplot(6, 2, 4);
imshow(formulaImg);

tb1_1 = insertText(ones(200,1000)*255,[10 10],'', 'FontSize', 90);
subplot(6, 2, 5);
imshow(tb1_1);
latexstr = 'r_{i,t}=0 \ \ if \ 0.5 \le IoU\le0.7';
formulaImg = latex2image(latexstr); %imshow(formulaImg);
subplot(6, 2, 6);
imshow(formulaImg);

tb1_1 = insertText(ones(200,1000)*255,[10 10],'', 'FontSize', 90);
subplot(6, 2, 7);
imshow(tb1_1);
latexstr = 'r_{i,t}=-1 \ \ else';
formulaImg = latex2image(latexstr); %imshow(formulaImg);
subplot(6, 2, 8);
imshow(formulaImg);

tb1_1 = insertText(ones(200,1000)*255,[10 10],'Detete reward', 'FontSize', 90);
subplot(6, 2, 9);
imshow(tb1_1);
latexstr = '1 \ \ if \ object \ disappeared';
formulaImg = latex2image(latexstr);
subplot(6, 2, 10);
imshow(formulaImg);

tb1_1 = insertText(ones(200,1000)*255,[10 10],'', 'FontSize', 90);
subplot(6, 2, 11);
imshow(tb1_1);
latexstr = '-1 \ \ else';
formulaImg = latex2image(latexstr); %imshow(formulaImg);
subplot(6, 2, 12);
imshow(formulaImg);

img = printPlot('plot2');
replace(slide, 'Content', Picture(img));
images = [images {img}];


% Q value
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'Q Value and Policy Gradient');
figure;
tb1_1 = insertText(ones(200,1000)*255,[10 10],'Q value', 'FontSize', 90);
subplot(6, 2, 1);
imshow(tb1_1);
latexstr = 'Q(s_{i,t},a_{i,t})=r_{i,t}^*+\gamma r_{i,t+1}^*+\gamma^2r_{i,t+2}^*+...';
formulaImg = latex2image(latexstr);
subplot(6, 2, 2);
imshow(formulaImg);

tb1_1 = insertText(ones(200,1000)*255,[10 10],'Optimization', 'FontSize', 90);
subplot(6, 2, 3);
imshow(tb1_1);
latexstr = 'arg \ max L(\theta)=E_{s,a}log(\pi(a|s,\theta))Q(s,a)';
formulaImg = latex2image(latexstr); %imshow(formulaImg);
subplot(6, 2, 4);
imshow(formulaImg);

tb1_1 = insertText(ones(200,1000)*255,[10 10],'Policy Gradient', 'FontSize', 90);
subplot(6, 2, 5);
imshow(tb1_1);
latexstr = '\Delta_\theta L(\theta)=E_{s,a}\Delta_\theta log(\pi(a|s,\theta))Q(s,a) \\ \ = \ E_{s,a} \frac{Q(s,a)}{\pi(a|s,\theta)} \Delta_{\theta} \pi(a|s,\theta)';
formulaImg = latex2image(latexstr); %imshow(formulaImg);
subplot(6, 2, 6);
imshow(formulaImg);

tb1_1 = insertText(ones(200,1000)*255,[10 10],'State Value', 'FontSize', 90);
subplot(6, 2, 7);
imshow(tb1_1);
latexstr = 'V(s)=\frac{\sum_a p(a|s) Q(s,a)}{\sum_a p(a|s)}';
formulaImg = latex2image(latexstr); %imshow(formulaImg);
subplot(6, 2, 8);
imshow(formulaImg);

tb1_1 = insertText(ones(200,1000)*255,[10 10],'Advantage Value', 'FontSize', 90);
subplot(6, 2, 9);
imshow(tb1_1);
latexstr = 'A(s,a)=Q(s,a) - V(s)';
formulaImg = latex2image(latexstr); %imshow(formulaImg);
subplot(6, 2, 10);
imshow(formulaImg);

tb1_1 = insertText(ones(200,1000)*255,[10 10],'Final Policy Gradient', 'FontSize', 90);
subplot(6, 2, 11);
imshow(tb1_1);
latexstr = 'L(\theta) = E_{s,a} log(\pi(a|s,\theta))A(s,a)';
formulaImg = latex2image(latexstr); %imshow(formulaImg);
subplot(6, 2, 12);
imshow(formulaImg);

img = printPlot('plot3');
replace(slide, 'Content', Picture(img));
images = [images {img}];


%% 4.1 RiID
slide = add(pre, 'Title and Content');
replace(slide, 'Title', 'Multi-shot Pedestrian Re-identification using Deep Reinforcement Learning');

cdrlImg = fullfile(imgPath, '4_1_reid.PNG');
replace(slide, 'Content', Picture(cdrlImg));


%% End
slide = add(pre, 'Title Slide');
replace(slide, 'Title', 'Thank you');
replace(slide, 'Subtitle', 'Email: haidong@hnu.edu.cn');


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
print(imgtype, '-r0', imgname);
% print(imgname, '-dpng','-r0');

% Delete plot figure window.
delete(gcf);

end


