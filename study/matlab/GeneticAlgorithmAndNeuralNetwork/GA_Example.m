%==========================================================
% 说明：本程序展示了采用遗传算法求解优化问题的一个具体实例
%         目的是求函数：10*sin(5x)+7*cos(4x) 的最大值，其中x∈[0,10]
%          注意本程序不具有通用性，用于其它函数需做修改
% 演示运行：确保本程序文件在当前目录，在命令窗口中键入:
%                   GA_Example
%编制：兰秋军
% 2012年1月14日
%==========================================================

%主程序
function GA_Example()
    popsize=20;%种群大小,取偶数
    iter=200;  %迭代次数
    chromlength=10; %字符串长度（个体长度）
    pc=0.6; %两个个体的交叉概率
    pm=0.001; %每个基因位的变异概率
    pop=initpop(popsize,chromlength); %随机产生初始群体
    objvalue=calobjvalue(pop); %计算目标函数
    fitvalue=calfitvalue(objvalue); %计算群体中每个个体的适应度
    for i=1:iter
        j=1;
        while j<popsize
            k1=selection(fitvalue); %选择一个体
            k2=selection(fitvalue); %选择另一个体
            [newch1,newch2]=crossover(pop(k1,:),pop(k2,:),pc); %两个个体交叉
            newch1=mutation(newch1,pm); %变异
            newch2=mutation(newch2,pm); %变异
            pop2(j,:)=newch1;
            pop2(j+1,:)=newch2;
            j=j+2;
        end
        pop_merge=[pop;pop2]; %合并新产生的个体和原种群
        objvalue_merge=calobjvalue(pop_merge); %计算合并种群目标函数
        fitvalue_merge=calfitvalue(objvalue_merge); %计算合并群体中每个个体的适应度
        [pop,fitvalue]=best(pop_merge,fitvalue_merge,popsize);  %选最大适应值的个体构成新种群
    end
    fplot('10*sin(5*x)+7*cos(4*x)',[0 7])
    hold on
    [bestchrom,bestfit]=best(pop,fitvalue,1); %最好的个体
    x=decodechrom(bestchrom,1,10); %将最佳个体转化成十进制
    x=x*10/1023; % 转化成表现型值
    y=calobjvalue(bestchrom);
    plot(x,y,'r*');
    text(x,y,strcat('(' , num2str(x) , ',' , num2str(y) , ')'));
    hold off
    
    %-------------------------------------------------------------------------
    % 功能:实现群体的初始化，
    %输入：popsize表示群体的大小
    %          chromlength表示染色体的长度(二值数的长度)
    %输出：pop:  行数为popsize，列数为chromlength的随机二进制种群基因矩阵
function pop=initpop(popsize,chromlength)
    pop=round(rand(popsize,chromlength));
    
    %-------------------------------------------------------------------------
    % 功能:将二进制数转化为十进制数
    %输入:种群二进制基因矩阵pop
function pop2=decodebinary(pop)
    [px,py]=size(pop); %求pop行和列数
    for i=1:py
        pop1(:,i)=2.^(py-i).*pop(:,i);
    end
    pop2=sum(pop1,2); %求pop1的每行之和
    
    %-------------------------------------------------------------------------
    % 功能：是将染色体(或二进制编码)转换为十进制
    %输入参数: pop 二进制种群基因矩阵
    %               spoint:表示待解码的二进制串的起始位置
    %       (对于多个变量，比如两个变量，采用20位表示，每个变量10位，则第一个变量从1开始，另一个变量从11开始。
    %             1ength表示所截取的长度
function pop2=decodechrom(pop,spoint,length)
    pop1=pop(:,spoint:spoint+length-1);
    pop2=decodebinary(pop1);
    
    %-------------------------------------------------------------------------
    % 功能：是实现目标函数的计算，其公式采用示例函数10*sin(5*x)+7*cos(4*x)，可根据不同优化问题予以修改。
function [objvalue]=calobjvalue(pop)
    temp1=decodechrom(pop,1,10); %将pop每行转化成十进制
    x=temp1*10/1023; %将二值域 中的数转化为变量域的数
    objvalue=10*sin(5*x)+7*cos(4*x); %计算目标函数值
    
    %-------------------------------------------------------------------------
    %功能：计算个体的适应值
    %输入参数objvalue为十进制数
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
    % 功能：从种群中采用赌轮盘选择法选择个体
    % 选择步骤：
    %    1） 由（1）式计算 fsum 并根据方程 pi=fi/∑fi=fi/fsumpi
    %    2） 产生 {0,1} 的随机数 r
    %    3） 求 ∑pi>r 中最小的 k ，则第 k 个个体被选中
    %输入: fitvalue 种群各个体适应值
    %输出: k    被选择的个体编号 (1开始)
function k=selection(fitvalue)
    fsum=sum(fitvalue); %求适应值之和
    cumfi=cumsum(fitvalue); %如 x=[0.1 0.2 0.3 0.4]，则 cumsum(x)=[0.1 0.3 0.6 1]
    n=length(cumfi);
    r=rand;
    for k=1:n
        if cumfi(k)>r*fsum
            break;
        end
    end
    
    %-------------------------------------------------------------------------
    %  功能:两个个体以一定的概率 pc 交叉，即两个个体从各自字符串的某一随机位置互相交换
    %输入参数：chrom1,chrom2 交叉的两个体基因
    %                 pc 交叉概率
    %输出：newchrom1,newchrom2 交叉生成的结果基因
function [newchrom1,newchrom2]=crossover(chrom1,chrom2,pc)
    if rand>=pc   %随机数超过交叉概率，则不交叉，直接返回原两个体基因
        newchrom1=chrom1;
        newchrom2=chrom2;
        return
    end   %随机数不超过交叉概率，则交叉
    n=length(chrom1); %个体基因长度
    c=ceil(rand*n); %随机产生交叉点位置 (1-n)
    newchrom1=[chrom1(1:c),chrom2(c+1:end)]; %交叉生成两新个体
    newchrom2=[chrom2(1:c),chrom1(c+1:end)];
    
    %-------------------------------------------------------------------------
    % 功能:变异(mutation)
    % 个体基因每位以概率 pm 变异，即由“1”变为“0”，  或由“0”变为“1”。
    % 输入参数：chrom  原始个体基因
    %                  pm       变异概率
    % 输出: 变异操作后的新基因
function newchrom=mutation(chrom,pm)
    n=length(chrom);
    newchrom=chrom;
    for i=1:n
        if(rand<pm)
            newchrom(i)=~newchrom(i);
        end
    end
    
    %-------------------------------------------------------------------------
    %功能:选择群体oldpop中适应值最大的popsize个个体构成新的种群
function [newpop,bestfit]=best(oldpop,fitvalue,popsize)
    [bestfit,I] = sort(fitvalue,1,'descend'); %按适应值降序排序
    newpop=oldpop(I(1:popsize),:); %选取适应值最大的popsize个个体构成新的种群
    bestfit=bestfit(1:popsize); %对应的popsize个适应值
    
    
    
