% run KNN on the loaded data set

close all
clear
clc

load workspace.mat

figure
% plot(a_x, a_y, 'b+')
% hold on
% plot(b_x, b_y, 'ro')

X = [a_x, a_y, ones(size(a_x))];
X = [X; b_x, b_y, zeros(size(b_x))];

for n = 1:3:10
	for i = 1:100
		for j = 1:100
			% now find the nearest n other data points and use the rounded mean to classify this point
			D = [sqrt(sum( ([i, j] - X(:,1:2)) .^ 2 , 2)), X(:, 3)];
			P = mean(sortrows(D, 1)(1:n, 2));
			Y(i, j) = round(P);
		end
	end

	[A_x, A_y] = find(Y >= .5);
	[B_x, B_y] = find(Y < .5);
	figure
	plot(A_x, A_y, 'b.', 'MarkerSize', 3);
	hold on
	plot(B_x, B_y, 'r.', 'MarkerSize', 3);

	plot(a_x, a_y, 'bo')
	plot(b_x, b_y, 'ro')
	title(['KNN(n=', num2str(n), ')'])
	printfig77(gcf, ['KNN', num2str(n)]);
end