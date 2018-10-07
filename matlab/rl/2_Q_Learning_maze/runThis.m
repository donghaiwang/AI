
%% ����Qѧϰ
maze = MazeEnv();
RL = QLearningTable(1, 0.1, 0.01, 0.9);
for episode = 1:300
    [~, observation] = maze.reset();    % �ص����
    stepNum = 0;        % ͳ�Ƶ��յ����õĲ���
    while true
        done = 0;
        stepNum = stepNum+1;
        maze.render();   % ˢ�»�����ʾ
        action = RL.chooseAction(observation);
        [maze, nextObservation, reward, done] = maze.step(action);
        % ѧϰ
        RL = RL.learn(observation, action, reward, nextObservation);
        observation = nextObservation;
        
        if mod(episode, 10) == 0
            disp(RL.QTable);
        end
        if done == 1
            disp(stepNum);
        end
        
        if done ~= 0
            maze = maze.reset();
            break;
        end

        pause(0.5);
    end
end



%% ���������������
% maze = MazeEnv();
% maze.reset();
% maze.gridColor = [1,1,1,1; 1,1,4,1; 1,4,3,1; 2,1,1,1];
% maze = maze.step(1); % ��
% maze.step(2);   % ��
% maze.step(3);   % ��
% maze.step(4);   % ��

% for episode = 1 : 1000000000
%     action = ceil(rand()*4);
%     maze = maze.step(action);
% end


%% matlab����python
% pyversion;

% if count(py.sys.path, '') == 0
%     insert(py.sys.path.int32(0), '');
% end

% import py.run_this.*;
% import py.maze_env.*;
% import py.RL_brain.*;
% 
% env = Maze();