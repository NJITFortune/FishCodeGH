function [b, bint, r, rint, stats] = KatiemultiRegress(y, x1, x2)
% plot the data for fun
% Usage: k_initialplotter(kg(#));

    
%% Linear Regression
% xn = normalize(x', 'range');
% yn = normalize(y', 'range');

%annoyingly necessary flipping
x1 = x1';
x2 = x2';
y = y';

%compute regression coefficients
X = [ones(size(x1)) x1 x2 x1.*x2]; %with interaction term
[b, bint, r, rint, stats] = regress(y, X); %Removes NaN data




end