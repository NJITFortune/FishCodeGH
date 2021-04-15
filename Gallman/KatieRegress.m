function [Rsq, yCalc] = KatieRegress(x, y)
% plot the data for fun
% Usage: k_initialplotter(kg(#));

    
%% Linear Regression
xn = normalize(x, 'range');
yn = normalize(y, 'range');



X = [ones(length(xn),1) xn];
b = X\yn;
yCalc = X*b;

Rsq = 1 - sum((yn - yCalc).^2)/sum((yn - mean(yn)).^2);
%b1 = x/y;
%yCalc1 = b1*x;
end