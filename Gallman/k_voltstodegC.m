function tempC = k_voltstodegC(in, channel)
%clearvars -except kg kg2

% in = kg(103);
% channel = 1;

%define input variables
Rig = in.info.folder(end);
tempV = [in.e(channel).s.temp];
timcont = [in.e(channel).s.timcont] / (60*60);
%define variables for calculations
    %constants
    c1 = 1.009249522e-03;
    c2 = 2.378405444e-04; 
    c3 = 2.019202697e-07;

%thermister calibration by tank
    R1a = 9630; % adjust for each from 10000 //9500
    R1b = 9800; %adjust for each from 10000 //9500//11500
    R1c = 11000; % adjust for each from 10000 //9500
    R1d = 9700; % adjust for each from 10000 //9500
    R1e = 10000; % adjust for each from 10000 //9500//11500


    if Rig == 'A'
        R1 = R1a;
    end
    
    if Rig == 'B'
        R1 = R1b;
    end
    
    if Rig == 'C'
        R1 = R1c;
    end
    
    if Rig == 'D'
        R1 = R1d;
    end

    if Rig == 'E'
        R1 = R1e;
    end

%analogread converts voltage to a digital value from 0-1023
%voltage * (1023/5) adapts the arduino code for the NiDaq

for j = 1:length(tempV)
  
  R2 = R1 * ((1023.0 / (tempV(j)*(1023/5))) - 1.0);

  logR2 = log(R2);

  T = 1.0 / (c1 + c2*logR2 + c3*logR2*logR2*logR2);

  tempC(j,:) = T - 273.15;

end

 %% plot to check

 figure(453); clf; hold on;

    ax(1) = subplot(211); title('Temp in Volts'); hold on;
        plot(timcont, tempV, '-');

    ax(2) = subplot(212); title('Temp in degC'); hold on;
        plot(timcont, tempC, '-');
















