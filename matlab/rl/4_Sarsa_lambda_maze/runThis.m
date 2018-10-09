
%% 进行Sarsa Lambda学习
maze = MazeEnv();
RL = SarsaLambdaTable(1, 0.1, 0.01, 0.9, 0.9);
for episode = 1:300
    [~, observation] = maze.reset();    % 回到起点
    stepNum = 0;        % 统计到终点所用的步数
    action = RL.chooseAction(observation);      % 先采取行动（和Q学习不动）
    while true
        done = 0;
        stepNum = stepNum+1;
        maze.render();   % 刷新环境显示
        [maze, nextObservation, reward, done] = maze.step(action);      % 走完之后再次选择行动，为了学习这次选择的行动
        nextAction = RL.chooseAction(observation);
        % 学习p
        RL = RL.learn(observation, action, reward, nextObservation, nextAction);
        
        observation = nextObservation;
        action = nextAction;            % 当前行动的下一个行动作为下一步的当前行动（学习选择的行动，而Q学习学习Q值最大的行动（不一定是选择的行动，有个随机选择动作的过程））
        
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

%         pause(0.5);
    end
end
