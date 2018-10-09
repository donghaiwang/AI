%%
classdef DeepQNetwork
    properties
        actionNum = 2;
        featuresNum = 4;
        learningRate = 0.01;
        rewardDecay = 0.9;
        epsilonGreedy = 0.9;
        replaceTargetIter = 300;
        memorySize = 500;
        batchSize = 32;
        
        learnStepCounter = 0;
    end
    
    methods
        function obj = DeepQNetwork(actionNum, featuresNum, learningRate, rewardDecay, epsilonGreedy, replaceTargetIter, memorySize, batchSize)
            obj.actionNum = actionNum;
            obj.featuresNum = featuresNum;
            obj.learningRate = learningRate;
            obj.rewardDecay = rewardDecay;
            obj.epsilonGreedy = epsilonGreedy;
            obj.replaceTargetIter = replaceTargetIter;
            obj.memorySize = memorySize;
            obj.batchSize = batchSize;
        end
        
        function action = chooseAction(obj, observation)
            action = ceil(rand()*2);
            if rand() < obj.epsilonGreedy   % ����observation�õ�ÿ��������Ӧ��Qֵ���������л�ã�
                actionValue = observation;
                nextAction = max(actionValue);
            else                % 1-epsilon �ĸ��ʽ������ѡ��
                action = ceil(rand() * obj.actionNum);
            end
        end
    end
    
end