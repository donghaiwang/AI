%%
% 参考：https://morvanzhou.github.io/tutorials/machine-learning/reinforcement-learning/4-3-DQN3/
classdef DeepQNetwork
    properties
        actionNum = 2;
        featuresNum = 4;
        learningRate = 0.01;
        rewardDecay = 0.9;
        epsilonGreedy = 0.9;
        replaceTargetIter = 300;
        memorySize = 500;       % 记忆回放单元最多存储量
        batchSize = 32;
        
        learnStepCounter = 0;   % 记录学习次数 (用于判断是否更换 target_net 参数)
        memoryCounter = 0;      % 记忆回放单元计数器
        memory = {};
        epsilon_increment;
        epsilon = 0;            % 是否开启探索模式, 并逐步减少探索次数
        epsilonMax;             % epsilon可能的最大值为epsilonGreedy
        
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
            obj.memorySize = memorySize;        %  记忆上限
            obj.batchSize = batchSize;          % 每次更新时从 memory 里面取多少记忆出来
            
            obj.epsilon = 0;
            obj.epsilonMax = epsilonGreedy;     % epsilon 的最大值为epsilonGreedy
            
            epsilon_increment = 0;
            
            obj.memory = {};   % 初始化记忆回放单元（全为0）
            
            % 构建目标网络(target_net)和估计网络(evaluate_net估计)
            obj.buildNet();
            
            % 替换target net的参数
            % 提取 target_net 的参数
            % 提取  eval_net 的参数
            % 更新 target_net 参数
            
            % 输出日志文件
            
            obj.costHistogram = [];     % 记录所有 cost 变化, 用于最后 plot 出来观看
        end
        
        % 参考mxnet实现 https://www.cnblogs.com/YiXiaoZhou/p/8145499.html
        function buildNet(obj)
            % 建构估值网络，输入featuresNum个
            evalNet = [ ...
                fullyConnectedLayer(16)
                reluLayer
                fullyConnectedLayer(32)
                reluLayer
                fullyConnectedLayer(16)
                reluLayer
                fullyConnectedLayer(obj.actionNum)
                ];
            % 损失为Q估计和Q目标差的平方，RMSProp优化器，最小化损失
        end
        
        % 定义网络权重拷贝方法
        function copyParams(obj, src, dst)
        end
        
        % 将当前观测信息存储到回放记忆单元中
        function obj =  storeTransition(obj, status, action, reward, nextStatus)
            transition = {status, action, reward, nextStatus};
            obj.memoryCounter = obj.memoryCounter+1;    % 使0增加到1（因为Matlab是从1开始的）
            % 用新的存储替换旧的存储
            index = mod(obj.memoryCounter, obj.memorySize);
            obj.memory(index, :) = transition;
        end
        
        function action = chooseAction(obj, observation)
            if rand() < obj.epsilonGreedy   % 根据observation得到每个动作对应的Q值（从网络中获得）
                actionValue = observation;
                nextAction = max(actionValue);  % 让 eval_net 神经网络生成所有 action 的值, 并选择值最大的 action
                action = ceil(rand()*2);
            else                % 1-epsilon 的概率进行随机选择
                action = ceil(rand() * obj.actionNum);
            end
        end
        
        % 进行Q学习
        function learn(obj)
            % 每隔replaceTargetIter步（学习）就用当前值网络的参数替换目标值网络的参数
            if mod(obj.learnStepCounter, obj.replaceTargetIter) == 0
                % 执行用当前值网络的参数替换目标值网络的参数
                disp('Target parameraters replaced');
            end
            % 从回放记忆单元中采样batchSize个样本进行学习（模型参数的调整）
            if obj.memoryCounter > obj.memorySize
                sampleIndex = randperm(obj.memorySize, obj.batchSize);      % 记忆回放单元满了，就从中选batchSize个样本
            else
                sampleIndex = randperm(obj.memoryCounter, obj.batchSize);   % 记忆回放单元未满，就从前面memoryCounter个中随机选batchSize个样本
            end
            
            % 获取 q_next (target_net 产生了 q) 和 q_eval(eval_net 产生的 q)
            % feed_dict的作用是给使用placeholder创建出来的tensor赋值
            % 只是fetch想要的值：q_next, q_eval
            
            % 训练评价网络eval_net
            % 计算损失（原来的Q目标和当前的Q目标的差值）并记录下来，用于最后画出损失变化曲线；Q目标为一段时间之前的参数
            
            % 逐渐增加 epsilon, 降低行为的随机性
            
            obj.learnStepCounter = obj.learnStepCounter + 1;
            
        end
        
    end
    
end