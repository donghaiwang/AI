% pyversion;

import py.gym.*;

%% 
% ��һ��С������������һ�����ӡ�С����Ҫ�����ƶ������ָ�����ֱ��
% ���������б�ĽǶȴ���15�㣬��ô��Ϸ������
% С��Ҳ�����ƶ���һ����Χ���м䵽���߸�2.4����λ���ȣ�
env = make('CartPole-v0');  % ʹ�� gym ���е������ӻ���
env = env.unwrapped;

disp(env.action_space);         % ���������������������
disp(env.observation_space);
disp(env.observation_space.high);
disp(env.observation_space.low);

actionNum = int64(env.action_space.n);
featuresNum = cell(env.observation_space.shape);
featuresNum = int64(featuresNum{1,1});

RL = DeepQNetwork(actionNum, featuresNum, 0.01, 0.9, 0.9, 100, 2000, 32);

total_steps = 0;

for i_episode = 1:10
    observation = double(env.reset());  % ndarray -> double array
    epReward = 0;
    while true
        env.render();                   % ������ʾ�Ĵ��ڹز��������У�clear classes ���� clear all
        
        action = int32(RL.chooseAction(observation)); 
        action = int32(action-1);      % python���±��Ǵ�0��ʼ������1,2��Ӧ��python����0,1
        if action < 0                  % ��֪��Ϊ�λ����-1����action=0�����
            action = int32(0);
        end
        stepRet = cell(env.step(action));   % tuple(list) -> cell
        nextObservation = double(stepRet{1,1});     % ϸ�ֿ�, Ϊ���޸�ԭ��� reward
        x = nextObservation(1,1);
        xDot = nextObservation(1,2);
        theta = nextObservation(1,3);
        thetaDot = nextObservation(1,4);
        
        reward = int64(stepRet{1,2});   % ��ǰ����õĽ���
        done = int64(stepRet{1,3});     % ��ǰ�غ��Ƿ����
        
        r1 = (env.x_threshold - abs(x)) / env.x_threshold - 0.8;    %  x �ǳ���ˮƽλ��, ���� r1 �ǳ�Խƫ������, ��Խ��
        r2 = (env.theta_threshold_radians - abs(theta)) / env.theta_threshold_radians - 0.5;    % theta �ǰ����봹ֱ�ĽǶ�, �Ƕ�Խ��, Խ����ֱ. ���� r2 �ǰ�Խ��ֱ, ��Խ��
        reward = r1+r2;     % �� reward �� r1 �� r2 �Ľ��, �ȿ���λ��, Ҳ���ǽǶ�, ���� DQN ѧϰ����Ч��
        
        RL.storeTransition(observation, action, reward, nextObservation);   % ������һ�����
        
        epReward = epReward + reward;
        if total_steps > 1000
            % ÿ1000������һ��ѧϰ
        end
        
        disp(i_episode);
        if done
            disp(i_episode);
            break;
        end
        
        observation = nextObservation;
        total_steps = total_steps + 1;
    end
end

% ������ʧ�仯����
% pause(3);
clear classes  % ����ز����Ĵ��ڣ�����Ҫ�ֺţ��зֺŲ����ܹرմ��ڣ�
% clear classes


