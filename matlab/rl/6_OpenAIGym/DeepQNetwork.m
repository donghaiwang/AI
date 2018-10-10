%%
% �ο���https://morvanzhou.github.io/tutorials/machine-learning/reinforcement-learning/4-3-DQN3/
classdef DeepQNetwork
    properties
        actionNum = 2;
        featuresNum = 4;
        learningRate = 0.01;
        rewardDecay = 0.9;
        epsilonGreedy = 0.9;
        replaceTargetIter = 300;
        memorySize = 500;       % ����طŵ�Ԫ���洢��
        batchSize = 32;
        
        learnStepCounter = 0;   % ��¼ѧϰ���� (�����ж��Ƿ���� target_net ����)
        memoryCounter = 0;      % ����طŵ�Ԫ������
        memory = {};
        epsilon_increment;
        epsilon = 0;            % �Ƿ���̽��ģʽ, ���𲽼���̽������
        epsilonMax;             % epsilon���ܵ����ֵΪepsilonGreedy
        
        costHistogram = [];
    end
    
    methods
        function obj = DeepQNetwork(actionNum, featuresNum, learningRate, rewardDecay, epsilonGreedy, replaceTargetIter, memorySize, batchSize)
            obj.actionNum = actionNum;
            obj.featuresNum = featuresNum;
            obj.learningRate = learningRate;
            obj.rewardDecay = rewardDecay;
            obj.epsilonGreedy = epsilonGreedy;
            obj.replaceTargetIter = replaceTargetIter;
            obj.memorySize = memorySize;        %  ��������
            obj.batchSize = batchSize;          % ÿ�θ���ʱ�� memory ����ȡ���ټ������
            
            obj.epsilon = 0;
            obj.epsilonMax = epsilonGreedy;     % epsilon �����ֵΪepsilonGreedy
            
            epsilon_increment = 0;
            
            obj.memory = {};   % ��ʼ������طŵ�Ԫ��ȫΪ0��
            
            % ����Ŀ������(target_net)�͹�������(evaluate_net����)
            obj.buildNet();
            
            % �滻target net�Ĳ���
            % ��ȡ target_net �Ĳ���
            % ��ȡ  eval_net �Ĳ���
            % ���� target_net ����
            
            % �����־�ļ�
            
            obj.costHistogram = [];     % ��¼���� cost �仯, ������� plot �����ۿ�
        end
        
        % �ο�mxnetʵ�� https://www.cnblogs.com/YiXiaoZhou/p/8145499.html
        function buildNet(obj)
            % ������ֵ���磬����featuresNum��
            evalNet = [ ...
                fullyConnectedLayer(16)
                reluLayer
                fullyConnectedLayer(32)
                reluLayer
                fullyConnectedLayer(16)
                reluLayer
                fullyConnectedLayer(obj.actionNum)
                ];
            % ��ʧΪQ���ƺ�QĿ����ƽ����RMSProp�Ż�������С����ʧ
        end
        
        % ��������Ȩ�ؿ�������
        function copyParams(obj, src, dst)
        end
        
        % ����ǰ�۲���Ϣ�洢���طż��䵥Ԫ��
        function obj =  storeTransition(obj, status, action, reward, nextStatus)
            transition = {status, action, reward, nextStatus};
            obj.memoryCounter = obj.memoryCounter+1;    % ʹ0���ӵ�1����ΪMatlab�Ǵ�1��ʼ�ģ�
            % ���µĴ洢�滻�ɵĴ洢
            index = mod(obj.memoryCounter, obj.memorySize);
            obj.memory(index, :) = transition;
        end
        
        function action = chooseAction(obj, observation)
            if rand() < obj.epsilonGreedy   % ����observation�õ�ÿ��������Ӧ��Qֵ���������л�ã�
                actionValue = observation;
                nextAction = max(actionValue);  % �� eval_net �������������� action ��ֵ, ��ѡ��ֵ���� action
                action = ceil(rand()*2);
            else                % 1-epsilon �ĸ��ʽ������ѡ��
                action = ceil(rand() * obj.actionNum);
            end
        end
        
        % ����Qѧϰ
        function learn(obj)
            % ÿ��replaceTargetIter����ѧϰ�����õ�ǰֵ����Ĳ����滻Ŀ��ֵ����Ĳ���
            if mod(obj.learnStepCounter, obj.replaceTargetIter) == 0
                % ִ���õ�ǰֵ����Ĳ����滻Ŀ��ֵ����Ĳ���
                disp('Target parameraters replaced');
            end
            % �ӻطż��䵥Ԫ�в���batchSize����������ѧϰ��ģ�Ͳ����ĵ�����
            if obj.memoryCounter > obj.memorySize
                sampleIndex = randperm(obj.memorySize, obj.batchSize);      % ����طŵ�Ԫ���ˣ��ʹ���ѡbatchSize������
            else
                sampleIndex = randperm(obj.memoryCounter, obj.batchSize);   % ����طŵ�Ԫδ�����ʹ�ǰ��memoryCounter�������ѡbatchSize������
            end
            
            % ��ȡ q_next (target_net ������ q) �� q_eval(eval_net ������ q)
            % feed_dict�������Ǹ�ʹ��placeholder����������tensor��ֵ
            % ֻ��fetch��Ҫ��ֵ��q_next, q_eval
            
            % ѵ����������eval_net
            % ������ʧ��ԭ����QĿ��͵�ǰ��QĿ��Ĳ�ֵ������¼������������󻭳���ʧ�仯���ߣ�QĿ��Ϊһ��ʱ��֮ǰ�Ĳ���
            
            % ������ epsilon, ������Ϊ�������
            
            obj.learnStepCounter = obj.learnStepCounter + 1;
            
        end
        
    end
    
end