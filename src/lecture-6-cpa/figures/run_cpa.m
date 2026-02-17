% run change point analysis
% this is to create the figures needed for the lecture.

dailySteps = csvread('dailySteps.csv');
% the first column is the month number, and the second is the daily step count.  We don't need the first column, so let's drop it.
dailySteps = dailySteps(:, 2);

% Let's plot this so we have an idea of what we are working with
plot(dailySteps)
saveas(gcf, 'all_daily_steps.png')
pause

% Let's order these and plot them all.
plot(sort(dailySteps))
saveas(gcf, 'all_daily_steps_sorted.png')
pause

% we can see that there are some really small values, and also some really large values.
% knowing that low step counts may indicate the device wasn't worn, or was only breifly worn, we can establish a filter to remove these.
% You can consider finding the standard deviation of the dataset, and then remove the lower step counts
% Or we can threshold the data to something reasonable.  What's reasonable?  150 steps isn't "normal".  What about 250?
% I want to use 270, see the above figure
dailySteps = dailySteps(dailySteps > 270, :)

% we need to mean center the data
dailySteps_err = (dailySteps - round(mean(dailySteps))); % error from mean, rounding to make it easier to see what is going on

% next we introduce the key steps in CPA, everything before was data prep
csum_err = cumsum(dailySteps_err)
plot(csum_err, 'r-')
saveas(gcf, 'all_daily_steps_cumsum_err.png')
pause

% but how much of this is from chance alone?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lets do some bootstrapping!
bootstrap_iterations = 10
csum_err_bootstrap = [];
for i = 1:bootstrap_iterations
	X_bootstrap = [dailySteps_err', rand(size(dailySteps_err'))];
	X_bootstrap = sortrows(X_bootstrap, 2)'(1,:);
	csum_err_bootstrap = [csum_err_bootstrap; cumsum(X_bootstrap)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine if we have a real change point
range_bootstrap = max(csum_err_bootstrap, [], 2) - min(csum_err_bootstrap, [], 2);
range_csum = max(csum_err, [], 2) - min(csum_err, [], 2);
[x, ix] = max(abs(csum_err))
% change_point = T(ix);