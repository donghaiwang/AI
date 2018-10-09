%% Sarsa学习的大脑，包括：动作的选择、学习
% SarsaTable(1, 0.1, 0.01, 0.9);
classdef SarsaTable
    properties
        actions;        % 采取的行动
        learningRate;   % 学习率
        gamma;          % 奖励的衰减因子
        epsilon;        % 1-epsilon 的概率采取随机策略
        QTable;         % Q值表
    end
    
    properties (Constant)
        height = 4;
        width = 4;
        actionsNum = 4;     % 动作的数目：下、右、左、上
    end
    
    methods 
        function obj = SarsaTable(actions, learningRate, rewardDecay, epsilonGreedy)
            obj.actions = actions;
            obj.learningRate = learningRate;
            obj.gamma = rewardDecay;
            obj.epsilon = epsilonGreedy;
            gridNum = obj.height * obj.width;
            DOWN_ACTION = zeros([gridNum, 1]);     % 可以选择的动作（向左或者向右）
            RIGHT_ACTION = zeros([gridNum, 1]);
            LEFT_ACTION = zeros([gridNum, 1]);
            UP_ACTION = zeros([gridNum, 1]);
            obj.QTable = table(DOWN_ACTION, RIGHT_ACTION, LEFT_ACTION, UP_ACTION);
        end
        
        % 动作的选择
        function retAction = chooseAction(obj, observation)
            stateActions = obj.QTable{observation, :};
            if rand() > obj.epsilon || (stateActions(1, 1) == 0 && stateActions(1, 2) ==0 && stateActions(1, 3) == 0 && stateActions(1, 4) == 0)      % 随机选择
                retAction = ceil(rand()*4);   % 从四个中随机选择，
            else
                [maxQ, retAction] = max(stateActions);  % 返回当前行中Q值最大的下标
            end
        end
        
        function obj = learn(obj, state, action, reward, nextStatus, nextAction)
            QPredict = obj.QTable{state, action};
            if nextStatus ~= 13     % 下一个状态不是终点
                QTarget = reward + obj.gamma * obj.QTable{nextStatus, nextAction};  % 下一步选择的动作就是学习的动作
            else
                QTarget = reward;   % 下一个状态就是终点
            end
            obj.QTable{state, action} = obj.QTable{state, action} + obj.learningRate * (QTarget-QPredict);
        end
    end
end
