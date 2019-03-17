import java.awt.Robot;
import java.awt.event.*;

robot = java.awt.Robot;

%% Control mouse
% single press
figure(gcf);  % the focus of figure
drawnow;

robot.mousePress(java.awt.event.InputEvent.BUTTON1_MASK);
robot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);

% double press
figure(gcf);
drawnow;
robot.mousePress(java.awt.event.InputEvent.BUTTON1_MASK);
robot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);
robot.mousePress(java.awt.event.InputEvent.BUTTON1_MASK);
robot.mouseRelease(java.awt.event.InputEvent.BUTTON1_MASK);

%% Control Keyboard 
robot.keyPress(java.awt.event.KeyEvent.VK_CONTROL);
robot.keyPress(java.awt.event.KeyEvent.VK_P);


