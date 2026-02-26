close all
clear
clc

dailySteps = csvread('dailySteps.csv');
dailySteps = dailySteps(:,2);

figure
plot(dailySteps)
title('dailySteps')

figure
plot(sort(dailySteps))
title('sort dailySteps')

steps_threshold = 514;
dailySteps = dailySteps(dailySteps > steps_threshold, :);

dailySteps_err = dailySteps - round(mean(dailySteps));

figure
plot(dailySteps_err, 'r-')
title('dailySteps_err')

csum_err = cumsum(dailySteps_err);

figure
plot(csum_err, 'r-')
title('csum_err')

iters = 100
csum_err_boots = [];
for i = 1:iters
	% bootstrapping
	X_boots = [dailySteps_err, rand(size(dailySteps))];
	X_boots = sortrows(X_boots, 2)(:, 1);
	csum_err_boots = [csum_err_boots, cumsum(X_boots)];
end
figure
hold on
for i = 1:iters
	plot(csum_err_boots(:, i), 'b-')
end

plot(csum_err, 'r-')
title('csum_err and boots')

range_boots = max(csum_err_boots, [], 1) - min(csum_err_boots, [], 1);
range_csum = max(csum_err, [], 1) - min(csum_err, [], 1);
[x, ix] = max(abs(csum_err))

confidence = sum(range_boots < range_csum) / iters

%%%%%%%%%%%%%%%%%

dailySteps_right = dailySteps(ix:end);

dailySteps_err = dailySteps_right - round(mean(dailySteps_right));
csum_err = cumsum(dailySteps_err);

iters = 100
csum_err_boots = [];
for i = 1:iters
	% bootstrapping
	X_boots = [dailySteps_err, rand(size(dailySteps_right))];
	X_boots = sortrows(X_boots, 2)(:, 1);
	csum_err_boots = [csum_err_boots, cumsum(X_boots)];
end
figure
hold on
for i = 1:iters
	plot(csum_err_boots(:, i), 'b-')
end

plot(csum_err, 'r-')
title('csum_err and boots RIGHT')

range_boots = max(csum_err_boots, [], 1) - min(csum_err_boots, [], 1);
range_csum = max(csum_err, [], 1) - min(csum_err, [], 1);
[x, ix] = max(abs(csum_err))

confidence = sum(range_boots < range_csum) / iters


