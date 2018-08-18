function Q = rps(N_EPISODES)
% RPS - Solve for the optimal rock/paper/scissors policy using Q-learning.
% 使用Q学习解决“剪刀-石头-布”最优化策略
% 
% We have one state with three possible actions (enoumerated above)
% 每个状态对应三个可能的行为（剪刀、石头、布）
% 
% The rewards are +1 if we win, 0 if we draw, and -1 if we loose.
% 如果获胜则奖励+1，平局则奖励为0，失败则奖励-1
% 
% The expected policy is [1,1,1]/3 or a random draw (from the possible choices) 
% during each play 
% 在每一轮游戏中，期望的策略是[1,1,1]/3，或者从可能的选择中随机选择
% 
% We assume that the opponent plays randomly
% 假设对手随机出手
%   
% Written by:
% -- 
% John L. Weatherwax                2008-02-19
% 
% email: wax@alum.mit.edu
% 
% Please send comments and especially bug reports to the
% above email address.
% 
%-----

% the probability we take an exploratory step: 
% 执行探索的可能性
epsilon = 0.1; 

% our learning rate: 学习率
alpha = 0.2; 

% the discount factor: 折扣因子
gamma = 1.0; 
%gamma = 0.9; 

% the number of actions: 
nActions = 3; 

% Our action-value function: 
Q = zeros(1,nActions); 

% play this many games: 
%N_EPISODES=1e5; 

for ei=1:N_EPISODES,
  % pick the max action to play；选择Q值最大的动作执行
  [dum,ai]=max(Q); 
  if( rand<epsilon )  % <0.1表示执行探索（随机选择三个动作的一个）
    tmp=randperm(nActions); ai=tmp(1);
  end  % 否则自己选择Q值最大的动作出手（选取使得动作值函数最大的动作）
  % if opponent plays randomly then the o(pponents) a(ction) is:
  tmp=randperm(nActions); oa=tmp(1);  % 对手随机选择三个动作中的一个
  % determine our reward (only one "if" statement will be executed):
                                       % ( OUR PLAY, THEIR PLAY )
  if( ai==1 && oa==1 ) rew =  0; end   % (   rock  ,    rock    )
  if( ai==1 && oa==2 ) rew = -1; end   % (   rock  ,    paper   )
  if( ai==1 && oa==3 ) rew = +1; end   % (   rock  ,   scissors )
  if( ai==2 && oa==1 ) rew = +1; end   % (   paper ,    rock    )
  if( ai==2 && oa==2 ) rew =  0; end   % (   paper ,    paper   )
  if( ai==2 && oa==3 ) rew = -1; end   % (   paper ,   scissors )
  if( ai==3 && oa==1 ) rew = -1; end   % (  scissors,    rock   )
  if( ai==3 && oa==2 ) rew = +1; end   % (  scissors,   paper   )
  if( ai==3 && oa==3 ) rew =  0; end   % (  scissors,  scissors )

  % implement Q-learning: （更新动作ai处的Q值）t
  Q(ai) = Q(ai) + alpha*( rew + gamma*max(Q) - Q(ai) ); 
  
end

%Q
%Q/sum(Q)


