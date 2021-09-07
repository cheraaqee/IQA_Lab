function box_plotter(the_methods, datasets)
close all
for idx_dataset = 1:length(datasets)
	stack_of_vectors = zeros(1000, 1)
	for idx_method = 1:length(the_methods)
		spears = load(['./methods/', ...
		the_methods{idx_method}, '/thousand_spears_', ...
		datasets{idx_dataset}, '_', ...
		the_methods{idx_method}, '.mat'])
		stack_of_vectors(:,idx_method) = spears.spear_results;
	end
	boxplot(stack_of_vectors, the_methods), grid on, ylabel('SROCC')
	saveas(gcf, ['./box_plot_', datasets{idx_dataset}, '.jpg'])
	close all
end
end
