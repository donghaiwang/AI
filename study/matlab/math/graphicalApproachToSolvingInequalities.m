x = 0 : 0.16 : 5;
y = 0 : 0.16 : 5;
[xx, yy] = meshgrid(x, y);

zz = xx.^yy - yy.^xx;
h = surf(x, y, zz);
h.EdgeColor = [0.7 0.7 0.7];
view(20, 50);
title('$z = x^y-y^x$', 'Interpreter', 'latex');
xlabel('x');
ylabel('y');
hold on;

c = contourc(x, y, zz, [0 0]);
list1Len = c(2, 1);
xContour = [c(1, 2:1+list1Len) NaN c(1, 3+list1Len:size(c,2))];
yContour = [c(2, 2:1+list1Len) NaN c(2, 3+list1Len:size(c,2))];

line(xContour, yContour, 'Color', 'k');

plot([0:5 2 4], [0:5 4 2], 'r.', 'MarkerSize', 25);

e = exp(1);
plot([e pi], [pi e], 'r.', 'MarkerSize', 25);
plot([e pi], [pi e], 'y.', 'MarkerSize', 10);
