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
        gridColor = MazeEnv.initGridColor;    % 坐标网格的颜色映射：1，白色（空白）；2，红色（智能体）；3，,黄色（终点），4，黑色（陷阱）
    end
    
    % Dependent属性不存数据（依赖于其他非Dependent属性），必须定义get.PropertyName方法
    % 仅在需要时确定属性的值, 并避免存储该值（如账户的从属属性余额）
%     properties (Dependent)
%         AgentPosition;      % 智能体当前的位置
%     end
    
    properties (Constant)
        height = 4;     % 网格的高度
        width = 4;      % 宽度
        initGridColor = [2,1,1,1; 1,1,4,1; 1,4,3,1; 1,1,1,1];
        
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
%         function [x, y] = get.AgentPosition(obj)
%             [x, y] = find(obj.gridColor == 2);
%         end
        
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
        
        % 构建网格环境
        function buildMazeEnv(obj)
            obj.gridColor = MazeEnv.initGridColor;
            figure('menubar','none');   % 隐藏菜单栏和工具栏
            axis off    % 隐藏坐标轴
            set(gca,'ydir','reverse','xaxislocation','top');    % 将坐标原点调整到左上角
            obj.render();
        end
        
        % 根据当前网格颜色进行实时刷新
        function render(obj)
            for h = 1 : obj.height
                for w = 1 : obj.width
                    r = rectangle('Position', [h w 1 1]);
                    switch obj.gridColor(h,w)
                        case 1
                            r.FaceColor = 'white';    % 正方体填充的颜色
                        case 2
                            r.FaceColor = 'red';        % 智能体的颜色
%                             r.EdgeColor = 'magenta';    % 智能体边框颜色为品红
%                             r.LineWidth = 3;            % 智能体边框的宽度
                        case 3
                            r.FaceColor = 'yellow';
                        case 4
                            r.FaceColor = 'black';
                    end
                end
            end
        end
        
        % 将网格重置为初始状态
        function obj = reset(obj)
            obj.gridColor = MazeEnv.initGridColor;
            obj.render();
        end
        
        % 智能体采取行动，下1，右2，左3，左4（注意：内存中起点为左上角，x轴向下，y轴向右）
        function obj = step(obj, action)    % 类中方法修改成员变量需要将修改obj返回，并且在调用的时候用目前的指针覆盖原来的指针maze = maze.step(1)
            colorMap = obj.gridColor;
            nextStatus = 0;     % 当前位置不采取行动
            [x, y] = find(obj.gridColor == 2);
            switch action
                case 1                      % 下
                    if y < obj.width        % 等于4再向上走就会超出网格区域，不采取动作
                        colorMap(x, y) = 1;       % 原来的位置设置为白色1
                        nextStatus = colorMap(x, y+1);  % 记住下一个状态，用于最后判断是否结束
                        colorMap(x, y+1) = 2;     % 移动后的位置设置为红色
                    end
                case 2                      % 右
                    if x < obj.height
                        colorMap(x, y) = 1;
                        nextStatus = colorMap(x+1, y);
                        colorMap(x+1, y) = 2;
                    end
                case 3                      % 左
                    if y > 1
                        colorMap(x, y) = 1;
                        nextStatus = colorMap(x, y-1);
                        colorMap(x, y-1) = 2;
                    end
                case 4                      %　上
                    if x > 1
                        colorMap(x, y) = 1;
                        nextStatus = colorMap(x-1, y);
                        colorMap(x-1, y) = 2;
                    end
            end
            obj.gridColor = colorMap;
            obj.render();
            if nextStatus == 3 || nextStatus == 4   % 智能体掉入坑里(3)或者找到目标(4)
                obj.render();
                pause(1);
                obj = obj.reset();
                pause(1);
            end
            pause(0.1);
        end 
    end
end
