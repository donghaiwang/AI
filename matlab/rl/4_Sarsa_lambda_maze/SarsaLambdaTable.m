%% Sarsaѧϰ�Ĵ��ԣ�������������ѡ��ѧϰ
% SarsaLambdaTable(1, 0.1, 0.01, 0.9);
classdef SarsaLambdaTable
    properties
        actions;        % ��ȡ���ж�
        learningRate;   % ѧϰ��
        gamma;          % ������˥������
        epsilon;        % 1-epsilon �ĸ��ʲ�ȡ�������
        QTable;         % Qֵ��
        lambda;         % Sarsa lambda���ʺ϶ȹ켣��˥��ֵ��
        eligibilityTrace;   % �ʺ϶ȹ켣
    end
    
    properties (Constant)
        height = 4;
        width = 4;
        actionsNum = 4;     % ��������Ŀ���¡��ҡ�����
    end
    
    methods 
        function obj = SarsaLambdaTable(actions, learningRate, rewardDecay, epsilonGreedy, traceDecay)
            obj.actions = actions;
            obj.learningRate = learningRate;
            obj.gamma = rewardDecay;
            obj.epsilon = epsilonGreedy;
            gridNum = obj.height * obj.width;
            DOWN_ACTION = zeros([gridNum, 1]);     % ����ѡ��Ķ���������������ң�
            RIGHT_ACTION = zeros([gridNum, 1]);
            LEFT_ACTION = zeros([gridNum, 1]);
            UP_ACTION = zeros([gridNum, 1]);
            obj.QTable = table(DOWN_ACTION, RIGHT_ACTION, LEFT_ACTION, UP_ACTION);
            obj.lambda = traceDecay;        % ˥��
            obj.eligibilityTrace = table(DOWN_ACTION, RIGHT_ACTION, LEFT_ACTION, UP_ACTION);    % ÿ�������״̬status��ȡĳ������action��ʹeligibilityTrance���ж�Ӧֵ��1
        end
        
        % ������ѡ��
        function retAction = chooseAction(obj, observation)
            stateActions = obj.QTable{observation, :};
            if rand() > obj.epsilon || (stateActions(1, 1) == 0 && stateActions(1, 2) ==0 && stateActions(1, 3) == 0 && stateActions(1, 4) == 0)      % ���ѡ��
                retAction = ceil(rand()*4);   % ���ĸ������ѡ��
            else
                [maxQ, retAction] = max(stateActions);  % ���ص�ǰ����Qֵ�����±�
            end
        end
        
        function obj = learn(obj, state, action, reward, nextStatus, nextAction)
            QPredict = obj.QTable{state, action};
            if nextStatus ~= 13     % ��һ��״̬�����յ�
                QTarget = reward + obj.gamma * obj.QTable{nextStatus, nextAction};  % ��һ��ѡ��Ķ�������ѧϰ�Ķ���
            else
                QTarget = reward;   % ��һ��״̬�����յ�
            end
            error = (QTarget-QPredict);
            
            obj.eligibilityTrace{state, :} = obj.eligibilityTrace{state, :} * 0;    % ��ǰ״̬���е�action��Ϊ0��ֻ�в�ȡ��action��Ϊ1
            obj.eligibilityTrace{state, action} = 1;                                % ���ɻ�ȱ�ԣ�����ۻ�+1����ã�
            
            % ��ý���ʱ��Ҫ����·���ϵ�����
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
