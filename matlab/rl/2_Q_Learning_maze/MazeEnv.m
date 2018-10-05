%% 强化学习网格环境
% 红色正方形：        探索者
% 黑色正方形：        坑（奖励为-1）
% 黄色圆圈：          终点（奖励为+1）
% 其他状态：          地面（奖励为0）

% clear variables;
% close all;clc
%%

classdef MazeEnv
    properties
        gridColor = [2,1,1,1; 1,1,4,1; 1,4,3,1; 1,1,1,1];    % 坐标网格的颜色映射：1，白色（空白）；2，红色（智能体）；3，,黄色（终点），4，黑色（陷阱）
    end
    
    % Dependent属性不存数据（依赖于其他非Dependent属性），必须定义get.PropertyName方法
    % 仅在需要时确定属性的值, 并避免存储该值（如账户的从属属性余额）
    properties (Constant)
        height = 4;     % 网格的高度
        width = 4;      % 宽度
        
        Increment = 1;  % 运行的程序数目+1
        Decrement = 0;
    end
    
    methods (Static)    % 静态方法
        function count = refcount(increment)
            persistent AppCount;    % 启动应用数目的统计
            if (isempty(AppCount))
                AppCount = 1;
            else
                if (increment)
                    AppCount = plus(AppCount,1);    % 可以启用类的运算符重载
                else
                    AppCount = minus(AppCount,1);
                    if AppCount < 0
                        AppCount = 0;
                    end
                end
            end
            count = AppCount;
        end
    end
    
    methods
        function obj = MazeEnv()
            startApp(obj);
        end
        
        % 启动窗口程序
        function startApp(obj)
            % 增加.m文件的一个引用计数，并锁定文件
            mlock;
            MazeEnv.refcount(obj.Increment);
            buildMazeEnv(obj);
            munlock;
        end
        
        function buildMazeEnv(obj)
            figure('menubar','none');   % 隐藏菜单栏和工具栏
            axis off    % 隐藏坐标轴
            for h = 1 : obj.height
                for w = 1 : obj.width
                    r = rectangle('Position', [h w 1 1]);
                    switch obj.gridColor(h,w)
                        case 1
                            r.FaceColor = 'white';    % 正方体填充的颜色
                        case 2
                            r.FaceColor = 'red';        % 智能体的颜色
                            r.EdgeColor = 'magenta';    % 智能体边框颜色为品红
                            r.LineWidth = 3;            % 智能体边框的宽度
                        case 3
                            r.FaceColor = 'yellow';
                        case 4
                            r.FaceColor = 'black';
                    end
                end
            end
        end
    end
    
    
end


% h=256;
% w=256;
% n=8;
% img=zeros(h,w);
%
% flag=1;
% for y=1:h
%     for x=1:w
%         if flag>0
%             img(y,x)=255;
%         end
%         if mod(x,int8(w/n))==0
%             flag=-flag;
%         end
%     end
%     if mod(y,int8(h/n))==0
%         flag=-flag;
%     end
% end
% imshow(img)
%
% %系统调用
% img=checkerboard(32)>0.5;
% figure;
% imshow(img,[])
