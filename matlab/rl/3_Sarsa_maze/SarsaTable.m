%% Sarsaѧϰ�Ĵ��ԣ�������������ѡ��ѧϰ
% SarsaTable(1, 0.1, 0.01, 0.9);
classdef SarsaTable
    properties
        actions;        % ��ȡ���ж�
        learningRate;   % ѧϰ��
        gamma;          % ������˥������
        epsilon;        % 1-epsilon �ĸ��ʲ�ȡ�������
        QTable;         % Qֵ��
    end
    
    properties (Constant)
        height = 4;
        width = 4;
        actionsNum = 4;     % ��������Ŀ���¡��ҡ�����
    end
    
    methods 
        function obj = SarsaTable(actions, learningRate, rewardDecay, epsilonGreedy)
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
            obj.QTable{state, action} = obj.QTable{state, action} + obj.learningRate * (QTarget-QPredict);
        end
    end
end
