%% Sarsa学习的大脑，包括：动作的选择、学习
% SarsaLambdaTable(1, 0.1, 0.01, 0.9);
classdef SarsaLambdaTable
    properties
        actions;        % 采取的行动
        learningRate;   % 学习率
        gamma;          % 奖励的衰减因子
        epsilon;        % 1-epsilon 的概率采取随机策略
        QTable;         % Q值表
        lambda;         % Sarsa lambda（适合度轨迹的衰变值）
        eligibilityTrace;   % 适合度轨迹
    end
    
    properties (Constant)
        height = 4;
        width = 4;
        actionsNum = 4;     % 动作的数目：下、右、左、上
    end
    
    methods 
        function obj = SarsaLambdaTable(actions, learningRate, rewardDecay, epsilonGreedy, traceDecay)
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
            obj.lambda = traceDecay;        % 衰减
            obj.eligibilityTrace = table(DOWN_ACTION, RIGHT_ACTION, LEFT_ACTION, UP_ACTION);    % 每次在这个状态status采取某个动作action都使eligibilityTrance表中对应值加1
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
            error = (QTarget-QPredict);
            
            obj.eligibilityTrace{state, :} = obj.eligibilityTrace{state, :} * 0;    % 当前状态所有的action置为0，只有采取的action才为1
            obj.eligibilityTrace{state, action} = 1;                                % 不可或缺性（相比累积+1会更好）
            
            % 获得奖励时需要更新路径上的所有
            for i = 1 : obj.height * obj.width
                for j = 1 : obj.actionsNum
                    obj.QTable{i, j} = obj.QTable{i, j} + obj.learningRate * error * obj.eligibilityTrace{i, j};
                    obj.eligibilityTrace{i, j} = obj.eligibilityTrace{i, j} * obj.gamma * obj.lambda;
                end
            end
%             obj.QTable = obj.QTable + obj.learningRate * error * obj.eligibilityTrace;
%             obj.eligibilityTrace{state, action} = obj.eligibilityTrace{state, action} * obj.gamma * obj.lambda;
%             obj.QTable{state, action} = obj.QTable{state, action} + obj.learningRate * error * obj.eligibilityTrace{state, action};
%             obj.eligibilityTrace{state, action} = obj.eligibilityTrace{state, action} * obj.gamma * obj.lambda;
        end
    end
end
