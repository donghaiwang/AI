
maze = MazeEnv();
maze.reset();
% maze.gridColor = [1,1,1,1; 1,1,4,1; 1,4,3,1; 2,1,1,1];
maze.step(1); % 下
% maze.step(2);   % 右
% maze.step(3);   % 左
maze.step(4);   % 上
% maze.render();
% disp(maze.AgentPosition);
% for episode = 1 : 100
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