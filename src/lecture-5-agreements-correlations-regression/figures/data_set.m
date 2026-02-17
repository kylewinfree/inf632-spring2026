% make a noisey data set of randomly placed, but gaussian biased, data points to be classified as one of N different qualitative responses

close all
clear
clc

g = [gaussian(8)']*[gaussian(8)];

a = rand(100);
a(30:30+size(g,1)-1, 5:5+size(g,1)-1) = a(30:30+size(g,1)-1, 5:5+size(g,1)-1) + (g./max(max(g)));
% figure; imagesc(a)

b = rand(100);
b(5:5+size(g,1)-1, 25:25+size(g,1)-1) = b(25:25+size(g,1)-1, 25:25+size(g,1)-1) + (g./max(max(g)));
% figure; imagesc(b)

[a_x, a_y] = find(a > .99);
idx = rand(size(a_x));
a_x = a_x(idx > .75);
a_y = a_y(idx > .75);

[b_x, b_y] = find(b > .99);
idx = rand(size(b_x));
b_x = b_x(idx > .75);
b_y = b_y(idx > .75);

figure
plot(a_x, a_y, 'b+')
hold on
plot(b_x, b_y, 'ro')
title('class samples')
legend('Yes', 'No')
printfig77(gcf, 'class_samples')

figure
c_x = [a_x; b_x];
c_y = [a_y; b_y];
plot(c_x, c_y, 'ko')
title('random samples')
legend('Unknown Class')
printfig77(gcf, 'random_samples')

a = flip(a, 1);
figure, imagesc(a)
title('set a')
set(gca, 'xticklabel', '')
set(gca, 'yticklabel', '')
a = flip(a, 1);
printfig77(gcf, 'set_a')

b = flip(b, 1);
figure, imagesc(b)
title('set b')
set(gca, 'xticklabel', '')
set(gca, 'yticklabel', '')
b = flip(b, 1);
printfig77(gcf, 'set_b')

c = a .+ b;
c = flip(c, 1);
figure, imagesc(c)
title('set c')
set(gca, 'xticklabel', '')
set(gca, 'yticklabel', '')
c = flip(c, 1);
printfig77(gcf, 'set_c')

save workspace.mat