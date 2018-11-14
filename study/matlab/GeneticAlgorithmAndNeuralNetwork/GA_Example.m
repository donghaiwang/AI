%==========================================================
% ˵����������չʾ�˲����Ŵ��㷨����Ż������һ������ʵ��
%         Ŀ����������10*sin(5x)+7*cos(4x) �����ֵ������x��[0,10]
%          ע�Ȿ���򲻾���ͨ���ԣ������������������޸�
% ��ʾ���У�ȷ���������ļ��ڵ�ǰĿ¼����������м���:
%                   GA_Example
%���ƣ������
% 2012��1��14��
%==========================================================

%������
function GA_Example()
    popsize=20;%��Ⱥ��С,ȡż��
    iter=200;  %��������
    chromlength=10; %�ַ������ȣ����峤�ȣ�
    pc=0.6; %��������Ľ������
    pm=0.001; %ÿ������λ�ı������
    pop=initpop(popsize,chromlength); %���������ʼȺ��
    objvalue=calobjvalue(pop); %����Ŀ�꺯��
    fitvalue=calfitvalue(objvalue); %����Ⱥ����ÿ���������Ӧ��
    for i=1:iter
        j=1;
        while j<popsize
            k1=selection(fitvalue); %ѡ��һ����
            k2=selection(fitvalue); %ѡ����һ����
            [newch1,newch2]=crossover(pop(k1,:),pop(k2,:),pc); %�������彻��
            newch1=mutation(newch1,pm); %����
            newch2=mutation(newch2,pm); %����
            pop2(j,:)=newch1;
            pop2(j+1,:)=newch2;
            j=j+2;
        end
        pop_merge=[pop;pop2]; %�ϲ��²����ĸ����ԭ��Ⱥ
        objvalue_merge=calobjvalue(pop_merge); %����ϲ���ȺĿ�꺯��
        fitvalue_merge=calfitvalue(objvalue_merge); %����ϲ�Ⱥ����ÿ���������Ӧ��
        [pop,fitvalue]=best(pop_merge,fitvalue_merge,popsize);  %ѡ�����Ӧֵ�ĸ��幹������Ⱥ
    end
    fplot('10*sin(5*x)+7*cos(4*x)',[0 7])
    hold on
    [bestchrom,bestfit]=best(pop,fitvalue,1); %��õĸ���
    x=decodechrom(bestchrom,1,10); %����Ѹ���ת����ʮ����
    x=x*10/1023; % ת���ɱ�����ֵ
    y=calobjvalue(bestchrom);
    plot(x,y,'r*');
    text(x,y,strcat('(' , num2str(x) , ',' , num2str(y) , ')'));
    hold off
    
    %-------------------------------------------------------------------------
    % ����:ʵ��Ⱥ��ĳ�ʼ����
    %���룺popsize��ʾȺ��Ĵ�С
    %          chromlength��ʾȾɫ��ĳ���(��ֵ���ĳ���)
    %�����pop:  ����Ϊpopsize������Ϊchromlength�������������Ⱥ�������
function pop=initpop(popsize,chromlength)
    pop=round(rand(popsize,chromlength));
    
    %-------------------------------------------------------------------------
    % ����:����������ת��Ϊʮ������
    %����:��Ⱥ�����ƻ������pop
function pop2=decodebinary(pop)
    [px,py]=size(pop); %��pop�к�����
    for i=1:py
        pop1(:,i)=2.^(py-i).*pop(:,i);
    end
    pop2=sum(pop1,2); %��pop1��ÿ��֮��
    
    %-------------------------------------------------------------------------
    % ���ܣ��ǽ�Ⱦɫ��(������Ʊ���)ת��Ϊʮ����
    %�������: pop ��������Ⱥ�������
    %               spoint:��ʾ������Ķ����ƴ�����ʼλ��
    %       (���ڶ��������������������������20λ��ʾ��ÿ������10λ�����һ��������1��ʼ����һ��������11��ʼ��
    %             1ength��ʾ����ȡ�ĳ���
function pop2=decodechrom(pop,spoint,length)
    pop1=pop(:,spoint:spoint+length-1);
    pop2=decodebinary(pop1);
    
    %-------------------------------------------------------------------------
    % ���ܣ���ʵ��Ŀ�꺯���ļ��㣬�乫ʽ����ʾ������10*sin(5*x)+7*cos(4*x)���ɸ��ݲ�ͬ�Ż����������޸ġ�
function [objvalue]=calobjvalue(pop)
    temp1=decodechrom(pop,1,10); %��popÿ��ת����ʮ����
    x=temp1*10/1023; %����ֵ�� �е���ת��Ϊ���������
    objvalue=10*sin(5*x)+7*cos(4*x); %����Ŀ�꺯��ֵ
    
    %-------------------------------------------------------------------------
    %���ܣ�����������Ӧֵ
    %�������objvalueΪʮ������
function fitvalue=calfitvalue(objvalue)
    global Cmin;
    Cmin=0;
    [px,py]=size(objvalue);
    for i=1:px
        if objvalue(i)+Cmin>0
            temp=Cmin+objvalue(i);
        else
            temp=0.0;
        end
        fitvalue(i)=temp;
    end
    fitvalue=fitvalue';
    
    %-------------------------------------------------------------------------
    % ���ܣ�����Ⱥ�в��ö�����ѡ��ѡ�����
    % ѡ���裺
    %    1�� �ɣ�1��ʽ���� fsum �����ݷ��� pi=fi/��fi=fi/fsumpi
    %    2�� ���� {0,1} ������� r
    %    3�� �� ��pi>r ����С�� k ����� k �����屻ѡ��
    %����: fitvalue ��Ⱥ��������Ӧֵ
    %���: k    ��ѡ��ĸ����� (1��ʼ)
function k=selection(fitvalue)
    fsum=sum(fitvalue); %����Ӧֵ֮��
    cumfi=cumsum(fitvalue); %�� x=[0.1 0.2 0.3 0.4]���� cumsum(x)=[0.1 0.3 0.6 1]
    n=length(cumfi);
    r=rand;
    for k=1:n
        if cumfi(k)>r*fsum
            break;
        end
    end
    
    %-------------------------------------------------------------------------
    %  ����:����������һ���ĸ��� pc ���棬����������Ӹ����ַ�����ĳһ���λ�û��ཻ��
    %���������chrom1,chrom2 ��������������
    %                 pc �������
    %�����newchrom1,newchrom2 �������ɵĽ������
function [newchrom1,newchrom2]=crossover(chrom1,chrom2,pc)
    if rand>=pc   %���������������ʣ��򲻽��棬ֱ�ӷ���ԭ���������
        newchrom1=chrom1;
        newchrom2=chrom2;
        return
    end   %�����������������ʣ��򽻲�
    n=length(chrom1); %������򳤶�
    c=ceil(rand*n); %������������λ�� (1-n)
    newchrom1=[chrom1(1:c),chrom2(c+1:end)]; %�����������¸���
    newchrom2=[chrom2(1:c),chrom1(c+1:end)];
    
    %-------------------------------------------------------------------------
    % ����:����(mutation)
    % �������ÿλ�Ը��� pm ���죬���ɡ�1����Ϊ��0����  ���ɡ�0����Ϊ��1����
    % ���������chrom  ԭʼ�������
    %                  pm       �������
    % ���: �����������»���
function newchrom=mutation(chrom,pm)
    n=length(chrom);
    newchrom=chrom;
    for i=1:n
        if(rand<pm)
            newchrom(i)=~newchrom(i);
        end
    end
    
    %-------------------------------------------------------------------------
    %����:ѡ��Ⱥ��oldpop����Ӧֵ����popsize�����幹���µ���Ⱥ
function [newpop,bestfit]=best(oldpop,fitvalue,popsize)
    [bestfit,I] = sort(fitvalue,1,'descend'); %����Ӧֵ��������
    newpop=oldpop(I(1:popsize),:); %ѡȡ��Ӧֵ����popsize�����幹���µ���Ⱥ
    bestfit=bestfit(1:popsize); %��Ӧ��popsize����Ӧֵ
    
    
    
