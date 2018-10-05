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
        gridColor = [2,1,1,1; 1,1,4,1; 1,4,3,1; 1,1,1,1];    % �����������ɫӳ�䣺1����ɫ���հף���2����ɫ�������壩��3��,��ɫ���յ㣩��4����ɫ�����壩
    end
    
    % Dependent���Բ������ݣ�������������Dependent���ԣ������붨��get.PropertyName����
    % ������Ҫʱȷ�����Ե�ֵ, ������洢��ֵ�����˻��Ĵ���������
    properties (Constant)
        height = 4;     % ����ĸ߶�
        width = 4;      % ���
        
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
        
        function buildMazeEnv(obj)
            figure('menubar','none');   % ���ز˵����͹�����
            axis off    % ����������
            for h = 1 : obj.height
                for w = 1 : obj.width
                    r = rectangle('Position', [h w 1 1]);
                    switch obj.gridColor(h,w)
                        case 1
                            r.FaceColor = 'white';    % ������������ɫ
                        case 2
                            r.FaceColor = 'red';        % ���������ɫ
                            r.EdgeColor = 'magenta';    % ������߿���ɫΪƷ��
                            r.LineWidth = 3;            % ������߿�Ŀ��
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
% %ϵͳ����
% img=checkerboard(32)>0.5;
% figure;
% imshow(img,[])
