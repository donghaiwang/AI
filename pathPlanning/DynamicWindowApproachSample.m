% -------------------------------------------------------------------------
% File : DynamicWindowApproachSample.m
%
% Discription : Mobile Robot Motion Planning with Dynamic Window Approach
%
% Environment : Matlab
%
% Author : Atsushi Sakai
%
% Copyright (c): 2014 Atsushi Sakai
%
% License : Modified BSD Software License Agreement
% log: 20181031 ������ϸ��ע����Ϣ �±�Ķ���
% 20181101 �����ӻ����ϰ���Ĵ�С����ֱ�۵Ŀ����ϰ���ͻ�����֮���λ�ù�ϵ
% �ο��� https://blog.csdn.net/heyijia0327/article/details/44983551
% -------------------------------------------------------------------------

function [] = DynamicWindowApproachSample()

close all;
clear all;

disp('Dynamic Window Approach sample program start!!')

%% �����˵ĳ���״̬[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]
% x=[0 0 pi/2 0 0]'; % 5x1���� �о���  λ�� 0��0 ���� pi/2 ,�ٶȡ����ٶȾ�Ϊ0
x = [0 0 pi/10 0 0]'; 

% �±�궨�� ״̬[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]
POSE_X      = 1;  %���� X
POSE_Y      = 2;  %���� Y
YAW_ANGLE   = 3;  %�����˺����
V_SPD       = 4;  %�������ٶ�
W_ANGLE_SPD = 5;  %�����˽��ٶ� 

saveVideo = true;  % save video into current directory
if saveVideo
    v = VideoWriter('pathPlanningAnimation.avi');
    open(v);
end

goal = [10,10];   % Ŀ���λ�� [x(m),y(m)]

% �ϰ���λ���б� [x(m) y(m)]
obstacle=[0 2;
          2 4;
          2 5;      
          4 2;
%           4 4;
          5 4;
%           5 5;
          5 6;
          5 9
          8 8
          8 9
          7 9];
% obstacle=[0 2;
%           4 2;
%           4 4;
%           5 4;
%           5 5;
%           5 6;
%           5 9
%           8 8
%           8 9
%           7 9
%           6 5
%           6 3
%           6 8
%           6 7
%           7 4
%           9 8
%           9 11
%           9 6];
      
obstacleR = 0.5;% ��ͻ�ж��õ��ϰ���뾶
global dt; 
dt = 0.1;% ʱ��[s]

% �������˶�ѧģ�Ͳ���
% ����ٶ�m/s],�����ת�ٶ�[rad/s],���ٶ�[m/ss],��ת���ٶ�[rad/ss],
% �ٶȷֱ���[m/s],ת�ٷֱ���[rad/s]]
Kinematic = [1.0,toRadian(20.0),0.2,toRadian(50.0),0.01,toRadian(1)];
%����Kinematic���±꺬��
MD_MAX_V    = 1;%   ����ٶ�m/s]
MD_MAX_W    = 2;%   �����ת�ٶ�[rad/s]
MD_ACC      = 3;%   ���ٶ�[m/ss]
MD_VW       = 4;%   ��ת���ٶ�[rad/ss]
MD_V_RESOLUTION  = 5;%  �ٶȷֱ���[m/s]
MD_W_RESOLUTION  = 6;%  ת�ٷֱ���[rad/s]]


% ���ۺ������� [heading,dist,velocity,predictDT]
% ����÷ֵı��ء�����÷ֵı��ء��ٶȵ÷ֵı��ء���ǰģ��켣��ʱ��
evalParam = [0.05, 0.2 ,0.1, 3.0];

area      = [-1 11 -1 11];% ģ������Χ [xmin xmax ymin ymax]

% ģ��ʵ��Ľ��
result.x=[];   %�ۻ��洢�߹��Ĺ켣���״ֵ̬ 
tic; % �����������ʱ�俪ʼ

% movcount=0;
%% Main loop   ѭ������ 5000�� ָ���ﵽĿ�ĵ� ���� 5000�����н���
for i = 1:5000  
    % DWA�������� ���ؿ����� u = [v(m/s),w(rad/s)] �� �켣
    [u,traj] = DynamicWindowApproach(x,Kinematic,goal,evalParam,obstacle,obstacleR);
    x = f(x,u);% �������ƶ�����һ��ʱ�̵�״̬�� ���ݵ�ǰ�ٶȺͽ��ٶ��Ƶ� ��һ�̵�λ�úͽǶ�
    
    % ��ʷ�켣�ı���
    result.x = [result.x; x'];  %���½�� ���е���ʽ ��ӵ�result.x
    
    % �Ƿ񵽴�Ŀ�ĵ�
    if norm(x(POSE_X:POSE_Y)-goal')<0.5   % norm��������������ϵ�������֮��ľ���
        disp('Arrive Goal!!');break;
    end
    
    %====Animation====
    hold off;               % �ر�ͼ�α��ֹ��ܡ� ��ͼ����ʱ��ȡ��ԭͼ����ʾ��
    ArrowLength = 0.5;      % ��ͷ����
    
    % ������
    % quiver(x,y,u,v) �� x �� y ��ÿ����ӦԪ�ض�����ָ�������괦����������Ϊ��ͷ
    quiver(x(POSE_X), x(POSE_Y), ArrowLength*cos(x(YAW_ANGLE)), ArrowLength*sin(x(YAW_ANGLE)), 'ok'); % ���ƻ����˵�ǰλ�õĺ����ͷ
    hold on;                                                     %����ͼ�α��ֹ��ܣ���ǰ�������ͼ�ζ������֣��Ӵ˻��Ƶ�ͼ�ζ�����������ͼ�εĻ����ϣ����Զ�����������ķ�Χ
    
    plot(result.x(:,POSE_X),result.x(:,POSE_Y),'-b');hold on;    % �����߹�������λ�� ������ʷ���ݵ� X��Y����
    plot(goal(1),goal(2),'*r');hold on;                          % ����Ŀ��λ��
    
    %plot(obstacle(:,1),obstacle(:,2),'*k');hold on;              % ���������ϰ���λ��
    DrawObstacle_plot(obstacle,obstacleR);
    
    % ̽���켣 ���������۵Ĺ켣
    if ~isempty(traj) %�켣�ǿ�
        for it=1:length(traj(:,1))/5    %�������й켣��  traj ÿ5������ ��ʾһ���켣��
            ind = 1+(it-1)*5; %�� it ���켣��Ӧ��traj�е��±� 
            plot(traj(ind,:),traj(ind+1,:),'-g');hold on;  %����һ���켣�ĵ㴮�����켣   traj(ind,:) ��ʾ��ind���켣������x����ֵ  traj(ind+1,:)��ʾ��ind���켣������y����ֵ
        end
    end
    
    axis(area); %����area���õ�ǰͼ�ε����귶Χ���ֱ�Ϊx�����С�����ֵ��y�����С���ֵ
    grid on;
    
    currentFrame = getframe(gcf);
    [currentFrameImg] = frame2im(currentFrame);
    if saveVideo
        writeVideo(v, currentFrameImg);
    end
    
    drawnow;  %ˢ����Ļ. ������ִ��ʱ�䳤����Ҫ����ִ��plotʱ��Matlab���򲻻����ϰ�ͼ�񻭵�figure�ϣ���ʱ��Ҫ��ʵʱ����ͼ���ÿһ���仯�������Ҫʹ�������䡣
    %movcount = movcount+1;
    %mov(movcount) = getframe(gcf);%  ��¼����֡

end
if saveVideo
    close(v);
end
toc  %�����������ʱ��  ��ʽ��ʱ���ѹ� ** �롣
%movie2avi(mov,'movie.avi');  %¼�ƹ��̶��� ����Ϊ movie.avi �ļ�

%% ���������ϰ���λ��
% ���������obstacle �����ϰ��������   obstacleR �ϰ���İ뾶
function [] = DrawObstacle_plot(obstacle,obstacleR)
r = obstacleR; 
theta = 0:pi/20:2*pi;
for id=1:length(obstacle(:,1))
 x = r * cos(theta) + obstacle(id,1); 
 y = r  *sin(theta) + obstacle(id,2);
 plot(x,y,'-m');hold on; 
end
% plot(obstacle(:,1),obstacle(:,2),'*m');hold on;              % ���������ϰ���λ��
    


%% DWA�㷨ʵ�� 
% model  �������˶�ѧģ��  ����ٶ�m/s],�����ת�ٶ�[rad/s],���ٶ�[m/ss],��ת���ٶ�[rad/ss], �ٶȷֱ���[m/s],ת�ٷֱ���[rad/s]]
% �����������ǰ״̬��ģ�Ͳ�����Ŀ��㡢���ۺ����Ĳ������ϰ���λ�á��ϰ���뾶
% ���ز����������� u = [v(m/s),w(rad/s)] �� �켣���� N * 31  ��N�����õĹ켣����
% ѡȡ���Ų������������壺�ھֲ����������У�ʹ�û����˱ܿ��ϰ������Ŀ���ԽϿ���ٶ���ʻ��
function [u,trajDB] = DynamicWindowApproach(x,model,goal,evalParam,ob,R)
% Dynamic Window [vmin,vmax,wmin,wmax] ��С�ٶ� ����ٶ� ��С���ٶ� �����ٶ��ٶ�
Vr = CalcDynamicWindow(x,model);  % ���ݵ�ǰ״̬ �� �˶�ģ�� ���㵱ǰ�Ĳ�������Χ

% ���ۺ����ļ��� evalDB N*5  ÿ��һ����ò��� �ֱ�Ϊ �ٶȡ����ٶȡ�����÷֡�����÷֡��ٶȵ÷�
%               trajDB      ÿ5��һ���켣 ÿ���켣����״̬x�㴮���
[evalDB,trajDB]= Evaluation(x,Vr,goal,ob,R,model,evalParam);  %evalParam ���ۺ������� [heading,dist,velocity,predictDT]

if isempty(evalDB)
    disp('no path to goal!!');
    u=[0;0];return;
end

% �����ۺ�������
evalDB = NormalizeEval(evalDB);

% �������ۺ����ļ���
feval=[];
for id=1:length(evalDB(:,1))
    feval = [feval;evalParam(1:3)*evalDB(id,3:5)']; %�������ۺ������� ǰ�������������Ȩ�� ����ÿһ����õ�·��������Ϣ�ĵ÷�
end
evalDB = [evalDB feval]; % ���һ��
 
[maxv,ind] = max(feval);% ѡȡ������ߵĲ��� ��Ӧ�������ظ� maxv  ��Ӧ�±귵�ظ� ind
u = evalDB(ind,1:2)';% �������Ų������ٶȡ����ٶ�  

%% ���ۺ��� �ڲ�����������ù켣
% ������� ����ǰ״̬����������Χ�����ڣ���Ŀ��㡢�ϰ���λ�á��ϰ���뾶�����ۺ����Ĳ���
% ���ز�����
%           evalDB N*5  ÿ��һ����ò��� �ֱ�Ϊ �ٶȡ����ٶȡ�����÷֡�����÷֡��ٶȵ÷�
%           trajDB      ÿ5��һ���켣 ÿ���켣���� ǰ��Ԥ��ʱ��/dt + 1 = 31 ���켣�㣨�����ɹ켣������
function [evalDB,trajDB] = Evaluation(x,Vr,goal,ob,R,model,evalParam)
evalDB = [];
trajDB = [];
for vt = Vr(1):model(5):Vr(2)       %�����ٶȷֱ��ʱ������п����ٶȣ� ��С�ٶȺ�����ٶ� ֮�� �ٶȷֱ��� ���� 
    for ot=Vr(3):model(6):Vr(4)     %���ݽǶȷֱ��ʱ������п��ý��ٶȣ� ��С���ٶȺ������ٶ� ֮�� �Ƕȷֱ��� ����  
        % �켣�Ʋ�; �õ� xt: ��������ǰ�˶����Ԥ��λ��; traj: ��ǰʱ�� �� Ԥ��ʱ��֮��Ĺ켣���ɹ켣����ɣ�
        [xt,traj] = GenerateTrajectory(x,vt,ot,evalParam(4),model);  %evalParam(4),ǰ��ģ��ʱ��;
        % �����ۺ����ļ���
        heading = CalcHeadingEval(xt,goal); % ǰ��Ԥ���յ�ĺ���÷�  ƫ��ԽС����Խ��
        dist    = CalcDistEval(xt,ob,R);    % ǰ��Ԥ���յ� ��������ϰ���ļ�϶�÷� ����ԽԶ����Խ��
        vel     = abs(vt);                  % �ٶȵ÷� �ٶ�Խ���Խ��
        stopDist = CalcBreakingDist(vel,model); % �ƶ�����ļ���
        if dist > stopDist % �������ײ��������ϰ��� ��������·�� ��������ϰ���ľ��� ���� ɲ������ ��ȡ�ã�
            evalDB = [evalDB;[vt ot heading dist vel]];
            trajDB = [trajDB;traj];   % ÿ5�� һ���켣  
        end
    end
end

%% ��һ������ 
% ÿһ���켣�ĵ���÷ֳ��Ա������з�����
function EvalDB=NormalizeEval(EvalDB)
% ���ۺ�������
if sum(EvalDB(:,3))~= 0
    EvalDB(:,3) = EvalDB(:,3)/sum(EvalDB(:,3));  %���������  ���о����ÿԪ�طֱ���Ա����������ݵĺ�
end
if sum(EvalDB(:,4))~= 0
    EvalDB(:,4) = EvalDB(:,4)/sum(EvalDB(:,4));
end
if sum(EvalDB(:,5))~= 0
    EvalDB(:,5) = EvalDB(:,5)/sum(EvalDB(:,5));
end

%% �����켣���ɡ��켣���ݺ���
% ��������� ��ǰ״̬��vt��ǰ�ٶȡ�ot���ٶȡ�evaldt ǰ��ģ��ʱ�䡢������ģ�Ͳ�����û�õ���
% ���ز���; 
%           x   : ������ģ��ʱ������ǰ�˶� Ԥ����յ�λ��(״̬); 
%           traj: ��ǰʱ�� �� Ԥ��ʱ��֮�� �����е�λ�˼�¼��״̬��¼�� ��ǰģ��Ĺ켣  
%                  �켣��ĸ���Ϊ evaldt / dt + 1 = 3.0 / 0.1 + 1 = 31
%           
function [x,traj] = GenerateTrajectory(x,vt,ot,evaldt,model)
global dt;
time = 0;
u = [vt;ot];% ����ֵ
traj = x;   % �����˹켣
while time <= evaldt   
    time = time+dt; % ʱ�����
    x = f(x,u);     % �˶����� ǰ��ģ��ʱ���� �ٶȡ����ٶȺ㶨
    traj = [traj x]; % ÿһ�д���һ���켣�� һ��һ�е����
end

%% �����ƶ����� 
%�����˶�ѧģ�ͼ����ƶ�����, Ҳ���Կ��ǳ���һ�ζ�Բ�����ۻ� �򻯿��Ե�һ�ζ�Сֱ�ߵ��ۻ�
function stopDist = CalcBreakingDist(vel,model)
global dt;
MD_ACC   = 3;% 
stopDist=0;
while vel>0   %�������ٶȵ������� �ٶȼ���0���ߵľ���
    stopDist = stopDist + vel*dt;% �ƶ�����ļ��� 
    vel = vel - model(MD_ACC)*dt;% 
end

%% �ϰ���������ۺ���  ���������ڵ�ǰ�켣����������ϰ���֮��ľ��룬���û���ϰ������趨һ��������
% ���������λ�ˡ������ϰ���λ�á��ϰ���뾶
% �����������ǰԤ��Ĺ켣�յ��λ�˾��������ϰ�����������ϰ���ľ��� ��������趨�����ֵ��������ֵ
% �����ϰ������Խ������Խ��
function dist = CalcDistEval(x,ob,R)
dist=100;
for io = 1:length(ob(:,1))  
    disttmp = norm(ob(io,:)-x(1:2)')-R; %����io���ϰ���ľ��� - �ϰ���뾶  �������п��ܳ��ָ�ֵ�𣿣�
    if dist > disttmp   % ������Сֵ ��ѡ����Сֵ
        dist = disttmp;
    end
end
 
% �ϰ�����������޶�һ�����ֵ��������趨��һ��һ���켣û���ϰ����̫ռ����
if dist >= 2*R %����������
    dist = 2*R;
end
 
%% heading�����ۺ�������
% �����������ǰλ�á�Ŀ��λ��
% �����������������÷�  ��ǰ���ĺ���������Ŀ���ĺ��� ƫ��̶�ԽС ����Խ�� ���180��
function heading = CalcHeadingEval(x,goal)
theta = toDegree(x(3));% �����˳���
goalTheta = toDegree(atan2(goal(2)-x(2),goal(1)-x(1)));% Ŀ�������ڻ����˱���ķ�λ 
if goalTheta > theta
    targetTheta = goalTheta-theta;% [deg]
else
    targetTheta = theta-goalTheta;% [deg]
end
 
heading = 180 - targetTheta;  

%% ���㶯̬����
% ���� ��С�ٶ� ����ٶ� ��С���ٶ� �����ٶ��ٶ�
function Vr = CalcDynamicWindow(x,model)

V_SPD       = 4;%�������ٶ�
W_ANGLE_SPD = 5;%�����˽��ٶ� 

MD_MAX_V = 1;% 
MD_MAX_W = 2;% 
MD_ACC   = 3;% 
MD_VW    = 4;% 

global dt;
% �����ٶȵ������С��Χ ����Ϊ����С�ٶ� ����ٶ� ��С���ٶ� �����ٶ��ٶ�
Vs=[0 model(MD_MAX_V) -model(MD_MAX_W) model(MD_MAX_W)];
 
% ���ݵ�ǰ�ٶ��Լ����ٶ����Ƽ���Ķ�̬����  ����Ϊ����С�ٶ� ����ٶ� ��С���ٶ� �����ٶ��ٶ�
Vd = [x(V_SPD)-model(MD_ACC)*dt x(V_SPD)+model(MD_ACC)*dt x(W_ANGLE_SPD)-model(MD_VW)*dt x(W_ANGLE_SPD)+model(MD_VW)*dt];
 
% ���յ�Dynamic Window
Vtmp = [Vs;Vd];  %2 X 4  ÿһ������Ϊ����С�ٶ� ����ٶ� ��С���ٶ� �����ٶ��ٶ�
Vr = [max(Vtmp(:,1)) min(Vtmp(:,2)) max(Vtmp(:,3)) min(Vtmp(:,4))];
 
%% Motion Model ���ݵ�ǰ״̬������һ���������ڣ�dt����״̬
% u = [vt; wt];��ǰʱ�̵��ٶȡ����ٶ� x = ״̬[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]
function x = f(x, u)
global dt;
F = [1 0 0 0 0
     0 1 0 0 0
     0 0 1 0 0
     0 0 0 0 0
     0 0 0 0 0];
 
B = [dt*cos(x(3)) 0
    dt*sin(x(3)) 0
    0 dt
    1 0
    0 1];
 
x= F*x+B*u;  

%% degree to radian
function radian = toRadian(degree)
radian = degree/180*pi;

%% radian to degree
function degree = toDegree(radian)
degree = radian/pi*180;



%% END