function [] = n_armed_testbed(nB,nA,nP,sigma)
%
% Generates the 10-armed bandit testbed.����10�۶Ĳ�������̨
%
% ���ӣ�n_armed_testbed(20, 10, 1000)
% 
% Inputs:
%   nB: the number of bandits �Ĳ�������Ŀ
%   nA: the number of arms �۵���Ŀ
%   nP: the number of plays (times we will pull a arm) ����һ���۵Ĵ���
%   sigma: the standard deviation of the return from each of the arms
%           ��ÿ���۷���ֵ�ı�׼��
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

if( nargin<1 ) % the number of bandits: Ĭ�϶Ĳ�������ĿΪ2000����������ݲ�����
    nB = 2000;
end
if( nargin<2 ) % the number of arms: ֻ���Ĳ�������Ŀ��������������Ĭ�ϵı���Ϊ10
    nA = 10;
end
if( nargin<3 ) % the number of plays (times we will pull a arm): ֻ���Ĳ����ͱ�����������ÿ���۵�����������Ĭ�ϵ���������Ϊ10000
    nP = 10000;
end
if( nargin<4 ) % the standard deviation of the return from each of the arms:  Ĭ�ϴ�ÿ���۷���ֵ�ñ�׼��Ϊ1.0
    sigma = 1.0;
end

% Ϊ�����ִ������ǿ���ϣ��������ͬ��α�����
% ���ѡ����ͬ��generator��������ͬ�ĳ�ʼֵsd����ô��Ϳ��Եõ�ͬ��α�����
rng(0);  % randn('seed',0);

% ����Q*����ʵ������generate the TRUE reward Q^{\star}:
qStarMeans = mvnrnd( zeros(nB,nA), eye(nA) );

% run an experiment for each epsilon:
% epsilon=0 => ��ȫ̰��   0 => fully greedy 
% epision=1 => ÿ�����鶼����̽��    1 => explore on each trial
epsArray = [ 0, 0.01, 0.1 ]; %, 1 ];

% assume we have at least ONE draw from each "arm" (initialize with use the qStarMeans matrix):
% �������ٶ�ÿ�����ۡ���һ�Σ�ʹ��qStarMeans������г�ʼ����
qT0 = mvnrnd( qStarMeans, eye(nA) );

avgReward    = zeros(length(epsArray),nP);
perOptAction = zeros(length(epsArray),nP);
cumReward    = zeros(length(epsArray),nP);
cumProb      = zeros(length(epsArray),nP);
for ei=1:length(epsArray),
    tEps = epsArray(ei);
    
    %qT = qT0;  % <- initialize to one draw per arm
    qT = zeros(size(qT0));  %����ÿ���Ĳ����ı�ʹ��0���г�ʼ����������֪ʶ������Ϊ0�� <- initialize to zero draws per arm (no knowledge)
    qN = ones( nB, nA ); % ��¼�۵����������� keep track of the number draws on this arm
    qS = qT;             % ��¼���������� keep track of the SUM of the rewards (qT = qS./qN)
    
    allRewards      = zeros(nB,nP);
    pickedMaxAction = zeros(nB,nP);
    for bi=1:nB, % pick a bandit
        for pi=1:nP, % make a play
            % ������ǰ������̽������̰�ģ����ã� determine if this move is exploritory or greedy:
            if( rand(1) <= tEps ) % ѡ������ۣ�̽���� pick a RANDOM arm:
                [dum,arm] = histc(rand(1),linspace(0,1+eps,nA+1)); clear dum;
            else                  % ѡ��̰���ۣ����ã� pick the GREEDY arm:
                [dum,arm] = max( qT(bi,:) ); clear dum;
            end
            % ������ѡ��ı��Ƿ������п��ܵ� determine if the arm selected is the best possible:
            [dum,bestArm] = max( qStarMeans(bi,:) );
            if( arm==bestArm ) pickedMaxAction(bi,pi) = 1; end
            % �������ı��л�ý��� get the reward from drawing on that arm:
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
    csAR            = cumsum(allRewards,2); % ����ÿ���Ĳ��������˵��ۻ����� do a cummulative sum across plays for each bandit
    csRew           = mean(csAR,1);
    cumReward(ei,:) = csRew(:).';
    csPA          = cumsum(pickedMaxAction,2)./cumsum(ones(size(pickedMaxAction)),2);
    csProb        = mean(csPA,1);
    cumProb(ei,:) = csProb(:).';
end

% produce the average rewards plot:
% ����ƽ������ͼ
figure; hold on; clrStr = 'brkc'; all_hnds = [];  % blue,red,black,cyan
for ei=1:length(epsArray)
    %all_hnds(ei) = plot( [ 0, avgReward(ei,:) ], [clrStr(ei)] );
    all_hnds(ei) = plot( 1:nP, avgReward(ei,:), [clrStr(ei),'-'] );
end
legend( all_hnds, { '0', '0.01', '0.1' }, 'Location', 'SouthEast' );
axis tight; grid on;
xlabel( 'plays' ); ylabel( 'Average Reward' );

% �����Ż���Ϊ�İٷֱ�ͼ produce the percent optimal action plot:
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
% �����ۻ�ƽ������ͼ
figure; hold on; clrStr = 'brkc'; all_hnds = [];
for ei=1:length(epsArray),
    all_hnds(ei) = plot( 1:nP, cumReward(ei,:), [clrStr(ei),'-'] );
end
legend( all_hnds, { '0', '0.01', '0.1' }, 'Location', 'SouthEast' );
axis tight; grid on;
xlabel( 'plays' ); ylabel( 'Cummulative Average Reward' );

% produce the cummulative percent optimal action plot:
% �����ۻ��ٷֱ��Ż���Ϊͼ
figure; hold on; clrStr = 'brkc'; all_hnds = [];
for ei=1:length(epsArray),
    all_hnds(ei) = plot( 1:nP, cumProb(ei,:), [clrStr(ei),'-'] );
end
legend( all_hnds, { '0', '0.01', '0.1' }, 'Location', 'SouthEast' );
axis( [ 0, nP, 0, 1 ] ); axis tight; grid on;
xlabel( 'plays' ); ylabel( 'Cummulative % Optimal Action' );
