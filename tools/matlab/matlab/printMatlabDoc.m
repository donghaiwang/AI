import java.awt.Robot;
import java.awt.event.*;

robot = java.awt.Robot;
    
% clean destination folder
delete('d:\tmp\*');

toolboxName = 'matlab';
dirs = dir(docroot);
for d = 1 : length(dirs)
    toolboxName = dirs(d).name;
    if strcmpi(toolboxName, '.') == 1 || strcmpi(toolboxName, '..') == 1 || dirs(d).isdir == 0
        continue;
    end
    
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
end





