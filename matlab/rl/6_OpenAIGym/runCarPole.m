pyversion;

import py.gym.*;

%% 
% 有一个小车，上有竖着一根杆子。小车需要左右移动来保持杆子竖直。
% 如果杆子倾斜的角度大于15°，那么游戏结束。
% 小车也不能移动出一个范围（中间到两边各2.4个单位长度）
env = make('CartPole-v0');
env = env.unwrapped;

disp(env.action_space);         % 两个动作：向左或者向右
disp(env.observation_space);
disp(env.observation_space.high);
disp(env.observation_space.low);

actionNum = int64(env.action_space.n);
featuresNum = cell(env.observation_space.shape);
featuresNum = int64(featuresNum{1,1});

% RL = DeepQNetwork();
RL = DeepQNetwork(actionNum, featuresNum, 0.01, 0.9, 0.9, 100, 2000, 32);

total_steps = 0;

for i_episode = 1:100
    observation = double(env.reset());  % ndarray -> double array
    while true
        env.render();                   % 出现显示的窗口关不掉，运行：clear classes 或者 clear all
        
        action = int32(RL.chooseAction(observation)); 
        action = int32(action-1);      % python的下标是从0开始，动作1,2对应到python中是0,1
        if action < 0                  % 不知道为何会出现-1（即action=0情况）
            action = int32(0);
        end
        stepRet = cell(env.step(action));   % tuple(list) -> cell
        nextObservation = double(stepRet{1,1});
        x = nextObservation(1,1);
        xDot = nextObservation(1,2);
        theta = nextObservation(1,3);
        thetaDot = nextObservation(1,4);
        
        reward = int64(stepRet{1,2});   % 当前步获得的奖励
        done = int64(stepRet{1,3});     % 当前回合是否结束
        
        r1 = (env.x_threshold - abs(x)) / env.x_threshold - 0.8;
        r2 = (env.theta_threshold_radians - abs(theta)) / env.theta_threshold_radians - 0.5;
        reward = r1+r2;
        
        disp(i_episode);
        if done
            disp(i_episode);
            break;
        end
        
        observation = nextObservation;
        total_steps = total_steps + 1;
    end
end


