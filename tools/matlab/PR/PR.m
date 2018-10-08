%% 绘制检测器的精确率/召回率曲线
% 横轴 召回率：实际目标中正确检测出的比例（越大越好）
% 纵轴 精确率：检测出的目标中正确的比例，检测精度（越大越好）
% 智能驾驶场景中，为了防止漏检，需着重关注召回率（召回率越高，漏检越低）

% 环境：windows或linux matlab 2017a及以上
% save('results.mat', 'results')
% save('expectedResults.mat', 'expectedResults')

% 加载测试数据：模型的预测结果、期望的预测结果
load('results.mat');
load('expectedResults.mat');

% 使用平均精度来度量检测器
[ap, recall, precision] = evaluateDetectionPrecision(results, expectedResults);

% 绘制精确率/召回率曲线
figure
plot(recall,precision)
xlabel('召回率')
ylabel('精确率')
grid on
title(sprintf('平均精度 = %.2f', ap))