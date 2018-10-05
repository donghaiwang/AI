%% ���ѯQѧϰ����
% �����塰o����һά�������ߣ�������һά��������ұߡ������������鿴�����������߷����䱦�Ĳ��ԡ�
rng(2);     % ����������ӣ�Ϊ�˸��ֽ����

%% ���ó�������
global N_STATES;   % һά����ĳ��� 
N_STATES = 6;
LEFT_ACTION = zeros([N_STATES, 1]);     % ����ѡ��Ķ���������������ң�
RIGHT_ACTION = zeros([N_STATES, 1]);
global EPSILON;
EPSILON = 0.9;      % ����̰���ĳ̶ȣ�90%��ʱ����ѡ�����Ŷ�����10%��ʱ����̽��
ALPHA = 0.1;        % ѧϰ��
GAMMA = 0.9;        % �ۿ�����
MAX_EPISODES = 13;  % ���������
global FRESH_TIME;   % ÿ���ƶ�����ĸ���ʱ��
FRESH_TIME = 0.3;

% ��������ʼ��Q���տ�ʼȫΪ0����Q�����Ϊ̽���ߵ�λ�ã�state������Ϊ̽���ߵ���Ϊ��action����
Q_table = table(LEFT_ACTION, RIGHT_ACTION);

% ����ѧϰ����������Q��
for episode = 1:MAX_EPISODES
    stepCounter = 0;
    curState = 1;              % ��ǰ�غϳ�ʼλ�ã�Matlab�����±��1��ʼ��
    isTerminated = false;      % �Ƿ�غϽ���
    updateEnv(curState, episode, stepCounter);
    while ~isTerminated
        choosedAction = chooseAction(Q_table, curState);
        [nextState, reward] = getEnvFeedback(curState, choosedAction);
        QPredict = Q_table{curState, choosedAction};
        if nextState ~= N_STATES    % ��һ��״̬������ֹ״̬
            QTarget = reward + GAMMA * max(Q_table{nextState,:});
        else                        % ��һ��״̬�����ұߵ���ֹ״̬
            QTarget = reward;
            isTerminated = true;    % ������ǰ�غ�
        end
        Q_table{curState, choosedAction} = Q_table{curState, choosedAction} + ALPHA * (QTarget - QPredict);  % ����Q������ѧϰ��
        curState = nextState;   % ����һ��״̬��Ϊ��һ���ĵ�ǰ״̬
        
        updateEnv(curState, episode, stepCounter+1);
        stepCounter = stepCounter+1;
    end
end
disp(Q_table);


%% 
% ��ȡ�ж������õ���һ��״̬�ͽ���
function [nextState, reward] =  getEnvFeedback(state, action)
    global N_STATES;
    if strcmp(action, 'RIGHT_ACTION') == 0  % ������
        if state == N_STATES - 1             % ��ǰλ�����յ�ǰ��һ��״̬��������������
            nextState = N_STATES;
            reward = 1;
        else
            nextState = state + 1;
            reward = 0;
        end
    else    % ������
        reward = 0;
        if state == 1       % ״̬Ϊ����ߣ������������ߣ��ﵽǽ�ڣ���һ��Ϊ��ǰλ�ã�
            nextState = state;
        else
            nextState = state - 1;
        end
    end
end

% �������º�������ʾ��������θ��µģ�
function updateEnv(curState, episode, stepCounter) 
    global N_STATES;
    global FRESH_TIME;
    envList = [repmat('-', 1, N_STATES), 'T'];  % ����Ϊ '------T'
    if curState == N_STATES     % ��ǰλ��Ϊ�յ�
        info = sprintf('Episode %d, total steps = %d', episode, stepCounter); 
        fprintf('%s\n', info);
        pause(2);
    else
        envList(curState) = 'o';
        disp(envList);
        pause(FRESH_TIME);
    end
end


% ���ж�����ѡ��
function actionName = chooseAction(qTable, state)
    global EPSILON;
    stateActions = qTable(state, :);
    if rand() > EPSILON || (stateActions{1, 'LEFT_ACTION'}== 0 && stateActions{1, 'RIGHT_ACTION'} == 0) % ʹ�û����ŵõ�table��Ԫ�أ�Բ�����ǵõ�һ��Ԫ�ص�table��
        randAction = randperm(2);   % ���ѡ�������������
        if (randAction(1) == 1)
            actionName = 'LEFT_ACTION';
        else
            actionName = 'RIGHT_ACTION';
        end
    else    % 90%�Ŀ��ܲ�ȡ̰������
        if stateActions{1, 'LEFT_ACTION'} >= stateActions{1, 'RIGHT_ACTION'}
            actionName = 'LEFT_ACTION';
        else
            actionName = 'RIGHT_ACTION';
        end
    end
end