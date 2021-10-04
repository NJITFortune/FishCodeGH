function [xx, yy] = fortunesplines(xdata, ydata, ReFs, numberofsamples)

%spline parameters
p = 0.7; %tightness of fit from 0-1

%resample xdata
%not sure how you wanted to define x so right now its just like 192
xx = 1/ReFs:1/ReFs:numberofsamples;

%fit to spline
    %estimate spline from raw data
    spliney = csaps(xdata, ydata, p);
    %define new data based on resampled x
    yy = fnval(xx, spliney);
    


