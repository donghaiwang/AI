%% ���Ƽ�����ľ�ȷ��/�ٻ�������
% ���� �ٻ��ʣ�ʵ��Ŀ������ȷ�����ı�����Խ��Խ�ã�
% ���� ��ȷ�ʣ�������Ŀ������ȷ�ı�������⾫�ȣ�Խ��Խ�ã�
% ���ܼ�ʻ�����У�Ϊ�˷�ֹ©�죬�����ع�ע�ٻ��ʣ��ٻ���Խ�ߣ�©��Խ�ͣ�

% ������windows��linux matlab 2017a������
% save('results.mat', 'results')
% save('expectedResults.mat', 'expectedResults')

% ���ز������ݣ�ģ�͵�Ԥ������������Ԥ����
load('results.mat');
load('expectedResults.mat');

% ʹ��ƽ�����������������
[ap, recall, precision] = evaluateDetectionPrecision(results, expectedResults);

% ���ƾ�ȷ��/�ٻ�������
figure
plot(recall,precision)
xlabel('�ٻ���')
ylabel('��ȷ��')
grid on
title(sprintf('ƽ������ = %.2f', ap))