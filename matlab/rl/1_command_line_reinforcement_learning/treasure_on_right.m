%% 表查询Q学习方法
% 智能体“o”在一维世界的左边，宝藏在一维世界的最右边。运行这个程序查看智能体如何提高发现珍宝的策略。
rng(2);     % 设置随机种子（为了复现结果）

%% 常用常量设置
global N_STATES;   % 一维世界的长度 
N_STATES = 6;
LEFT_ACTION = zeros([N_STATES, 1]);     % 可以选择的动作（向左或者向右）
RIGHT_ACTION = zeros([N_STATES, 1]);
global EPSILON;
EPSILON = 0.9;      % 控制贪婪的程度：90%的时间是选择最优动作，10%的时间来探索
ALPHA = 0.1;        % 学习率
GAMMA = 0.9;        % 折扣因子
MAX_EPISODES = 13;  % 最大的情节数
global FRESH_TIME;   % 每次移动过后的更新时间
FRESH_TIME = 0.3;

% 构建并初始化Q表（刚开始全为0），Q表的行为探索者的位置（state），列为探索者的行为（action）。
Q_table = table(LEFT_ACTION, RIGHT_ACTION);

% 进行学习（迭代更新Q表）
for episode = 1:MAX_EPISODES
    stepCounter = 0;
    curState = 1;              % 当前回合初始位置（Matlab数组下标从1开始）
    isTerminated = false;      % 是否回合结束
    updateEnv(curState, episode, stepCounter);
    while ~isTerminated
        choosedAction = chooseAction(Q_table, curState);
        [nextState, reward] = getEnvFeedback(curState, choosedAction);
        QPredict = Q_table{curState, choosedAction};
        if nextState ~= N_STATES    % 下一个状态不是终止状态
            QTarget = reward + GAMMA * max(Q_table{nextState,:});
        else                        % 下一个状态是最右边的终止状态
            QTarget = reward;
            isTerminated = true;    % 结束当前回合
        end
        Q_table{curState, choosedAction} = Q_table{curState, choosedAction} + ALPHA * (QTarget - QPredict);  % 更新Q表（进行学习）
        curState = nextState;   % 把下一个状态变为下一步的当前状态
        
        updateEnv(curState, episode, stepCounter+1);
        stepCounter = stepCounter+1;
    end
end
disp(Q_table);


%% 
% 采取行动，并得到下一个状态和奖励
function [nextState, reward] =  getEnvFeedback(state, action)
    global N_STATES;
    if strcmp(action, 'RIGHT_ACTION') == 0  % 向右走
        if state == N_STATES - 1             % 当前位置是终点前的一个状态，并且是向右走
            nextState = N_STATES;
            reward = 1;
        else
            nextState = state + 1;
            reward = 0;
        end
    else    % 向左走
        reward = 0;
        if state == 1       % 状态为最左边，并且是向左走（达到墙壁，下一步为当前位置）
            nextState = state;
        else
            nextState = state - 1;
        end
    end
end

% 环境更新函数（显示环境是如何更新的）
function updateEnv(curState, episode, stepCounter) 
    global N_STATES;
    global FRESH_TIME;
    envList = [repmat('-', 1, N_STATES), 'T'];  % 环境为 '------T'
    if curState == N_STATES     % 当前位置为终点
        info = sprintf('Episode %d, total steps = %d', episode, stepCounter); 
        fprintf('%s\n', info);
        pause(2);
    else
        envList(curState) = 'o';
        disp(envList);
        pause(FRESH_TIME);
    end
end


% 进行动作的选择
function actionName = chooseAction(qTable, state)
    global EPSILON;
    stateActions = qTable(state, :);
    if rand() > EPSILON || (stateActions{1, 'LEFT_ACTION'}== 0 && stateActions{1, 'RIGHT_ACTION'} == 0) % 使用花括号得到table的元素（圆括号是得到一个元素的table）
        randAction = randperm(2);   % 随机选择向左或者向右
        if (randAction(1) == 1)
            actionName = 'LEFT_ACTION';
        else
            actionName = 'RIGHT_ACTION';
        end
    else    % 90%的可能采取贪婪策略
        if stateActions{1, 'LEFT_ACTION'} >= stateActions{1, 'RIGHT_ACTION'}
            actionName = 'LEFT_ACTION';
        else
            actionName = 'RIGHT_ACTION';
        end
    end
end