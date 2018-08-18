function [] = n_armed_testbed(nB,nA,nP,sigma)
%
% Generates the 10-armed bandit testbed.生成10臂赌博机测试台
%
% 例子：n_armed_testbed(20, 10, 1000)
% 
% Inputs:
%   nB: the number of bandits 赌博机的数目
%   nA: the number of arms 臂的数目
%   nP: the number of plays (times we will pull a arm) 拉动一个臂的次数
%   sigma: the standard deviation of the return from each of the arms
%           从每个臂返回值的标准差
%
% Written by:
% --
% John L. Weatherwax                2007-11-13
%
% email: wax@alum.mit.edu
% s
% Please send comments and especially bug reports to the
% above email address.
%
%-----

%close all;
%clc;
%clear;

if( nargin<1 ) % the number of bandits: 默认赌博机的数目为2000（如果不传递参数）
    nB = 2000;
end
if( nargin<2 ) % the number of arms: 只给赌博机的数目，而不给臂数，默认的臂数为10
    nA = 10;
end
if( nargin<3 ) % the number of plays (times we will pull a arm): 只给赌博机和臂数，而不给每个臂的拉动次数，默认的拉动次数为10000
    nP = 10000;
end
if( nargin<4 ) % the standard deviation of the return from each of the arms:  默认从每个臂返回值得标准差为1.0
    sigma = 1.0;
end

% 为了重现错误，我们可能希望产生相同的伪随机数
% 如果选用相同的generator并设置相同的初始值sd，那么你就可以得到同样伪随机数
rng(0);  % randn('seed',0);

% 产生Q*的真实奖励：generate the TRUE reward Q^{\star}:
qStarMeans = mvnrnd( zeros(nB,nA), eye(nA) );

% run an experiment for each epsilon:
% epsilon=0 => 完全贪婪   0 => fully greedy 
% epision=1 => 每次试验都进行探索    1 => explore on each trial
epsArray = [ 0, 0.01, 0.1 ]; %, 1 ];

% assume we have at least ONE draw from each "arm" (initialize with use the qStarMeans matrix):
% 假设至少对每个“臂”拉一次（使用qStarMeans矩阵进行初始化）
qT0 = mvnrnd( qStarMeans, eye(nA) );

avgReward    = zeros(length(epsArray),nP);
perOptAction = zeros(length(epsArray),nP);
cumReward    = zeros(length(epsArray),nP);
cumProb      = zeros(length(epsArray),nP);
for ei=1:length(epsArray),
    tEps = epsArray(ei);
    
    %qT = qT0;  % <- initialize to one draw per arm
    qT = zeros(size(qT0));  %对于每个赌博机的臂使用0进行初始化（无先验知识，奖励为0） <- initialize to zero draws per arm (no knowledge)
    qN = ones( nB, nA ); % 记录臂的拉动过次数 keep track of the number draws on this arm
    qS = qT;             % 记录奖励的总数 keep track of the SUM of the rewards (qT = qS./qN)
    
    allRewards      = zeros(nB,nP);
    pickedMaxAction = zeros(nB,nP);
    for bi=1:nB, % pick a bandit
        for pi=1:nP, % make a play
            % 决定当前步骤是探索还是贪心（利用） determine if this move is exploritory or greedy:
            if( rand(1) <= tEps ) % 选择随机臂（探索） pick a RANDOM arm:
                [dum,arm] = histc(rand(1),linspace(0,1+eps,nA+1)); clear dum;
            else                  % 选择贪婪臂（利用） pick the GREEDY arm:
                [dum,arm] = max( qT(bi,:) ); clear dum;
            end
            % 决定所选择的臂是否是最有可能的 determine if the arm selected is the best possible:
            [dum,bestArm] = max( qStarMeans(bi,:) );
            if( arm==bestArm ) pickedMaxAction(bi,pi) = 1; end
            % 从拉动的臂中获得奖励 get the reward from drawing on that arm:
            reward = qStarMeans(bi,arm) + sigma*randn(1);
            allRewards(bi,pi) = reward;
            % update qN,qS,qT:
            qN(bi,arm) = qN(bi,arm)+1;
            qS(bi,arm) = qS(bi,arm)+reward;
            qT(bi,arm) = qS(bi,arm)/qN(bi,arm);
        end
    end
    
    avgRew          = mean(allRewards,1);
    avgReward(ei,:) = avgRew(:).';
    percentOptAction   = mean(pickedMaxAction,1);
    perOptAction(ei,:) = percentOptAction(:).';
    csAR            = cumsum(allRewards,2); % 计算每个赌博机拉动杆的累积奖励 do a cummulative sum across plays for each bandit
    csRew           = mean(csAR,1);
    cumReward(ei,:) = csRew(:).';
    csPA          = cumsum(pickedMaxAction,2)./cumsum(ones(size(pickedMaxAction)),2);
    csProb        = mean(csPA,1);
    cumProb(ei,:) = csProb(:).';
end

% produce the average rewards plot:
% 产生平均奖励图
figure; hold on; clrStr = 'brkc'; all_hnds = [];  % blue,red,black,cyan
for ei=1:length(epsArray)
    %all_hnds(ei) = plot( [ 0, avgReward(ei,:) ], [clrStr(ei)] );
    all_hnds(ei) = plot( 1:nP, avgReward(ei,:), [clrStr(ei),'-'] );
end
legend( all_hnds, { '0', '0.01', '0.1' }, 'Location', 'SouthEast' );
axis tight; grid on;
xlabel( 'plays' ); ylabel( 'Average Reward' );

% 生成优化行为的百分比图 produce the percent optimal action plot:
%
figure; hold on; clrStr = 'brkc'; all_hnds = [];
for ei=1:length(epsArray),
    %all_hnds(ei) = plot( [ 0, avgReward(ei,:) ], [clrStr(ei)] );
    all_hnds(ei) = plot( 1:nP, perOptAction(ei,:), [clrStr(ei),'-'] );
end
legend( all_hnds, { '0', '0.01', '0.1' }, 'Location', 'SouthEast' );
axis( [ 0, nP, 0, 1 ] ); axis tight; grid on;
xlabel( 'plays' ); ylabel( '% Optimal Action' );

% produce the cummulative average rewards plot:
% 生成累积平均奖励图
figure; hold on; clrStr = 'brkc'; all_hnds = [];
for ei=1:length(epsArray),
    all_hnds(ei) = plot( 1:nP, cumReward(ei,:), [clrStr(ei),'-'] );
end
legend( all_hnds, { '0', '0.01', '0.1' }, 'Location', 'SouthEast' );
axis tight; grid on;
xlabel( 'plays' ); ylabel( 'Cummulative Average Reward' );

% produce the cummulative percent optimal action plot:
% 生成累积百分比优化行为图
figure; hold on; clrStr = 'brkc'; all_hnds = [];
for ei=1:length(epsArray),
    all_hnds(ei) = plot( 1:nP, cumProb(ei,:), [clrStr(ei),'-'] );
end
legend( all_hnds, { '0', '0.01', '0.1' }, 'Location', 'SouthEast' );
axis( [ 0, nP, 0, 1 ] ); axis tight; grid on;
xlabel( 'plays' ); ylabel( 'Cummulative % Optimal Action' );
