function [Rsq, yCalc] = KatieRegress(x, y)
% plot the data for fun
% Usage: k_initialplotter(kg(#));

    
%% Linear Regression
x = x';
y = y';
x = normalize(x, 'range');
y = normalize(y, 'range');

X = [ones(length(x),1) x];
b = X\y;
yCalc = X*b;

Rsq = 1 - sum((y - yCalc).^2)/sum((y - mean(y)).^2);
%b1 = x/y;
%yCalc1 = b1*x;
end