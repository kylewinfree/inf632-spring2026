% run change point analysis
% this is to create the figures needed for the lecture.

close all
clear
clc

dailySteps = csvread('dailySteps.csv');
% the first column is the month number, and the second is the daily step count.  We don't need the first column, so let's drop it.
dailySteps = dailySteps(:, 2);

% Let's plot this so we have an idea of what we are working with
figure
plot(dailySteps)
xlabel('Sample (time-ish)')
ylabel('Steps per Day')
title('Original Steps per Day')
saveas(gcf, 'dailySteps.png')
pause(2)

% Let's order these and plot them all.
step_threshold = 500 % from what we will see in a second here
figure
plot(sort(dailySteps))
hold on
plot([0, length(dailySteps)], [step_threshold, step_threshold], 'm-')
xlabel('Sorted Sample (NOT time!)')
ylabel('Steps per Day')
title('Sorted Steps per Day')
saveas(gcf, 'dailySteps_sorted.png')
pause(2)

% we can see that there are some really small values, and also some really large values.
% knowing that low step counts may indicate the device wasn't worn, or was only breifly worn, we can establish a filter to remove these.
% You can consider finding the standard deviation of the dataset, and then remove the lower step counts
% Or we can threshold the data to something reasonable.  What's reasonable?  150 steps isn't "normal".  What about 250?
% I want to use 270, see the above figure
dailySteps = dailySteps(dailySteps > step_threshold, :)

% we need to mean center the data
dailySteps_err = (dailySteps - round(mean(dailySteps))); % error from mean, rounding to make it easier to see what is going on
figure
plot(dailySteps_err, 'r-')
hold on
plot([0, length(dailySteps_err)], [0, 0], 'k-')
hold off
xlabel('Sample (time-ish)')
ylabel('Error (steps per day)')
title('Error of Daily Steps, filtered')
saveas(gcf, 'dailySteps_err.png')

% next we introduce the key steps in CPA, everything before was data prep
csum_err = cumsum(dailySteps_err)
figure
plot(csum_err, 'r-')
xlabel('Sample (time-ish)')
ylabel('Cumulative Sum')
title('Cumulative Sum')
hold on
saveas(gcf, 'dailySteps_cumsum_err.png')
pause(2)

% but how much of this is from chance alone?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lets do some bootstrapping!
bootstrap_iterations = 10
csum_err_bootstrap = [];
for i = 1:bootstrap_iterations
	X_bootstrap = [dailySteps_err, rand(size(dailySteps_err))];
	X_bootstrap = sortrows(X_bootstrap, 2)(:,1);
	csum_err_bootstrap = [csum_err_bootstrap, cumsum(X_bootstrap)];
end

% show us what's going on
for i = 1:bootstrap_iterations
	plot(csum_err_bootstrap(:, i), 'b-')
end
plot(csum_err, 'r-', linewidth=3)
title('Cumulative Sum, Bootstrap 10')
saveas(gcf, 'dailySteps_cumsum_err_bootstraped_10.png')
pause(2)

hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine if we have a real change point
% this can be identified as our original data set (cumsum) being greater or lesser than the randomly sorted simulations
range_bootstrap = max(csum_err_bootstrap, [], 1) - min(csum_err_bootstrap, [], 1);
range_csum = max(csum_err, [], 1) - min(csum_err, [], 1);
[x, ix] = max(abs(csum_err));
confidence = sum(range_bootstrap < range_csum) / length(range_bootstrap)

if (confidence > .975)
	% if we have a high enough confidence (which is dependent on how many boot strap simulations we did), then we can say we have a change point
	% and if we have a change point, we have to cut the data set into two parts, left and right, and re-run this on each.
	change_point = ix
end

% cut the daily steps in half
dailySteps_left = dailySteps(1:ix)
dailySteps_right = dailySteps(ix:end)

% let's just use a copy paste from above, though I want YOU to write a function to do this...
dailySteps_err = (dailySteps_left - round(mean(dailySteps_left))); % error from mean, rounding to make it easier to see what is going on
csum_err = cumsum(dailySteps_err)
figure
plot(csum_err, 'r-')
hold on
title('Left Cumulative Sum')
saveas(gcf, 'dailySteps_left_cumsum_err.png')
pause(2)
bootstrap_iterations = 10
csum_err_bootstrap = [];
for i = 1:bootstrap_iterations
	X_bootstrap = [dailySteps_err, rand(size(dailySteps_err))];
	X_bootstrap = sortrows(X_bootstrap, 2)(:,1);
	csum_err_bootstrap = [csum_err_bootstrap, cumsum(X_bootstrap)];
end
for i = 1:bootstrap_iterations
	plot(csum_err_bootstrap(:, i), 'b-')
end
plot(csum_err, 'r-', linewidth=3)
title('Left Cumulative Sum, Bootstrap 10')%, 'Interpreter', 'latex')
saveas(gcf, 'dailySteps_left_cumsum_err_bootstraped_10.png')
pause(2)
hold off
range_bootstrap = max(csum_err_bootstrap, [], 1) - min(csum_err_bootstrap, [], 1);
range_csum = max(csum_err, [], 1) - min(csum_err, [], 1);
[x, ix] = max(abs(csum_err));
confidence = sum(range_bootstrap < range_csum) / length(range_bootstrap)

% great, so it sure looks like we have a change point in the main dataset, but not on the left alone.
% let's confirm by doing a "real" number of iterations

% again but with 1000 iterations
dailySteps_err = (dailySteps - round(mean(dailySteps))); % error from mean, rounding to make it easier to see what is going on
csum_err = cumsum(dailySteps_err)
figure
plot(csum_err, 'r-')
hold on
% saveas(gcf, 'dailySteps_left_cumsum_err.png')
% pause(2)
bootstrap_iterations = 1000
csum_err_bootstrap = [];
for i = 1:bootstrap_iterations
	X_bootstrap = [dailySteps_err, rand(size(dailySteps_err))];
	X_bootstrap = sortrows(X_bootstrap, 2)(:,1);
	csum_err_bootstrap = [csum_err_bootstrap, cumsum(X_bootstrap)];
end
for i = 1:bootstrap_iterations
	plot(csum_err_bootstrap(:, i), 'b-')
end
plot(csum_err, 'r-', linewidth=3)
title('Cumulative Sum, Bootstrap 1000')
saveas(gcf, 'dailySteps_cumsum_err_bootstraped_1000.png')
pause(2)
hold off
range_bootstrap = max(csum_err_bootstrap, [], 1) - min(csum_err_bootstrap, [], 1);
range_csum = max(csum_err, [], 1) - min(csum_err, [], 1);
[x, ix] = max(abs(csum_err));
confidence = sum(range_bootstrap < range_csum) / length(range_bootstrap)

% and the left
% let's just use a copy paste from above, though I want YOU to write a function to do this...
dailySteps_err = (dailySteps_left - round(mean(dailySteps_left))); % error from mean, rounding to make it easier to see what is going on
csum_err = cumsum(dailySteps_err)
figure
plot(csum_err, 'r-')
hold on
% saveas(gcf, 'dailySteps_left_cumsum_err.png')
% pause(2)
bootstrap_iterations = 1000
csum_err_bootstrap = [];
for i = 1:bootstrap_iterations
	X_bootstrap = [dailySteps_err, rand(size(dailySteps_err))];
	X_bootstrap = sortrows(X_bootstrap, 2)(:,1);
	csum_err_bootstrap = [csum_err_bootstrap, cumsum(X_bootstrap)];
end
for i = 1:bootstrap_iterations
	plot(csum_err_bootstrap(:, i), 'b-')
end
plot(csum_err, 'r-', linewidth=3)
title('Left Cumulative Sum, Bootstrap 1000')
saveas(gcf, 'dailySteps_left_cumsum_err_bootstraped_1000.png')
pause(2)
hold off
range_bootstrap = max(csum_err_bootstrap, [], 1) - min(csum_err_bootstrap, [], 1);
range_csum = max(csum_err, [], 1) - min(csum_err, [], 1);
[x, ix] = max(abs(csum_err));
confidence = sum(range_bootstrap < range_csum) / length(range_bootstrap)
