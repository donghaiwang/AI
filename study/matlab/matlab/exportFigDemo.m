plot(cos(linspace(0, 7, 1000)));
set(gcf, 'Position', [100 100 150 150])
saveas(gcf, 'test.png');


projectHome = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
exportFigPath = fullfile(projectHome, 'tools', 'matlab', 'export_fig');

addpath(exportFigPath);

set(gcf, 'Color', 'w');
export_fig test2.png -painters
export_fig test3_m2.5.png