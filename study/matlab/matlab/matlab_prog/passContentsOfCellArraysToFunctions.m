randCell = {'Random Data', rand(20, 2)};
plot(randCell{1,2});
title(randCell{1, 1});

%%
figure
plot(randCell{1, 2}(:,1));
title('First Column of Data');

%%
temperature(1, :) = { '01-Jan-2010', [45, 49, 0] };
temperature(2, :) = { '03-Apr-2010', [54, 68, 21] };
temperature(3, :) = { '20-Jun-2010', [72, 85, 53] };
temperature(4, :) = { '15-Sep-2010', [63, 81, 56] };
temperature(5, :) = { '31-Dec-2010', [38, 54, 18] };

allTemps = cell2mat( temperature(:, 2) );
dates = datenum(temperature(:, 1), 'dd-mmm-yyyy');

plot(dates, allTemps)
datetick('x', 'mmm')

%%
X = -pi : pi/10 : pi;
Y = tan(sin(X)) - sin(tan(X));

C(:, 1) = {'LineWidth'; 2};
C(:, 2) = {'MarkerEdgeColor'; 'k' };
C(:, 3) = { 'MarkerFaceColor'; 'g' };

plot(X, Y, '--rs', C{:});
