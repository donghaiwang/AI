import java.awt.Robot;
import java.awt.event.*;

robot = java.awt.Robot;
    
% clean destination folder
delete('d:\tmp\*');

%%
% docContents = dir(docroot);
% for j = 1 : length(docContents)
%     if docContents(j).isdir == 1
%         toolboxName = docContents(j).name;
%         
%         matlabExamplePath = fullfile(docroot, toolboxName, 'examples');
%         matlabExamples = dir(fullfile(matlabExamplePath, '*.html'));
%         for i = 1 : length(matlabExamples)
%             web(fullfile(matlabExamplePath, matlabExamples(i).name));
%             pause(5);
%             
%             % Ctrl+P
%             robot.keyPress(java.awt.event.KeyEvent.VK_CONTROL);
%             robot.keyPress(java.awt.event.KeyEvent.VK_P);
%             
%             % Enter to confirm
%             pause(2);
%             robot.keyPress(java.awt.event.KeyEvent.VK_ENTER);
%             pause(2);
%             robot.keyPress(java.awt.event.KeyEvent.VK_ENTER);
%             
%             pause(20);
%             % Ctrl+W: close pdf
%             robot.keyPress(java.awt.event.KeyEvent.VK_CONTROL);
%             robot.keyPress(java.awt.event.KeyEvent.VK_W);
%             pause(5);
%         end
%         
%     end
% end

toolboxName = 'matlab';
matlabExamplePath = fullfile(docroot, toolboxName, 'examples');
matlabExamples = dir(fullfile(matlabExamplePath, '*.html'));
for i = 1 : length(matlabExamples)
    web(fullfile(matlabExamplePath, matlabExamples(i).name));
    pause(5);
    
    % Ctrl+P
    robot.keyPress(java.awt.event.KeyEvent.VK_CONTROL);
    robot.keyPress(java.awt.event.KeyEvent.VK_P);
    
    % Enter to confirm
    pause(2);
    robot.keyPress(java.awt.event.KeyEvent.VK_ENTER);
    pause(2);
    robot.keyPress(java.awt.event.KeyEvent.VK_ENTER);
    
    pause(20);
    % Ctrl+W: close pdf
    robot.keyPress(java.awt.event.KeyEvent.VK_CONTROL);
    robot.keyPress(java.awt.event.KeyEvent.VK_W);
    pause(5);
end



