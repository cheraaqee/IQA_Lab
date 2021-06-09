function [corr_coef RMSE] = PearsonLC(pred,label)
objectiveValues=pred;
mos=label;

%plot objective-subjective score pairs
 p = plot(objectiveValues,mos,'+');
 set(p,'Color','blue','LineWidth',1);

%initialize the parameters used by the nonlinear fitting function
% beta(1) = max(mos);
% beta(2) = 5;
% beta(3) = mean(objectiveValues);
% beta(4) = 0.1;
% beta(5) = 0.1;

beta(1) = max(mos);
beta(2) =min(mos);
beta(3) = mean(objectiveValues);
beta(4) = 0.10;
beta(5) = 0.10;

%fitting a curve using the data
[bayta ehat,J] = nlinfit(objectiveValues,mos,@logistic,beta);
%given an objective value, predict the correspoing mos (ypre) using the fitted curve
[ypre junk] = nlpredci(@logistic,objectiveValues,bayta,ehat,J);

RMSE = sqrt(sum((ypre - mos).^2) / length(mos));%root meas squared error
corr_coef = corr(mos, ypre, 'type','Pearson') %pearson linear coefficient

%draw the fitted curve
t = min(objectiveValues):0.01:max(objectiveValues);
[ypre junk] = nlpredci(@logistic,t,bayta,ehat,J);
hold on;
p = plot(t,ypre);
set(p,'Color','red','LineWidth',2);
legend('Images in CUHK','Curve fitted with logistic function', 'Location','NorthWest');
xlabel('Objective score by Proposed Method');
ylabel('MOS');

% SpearmanCor=corr(mos, objectiveValues,'type','Spearman')
% KendallCor=corr(mos, objectiveValues,'type','Kendall')


