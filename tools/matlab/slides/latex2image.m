function I = latex2image(latexstr,outputfile)
% latex2image - Convert a latex equation into an image.
%
% Usage:
%     I = latex2image(latexstr);
%     I = latex2image(latexstr,outputfile);
%
% Inputs:
%     latexstr:     Latex string to convert
%                   Character row vector
%                   Example: 'e^{\pi i} + 1 = 0'
%
%     outputfile:   Output image file where the latex image should be stored
%                   Character row vector
%                   Example: 'test.png'
%                            'C:\Documents\MATLAB\html\test.png'
%
% Outputs:
%     I: Image of latex as a matrix.
%
% Examples:
%
%    %% Example 1: Convert latex to image and get image result
%    I = latex2image('e^{\pi i} + 1 = 0');
%    imshow(I)
%
%    %% Example 2: Convert latex to a new file
%    latex2image('\int_0^x\!\int_y dF(u,v) + 3','testLatex2Image.png')
%    imshow('testLatex2Image.png')
%
% See Also: publish, latex
%

% Copyright 2015 The MathWorks, Inc.
% Sean de Wolski, MathWorks

% Error checking
% Does not work in deployed environment because it relies on publish
if ismcc || isdeployed
    error('latex2image:notdeployable','latex2image cannot be deployed')
end
narginchk(1,2)
validateattributes(latexstr,{'char'},{'row'},mfilename,'latexstr',1);

% Unique file names and reset.
rngseed = rng('shuffle');
cleaner = onCleanup(@()rng(rngseed));

%% Build directory and file name

% 'latex' directory in tempdir
dirname = fullfile(tempdir,'latex');
if ~isdir(dirname)    
    mkdir(dirname)
end

% Random filename
alphabet = 'a':'z';
filename = fullfile(dirname,[alphabet(randi(26,1,7)) '.m']);

%% Write MATLAB File with latex string
fid = fopen(filename,'w');
fprintf(fid,'%%%%\n%%\n%% $$ %s$$\n%%\n',latexstr);
fclose(fid);

%% Publish
addpath(dirname)
publish(filename);
rmpath(dirname)

%% Html directory and image name
htmldir = fullfile(dirname,'html');
[~, justfile, ~] = fileparts(filename);
imgname = dir([htmldir filesep justfile '*.png']);
imgfullfile = fullfile(htmldir,imgname(1).name);

%% Read it for first output
if nargout
    I = imread(imgfullfile);
end

%% Move to outputfile if necessary
if nargin > 1
    try
        validateattributes(outputfile,{'char'},{'row'},mfilename,'outputfile',1);
        copyfile(imgfullfile,outputfile);
    catch ME
        warning('latex2image:unableToCopy',ME.message);
    end
end

end

% Copyright (c) 2015, The MathWorks, Inc.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
