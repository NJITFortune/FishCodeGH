function out =  KatieRegular(in, ReFs)
%function out = imregular(in)
%% to lazy to function
% clearvars -except kg kg2
% %out = in;
% in = kg(1);
% channel = 1;
% ReFs = 60;
% light = 3;


%k = channel;
%% prep

%generate new vectors for each channel (electrode)
for k = 1:2

    %generate new time vector with regular intervals of ReFs (60 seconds)
    out(k).xx = in.e(k).s(1).timcont:ReFs:in.e(k).s(end).timcont;

    %assign amplitude values to new time vector
    for j = length(out(k).xx):-1:1
    
        %find values a half step in either direction ReFs
        tt = find([in.e(k).s.timcont] > (out(k).xx(j)-ReFs/2) & [in.e(k).s.timcont] < (out(k).xx(j)+ReFs/2));
    
        %if there are values, assign the y to xx
        if ~isempty(tt) 
            temp(k).sumfftAmpyy(j) = in.e(k).s(tt).sumfftAmp;
    
        %if there are no values assign nan
        else
            temp(k).sumfftAmpyy(j) = nan;
        end
    
    end

    out(k).sumfftAmpyy = fillmissing(temp(k).sumfftAmpyy, 'linear');

end 

%% plot to check

figure(543); clf; hold on;
    








