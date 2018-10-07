
%% 进行Q学习
maze = MazeEnv();
RL = QLearningTable(1, 0.1, 0.01, 0.9);
for episode = 1:300
    [~, observation] = maze.reset();    % 回到起点
    stepNum = 0;        % 统计到终点所用的步数
    while true
        done = 0;
        stepNum = stepNum+1;
        maze.render();   % 刷新环境显示
        action = RL.chooseAction(observation);
        [maze, nextObservation, reward, done] = maze.step(action);
        % 学习
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



%% 随机在网格中游走
% maze = MazeEnv();
% maze.reset();
% maze.gridColor = [1,1,1,1; 1,1,4,1; 1,4,3,1; 2,1,1,1];
% maze = maze.step(1); % 下
% maze.step(2);   % 右
% maze.step(3);   % 左
% maze.step(4);   % 上

% for episode = 1 : 1000000000
%     action = ceil(rand()*4);
%     maze = maze.step(action);
% end


%% matlab调用python
% pyversion;

% if count(py.sys.path, '') == 0
%     insert(py.sys.path.int32(0), '');
% end

% import py.run_this.*;
% import py.maze_env.*;
% import py.RL_brain.*;
% 
% env = Maze();