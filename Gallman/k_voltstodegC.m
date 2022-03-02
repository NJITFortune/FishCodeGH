
in = kg(103);

%define input variables
Rig = in.info.folder(end);
temptims = [in.info.temptims];

%define variables for calculations
    %constants
    c1 = 1.009249522e-03;
    c2 = 2.378405444e-04; 
    c3 = 2.019202697e-07;

%thermister calibration by tank
    R1a = 9630; % adjust for each from 10000 //9500
    R1b = 9800; %adjust for each from 10000 //9500//11500
    R1c = 11000; % adjust for each from 10000 //9500


    if Rig == 'A'
        R1 = R1a;
    end
    
    if Rig == 'B'
        R1 = R1b;
    end
    
    if Rig == 'C'
        R1 = R1c;
    end
    


for j = 1:length(temptims)
  
  R2 = R1 * ((1023.0 / temptims(j)) - 1.0);
  logR2a = log(R2);
  Ta = (1.0 / (c1 + c2*logR2 + c3*logR2a*logR2a*logR2a));
  Ta = Ta - 273.15;

  Serial.print("Temperature A: "); 
  Serial.print(Ta);
  Serial.println(" C"); 

















