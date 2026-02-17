% run k-means

close all
clear
clc

load workspace.mat

figure
plot(c_x, c_y, 'b*')
hold on
title('Linear Regression Prediction')
P = polyfit(c_x, c_y, 1)
p_y = polyval(P, [1:100]);
plot([1:100], p_y, 'k-')
printfig77(gcf, 'linear_regression')

figure
plot(c_x, c_y, 'b*')
hold on
mu_x = mean(c_x);
mu_y = mean(c_y);
plot([1, 100], [mu_y, mu_y], 'k-')
plot([mu_x, mu_x], [1, 100], 'k-')
title('Simple mean, ONE CLUSTER')
printfig77(gcf, 'one_cluster')

% start with two points, since the data visually has two clusters
figure
plot(c_x, c_y, 'b*')
hold on

cluster = [];
data = [c_x, c_y];
for i = 1:3
	idx = ceil(rand*size(data, 1));
	cluster{i} = data(idx, :);
	retain = ones(size(data), 1);
	retain(idx) = 0;
	data = data(retain>0, :);
	plot(cluster{i}(1), cluster{i}(2), 'ko', 'MarkerSize', 9)
end

title('Select the intial centroids')
printfig77(gcf, 'two_cluster')


% then randomly select the next data point to calculate distances to
figure
plot(data(:,1), data(:,2), 'b.')
hold on
for i = 1:size(cluster{1}, 1)
	plot(cluster{1}(i, 1), cluster{1}(i, 2), 'g.')
end
for i = 1:size(cluster{2}, 1)
	plot(cluster{2}(i, 1), cluster{2}(i, 2), 'm.')
end
for i = 1:size(cluster{3}, 1)
	plot(cluster{3}(i, 1), cluster{3}(i, 2), 'c.')
end


idx = ceil(rand*length(data));
val = data(idx, :);
for i = 1:3
	dist(i) = sqrt(sum( (val - mean(cluster{i}, 1)) .^ 2));
end

s = 1;
	centroid_this = mean(cluster{s}, 1);
	plot(centroid_this(1), centroid_this(2), 'g+', 'MarkerSize', 12);
	plot([val(1), centroid_this(1)], [val(2), centroid_this(2)], 'r-')
s = 2;
	centroid_this = mean(cluster{s}, 1);
	plot(centroid_this(1), centroid_this(2), 'm+', 'MarkerSize', 12);
	plot([val(1), centroid_this(1)], [val(2), centroid_this(2)], 'r-')
s = 3;
	centroid_this = mean(cluster{s}, 1);
	plot(centroid_this(1), centroid_this(2), 'm+', 'MarkerSize', 12);
	plot([val(1), centroid_this(1)], [val(2), centroid_this(2)], 'r-')


[y, m] = min(dist); % m in the index of the minimum distance
cluster{m} = [cluster{m}; val];

% now pop this data point out of the data set
retain = ones(size(data), 1);
retain(idx) = 0;
data = data(retain>0, :);
title('First Assignment')
printfig77(gcf, 'first_assignment')

%%%%%%%%%%%%%%%%%%

figure
plot(data(:,1), data(:,2), 'b.')
hold on
for i = 1:size(cluster{1}, 1)
	plot(cluster{1}(i, 1), cluster{1}(i, 2), 'g.')
end
for i = 1:size(cluster{2}, 1)
	plot(cluster{2}(i, 1), cluster{2}(i, 2), 'm.')
end

idx = ceil(rand*length(data));
val = data(idx, :);
for i = 1:2
	dist(i) = sqrt(sum( (val - mean(cluster{i}, 1)) .^ 2));
end

s = 1;
	centroid_this = mean(cluster{s}, 1);
	plot(centroid_this(1), centroid_this(2), 'g+', 'MarkerSize', 12);
	plot([val(1), centroid_this(1)], [val(2), centroid_this(2)], 'r-')
s = 2;
	centroid_this = mean(cluster{s}, 1);
	plot(centroid_this(1), centroid_this(2), 'm+', 'MarkerSize', 12);
	plot([val(1), centroid_this(1)], [val(2), centroid_this(2)], 'r-')

[y, m] = min(dist); % m in the index of the minimum distance
cluster{m} = [cluster{m}; val];

% now pop this data point out of the data set
retain = ones(size(data), 1);
retain(idx) = 0;
data = data(retain>0, :);
title('Second Assignment')
printfig77(gcf, 'second_assignment')

%%%%%%%%%%%%%%%%%%%%%%

figure
plot(data(:,1), data(:,2), 'b.')
hold on
for i = 1:size(cluster{1}, 1)
	plot(cluster{1}(i, 1), cluster{1}(i, 2), 'g.')
end
for i = 1:size(cluster{2}, 1)
	plot(cluster{2}(i, 1), cluster{2}(i, 2), 'm.')
end

idx = ceil(rand*length(data));
val = data(idx, :);
for i = 1:2
	dist(i) = sqrt(sum( (val - mean(cluster{i}, 1)) .^ 2));
end

s = 1;
	centroid_this = mean(cluster{s}, 1);
	plot(centroid_this(1), centroid_this(2), 'g+', 'MarkerSize', 12);
	plot([val(1), centroid_this(1)], [val(2), centroid_this(2)], 'r-')
s = 2;
	centroid_this = mean(cluster{s}, 1);
	plot(centroid_this(1), centroid_this(2), 'm+', 'MarkerSize', 12);
	plot([val(1), centroid_this(1)], [val(2), centroid_this(2)], 'r-')

[y, m] = min(dist); % m in the index of the minimum distance
cluster{m} = [cluster{m}; val];

% now pop this data point out of the data set
retain = ones(size(data), 1);
retain(idx) = 0;
data = data(retain>0, :);
title('Third Assignment')
printfig77(gcf, 'third_assignment')

%%%%%%%%%%%%%%%%%%%%%%%%%

figure

while(length(data) > 0)
	if (mod(size(data, 1), 10) == 0)
		figurtime = true;
	else
		figurtime = false;
	end
	
	if (figurtime)
		plot(data(:,1), data(:,2), 'b.')
		hold on
		for i = 1:size(cluster{1}, 1)
			plot(cluster{1}(i, 1), cluster{1}(i, 2), 'g.')
		end
		for i = 1:size(cluster{2}, 1)
			plot(cluster{2}(i, 1), cluster{2}(i, 2), 'm.')
		end
	end

	idx = ceil(rand*length(data));
	val = data(idx, :);
	for i = 1:2
		dist(i) = sqrt(sum( (val - mean(cluster{i}, 1)) .^ 2));
	end

	if (figurtime)
		s = 1;
			centroid_this = mean(cluster{s}, 1);
			plot(centroid_this(1), centroid_this(2), 'g+', 'MarkerSize', 12);
			plot([val(1), centroid_this(1)], [val(2), centroid_this(2)], 'r-')
		s = 2;
			centroid_this = mean(cluster{s}, 1);
			plot(centroid_this(1), centroid_this(2), 'm+', 'MarkerSize', 12);
			plot([val(1), centroid_this(1)], [val(2), centroid_this(2)], 'r-')
	end

	[y, m] = min(dist); % m in the index of the minimum distance
	cluster{m} = [cluster{m}; val];

	% now pop this data point out of the data set
	retain = ones(size(data), 1);
	retain(idx) = 0;
	data = data(retain>0, :);
	hold off
	if (figurtime)
		title([num2str(size(data, 1)), ' remaining'])
		printfig77(gcf, ['xstep_', num2str(size(data, 1))])
	end
end

%%%%%%%%%%%%%%%%

figure
s = 1;
	centroid_this = mean(cluster{s}, 1);
	plot(centroid_this(1), centroid_this(2), 'k+', 'MarkerSize', 12);
	hold on
s = 2;
	centroid_this = mean(cluster{s}, 1);
	plot(centroid_this(1), centroid_this(2), 'k+', 'MarkerSize', 12);
	
for i = 1:size(cluster{1}, 1)
	plot(cluster{1}(i, 1), cluster{1}(i, 2), 'g.')
end
for i = 1:size(cluster{2}, 1)
	plot(cluster{2}(i, 1), cluster{2}(i, 2), 'm.')
end
title('Finished K-Means')
printfig77(gcf, 'kmeans_done')

