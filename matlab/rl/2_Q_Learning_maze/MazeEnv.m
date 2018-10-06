%% ǿ��ѧϰ���񻷾�
% ��ɫ�����Σ�        ̽����
% ��ɫ�����Σ�        �ӣ�����Ϊ-1��
% ��ɫԲȦ��          �յ㣨����Ϊ+1��
% ����״̬��          ���棨����Ϊ0��

% clear variables;
% close all;clc
%%

classdef MazeEnv
    properties
        gridColor = MazeEnv.initGridColor;    % �����������ɫӳ�䣺1����ɫ���հף���2����ɫ�������壩��3��,��ɫ���յ㣩��4����ɫ�����壩
    end
    
    % Dependent���Բ������ݣ�������������Dependent���ԣ������붨��get.PropertyName����
    % ������Ҫʱȷ�����Ե�ֵ, ������洢��ֵ�����˻��Ĵ���������
%     properties (Dependent)
%         AgentPosition;      % �����嵱ǰ��λ��
%     end
    
    properties (Constant)
        height = 4;     % ����ĸ߶�
        width = 4;      % ���
        initGridColor = [2,1,1,1; 1,1,4,1; 1,4,3,1; 1,1,1,1];
        
        Increment = 1;  % ���еĳ�����Ŀ+1
        Decrement = 0;
    end
    
    methods (Static)    % ��̬����
        function count = refcount(increment)
            persistent AppCount;    % ����Ӧ����Ŀ��ͳ��
            if (isempty(AppCount))
                AppCount = 1;
            else
                if (increment)
                    AppCount = plus(AppCount,1);    % ��������������������
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
        
        % �������ڳ���
        function startApp(obj)
            % ����.m�ļ���һ�����ü������������ļ�
            mlock;
            MazeEnv.refcount(obj.Increment);
            buildMazeEnv(obj);
            munlock;
        end
        
        % �������񻷾�
        function buildMazeEnv(obj)
            obj.gridColor = MazeEnv.initGridColor;
            figure('menubar','none');   % ���ز˵����͹�����
            axis off    % ����������
            set(gca,'ydir','reverse','xaxislocation','top');    % ������ԭ����������Ͻ�
            obj.render();
        end
        
        % ���ݵ�ǰ������ɫ����ʵʱˢ��
        function render(obj)
            for h = 1 : obj.height
                for w = 1 : obj.width
                    r = rectangle('Position', [h w 1 1]);
                    switch obj.gridColor(h,w)
                        case 1
                            r.FaceColor = 'white';    % ������������ɫ
                        case 2
                            r.FaceColor = 'red';        % ���������ɫ
%                             r.EdgeColor = 'magenta';    % ������߿���ɫΪƷ��
%                             r.LineWidth = 3;            % ������߿�Ŀ��
                        case 3
                            r.FaceColor = 'yellow';
                        case 4
                            r.FaceColor = 'black';
                    end
                end
            end
        end
        
        % ����������Ϊ��ʼ״̬
        function obj = reset(obj)
            obj.gridColor = MazeEnv.initGridColor;
            obj.render();
        end
        
        % �������ȡ�ж�����1����2����3����4��ע�⣺�ڴ������Ϊ���Ͻǣ�x�����£�y�����ң�
        function obj = step(obj, action)    % ���з����޸ĳ�Ա������Ҫ���޸�obj���أ������ڵ��õ�ʱ����Ŀǰ��ָ�븲��ԭ����ָ��maze = maze.step(1)
            colorMap = obj.gridColor;
            nextStatus = 0;     % ��ǰλ�ò���ȡ�ж�
            [x, y] = find(obj.gridColor == 2);
            switch action
                case 1                      % ��
                    if y < obj.width        % ����4�������߾ͻᳬ���������򣬲���ȡ����
                        colorMap(x, y) = 1;       % ԭ����λ������Ϊ��ɫ1
                        nextStatus = colorMap(x, y+1);  % ��ס��һ��״̬����������ж��Ƿ����
                        colorMap(x, y+1) = 2;     % �ƶ����λ������Ϊ��ɫ
                    end
                case 2                      % ��
                    if x < obj.height
                        colorMap(x, y) = 1;
                        nextStatus = colorMap(x+1, y);
                        colorMap(x+1, y) = 2;
                    end
                case 3                      % ��
                    if y > 1
                        colorMap(x, y) = 1;
                        nextStatus = colorMap(x, y-1);
                        colorMap(x, y-1) = 2;
                    end
                case 4                      %����
                    if x > 1
                        colorMap(x, y) = 1;
                        nextStatus = colorMap(x-1, y);
                        colorMap(x-1, y) = 2;
                    end
            end
            obj.gridColor = colorMap;
            obj.render();
            if nextStatus == 3 || nextStatus == 4   % ������������(3)�����ҵ�Ŀ��(4)
                obj.render();
                pause(1);
                obj = obj.reset();
                pause(1);
            end
            pause(0.1);
        end 
    end
end
