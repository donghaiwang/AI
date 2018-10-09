
%% ����Sarsa Lambdaѧϰ
maze = MazeEnv();
RL = SarsaLambdaTable(1, 0.1, 0.01, 0.9, 0.9);
for episode = 1:300
    [~, observation] = maze.reset();    % �ص����
    stepNum = 0;        % ͳ�Ƶ��յ����õĲ���
    action = RL.chooseAction(observation);      % �Ȳ�ȡ�ж�����Qѧϰ������
    while true
        done = 0;
        stepNum = stepNum+1;
        maze.render();   % ˢ�»�����ʾ
        [maze, nextObservation, reward, done] = maze.step(action);      % ����֮���ٴ�ѡ���ж���Ϊ��ѧϰ���ѡ����ж�
        nextAction = RL.chooseAction(observation);
        % ѧϰp
        RL = RL.learn(observation, action, reward, nextObservation, nextAction);
        
        observation = nextObservation;
        action = nextAction;            % ��ǰ�ж�����һ���ж���Ϊ��һ���ĵ�ǰ�ж���ѧϰѡ����ж�����QѧϰѧϰQֵ�����ж�����һ����ѡ����ж����и����ѡ�����Ĺ��̣���
        
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
