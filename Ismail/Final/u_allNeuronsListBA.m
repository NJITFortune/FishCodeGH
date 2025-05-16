% This is a listing of all of the neurons for this project, from file
% ismailCompleatFinal2024.mat
%
%

%% Load data
% load /Users/efortune/NotCloudy/ismailCompleatFinal2024.mat

%% Name LUT
fishNames{13} = 'Tolstoy';
fishNames{1} = 'Andre';
fishNames{2} = 'Ankara';
fishNames{3} = 'BammBamm';
fishNames{4} = 'Bent';
fishNames{5} = 'Brown';
fishNames{6} = 'BrownieOne';
fishNames{7} = 'BrownieTwo';
fishNames{8} = 'Bumpy';
fishNames{9} = 'Fin';
fishNames{10} = 'Goldy';
fishNames{11} = 'Hobo';
fishNames{12} = 'Penn';

%% Build a useful table as a starting point for analysis
% [fish, neuron, duration, number of spikes, px for EV, px for FA]
% the px are a threshold, in pixels, for roughly half of the number
% of spikes... e.g. slow half is below 65 px/s and fast half above.

clear neuronsAll

% andre_2019_04_10, 1439 (65 px EV 270 FA)
neuronsAll(1,:) = [1, 1, 1439, 10270, 65, 270]; %%%%  NR*
neuronsAll(2,:) = [1, 2, 1439, 2236, 65, 270]; % NR
neuronsAll(3,:) = [1, 3, 1439, 5557, 65, 270]; % NR
neuronsAll(4,:) = [1, 4, 1439, 1605, 65, 270]; % NR 
neuronsAll(5,:) = [1, 5, 1439, 2857, 65, 270]; % NR
neuronsAll(6,:) = [1, 6, 1439, 849, 65, 270]; % TOO FEW SPIKES

% ankara_2019_01_31, 689 (90 px EV 220 FA)
neuronsAll(7,:) = [2, 1, 689, 6851, 90, 220]; % NR*
neuronsAll(8,:) = [2, 2, 689, 8355, 90, 220]; % NR
neuronsAll(9,:) = [2, 3, 689, 1160, 90, 220]; % NR
neuronsAll(10,:) = [2, 4, 689, 14515, 90, 220]; %%%  NR      
neuronsAll(11,:) = [2, 5, 689, 7346, 90, 220]; % NR
neuronsAll(12,:) = [2, 6, 689, 18630, 90, 220]; %%%  NR
neuronsAll(13,:) = [2, 7, 689, 661, 90, 220]; % TOO FEW SPIKES
neuronsAll(14,:) = [2, 8, 689, 5033, 90, 220]; % NR

% bammbamm_2019_04_12, 809 (100 px EV 525 FA)
neuronsAll(15,:) = [3, 1, 809, 15627, 100, 525]; %%%% PosCent        PosHi/PosHi More Sensory
neuronsAll(16,:) = [3, 2, 809, 9609, 100, 525]; %%%%% PosIcon        PosHi/NR Velocity neuron
neuronsAll(17,:) = [3, 3, 809, 8538, 100, 525]; %%%%% PosCent        PosHi/PosHi More Sensory
neuronsAll(18,:) = [3, 4, 809, 11327, 100, 525]; %%%% NegIcon/Cent   NegHi/NegHi More Sensory
neuronsAll(19,:) = [3, 5, 809, 10009, 100, 525]; %%%% NegIcon        NegHi/NegHi
neuronsAll(20,:) = [3, 6, 809, 6637, 100, 525]; %%%%% NegIcon/Cent   NegHi/NegHi

% bent_2019_02_26, 1469 (75 px EV 260 FA)
neuronsAll(21,:) = [4, 1, 1469, 28860, 75, 260]; %%% NR!!!!!!!!!!!!
neuronsAll(22,:) = [4, 2, 1469, 30154, 75, 260]; %%% PosSens WEAK  WeakPosHi/WeakNegHi
neuronsAll(23,:) = [4, 3, 1469, 9759, 75, 260]; %%%% PosSens       PosHi/NegHi
neuronsAll(24,:) = [4, 4, 1469, 4220, 75, 260]; %%%% PosSens WEAK  PosHi/Weirdness
neuronsAll(25,:) = [4, 5, 1469, 27233, 75, 260]; %%% NR!!!!!!!!!!!!
neuronsAll(26,:) = [4, 6, 1469, 7761, 75, 260]; %%%% PosSens       PosHi, Sensory? Passive fish?

% brown_2018_09_25, 299 - TRACKING Off by a factor of 10 (14 px EV 70 FA)
neuronsAll(27,:) = [5, 1, 299, 3600, 14, 70]; % NR
neuronsAll(28,:) = [5, 2, 299, 5271, 14, 70]; %%%%  NR
neuronsAll(29,:) = [5, 3, 299, 1444, 14, 70]; % 
neuronsAll(30,:) = [5, 4, 299, 1909, 14, 70]; % 
neuronsAll(31,:) = [5, 5, 299, 807, 14, 70]; % TOO FEW SPIKES

% brownie_p1_2019_01_26, 539 (125 px EV 330 FA)
neuronsAll(32,:) = [6, 1, 539, 2777, 125, 330]; %%%%  NegSens   Sensory NegHi
neuronsAll(33,:) = [6, 2, 539, 3501, 125, 330]; %%%%  NR
neuronsAll(34,:) = [6, 3, 539, 2433, 125, 330]; %%%%  NR   Weakest Sensory NegHi
neuronsAll(35,:) = [6, 4, 539, 4106, 125, 330]; %%%%  NR
neuronsAll(36,:) = [6, 5, 539, 2937, 125, 330]; %%%%  NegSens WEAK 
neuronsAll(37,:) = [6, 6, 539, 1334, 125, 330]; % 
neuronsAll(38,:) = [6, 7, 539, 2597, 125, 330]; %%%%  NR   Weak Sensory NegHi
neuronsAll(39,:) = [6, 8, 539, 516, 125, 330]; % TOO FEW SPIKES

% brownie_p2_2019_01_26, 389 (100 px EV 360 FA)
neuronsAll(40,:) = [7, 1, 389, 3847, 100, 360]; %%%% PosCent   Something is going on here
neuronsAll(41,:) = [7, 2, 389, 1055, 100, 360]; % Messy
neuronsAll(42,:) = [7, 3, 389, 277, 100, 360]; % TOO FEW SPIKES
neuronsAll(43,:) = [7, 4, 389, 1072, 100, 360]; % NR

% bumpy_2019_04_03, 1229 (55 px EV 165 FA)
neuronsAll(44,:) = [8, 1, 1229, 24303, 55, 165]; %%% Too late, NR Reanalyze %% Limits %%%
neuronsAll(45,:) = [8, 2, 1229, 10599, 55, 165]; % Messy Reanalyze
neuronsAll(46,:) = [8, 3, 1229, 8508, 55, 165]; %%%%   NegIcon FAST ONLY   Something good, probably
neuronsAll(47,:) = [8, 4, 1229, 7867, 55, 165]; %%%%   NegIcon FAST ONLY Weak  % Motor 0 delay Reanalyze
neuronsAll(48,:) = [8, 5, 1229, 12816, 55, 165]; %%%%  PosAccel Iconic Weak  % Pos fast Bias Reanalyze
neuronsAll(49,:) = [8, 6, 1229, 18279, 55, 165]; %%%%  PosAccel Iconic Weak  % Pos fast Bias Reanalyze
neuronsAll(50,:) = [8, 7, 1229, 7954, 55, 165]; %%%%%  PosCent Sens   Pos Fast Motor Reanalyze

% fin_2019_04_14, 1019 (85 px EV 345 FA)
neuronsAll(51,:) = [9, 2, 1019, 12079, 85, 345]; % NR
neuronsAll(52,:) = [9, 3, 1019, 5172, 85, 345]; %%%%%%%PosIcon PosHi/PosHi
neuronsAll(53,:) = [9, 4, 1019, 31508, 85, 345]; %%%%%%PosIcon PosHi/PosHi

% goldy_2019_03_28, 599 (35 px EV 160 FA)
neuronsAll(54,:) = [10, 1, 599, 1412, 35, 160]; % 
neuronsAll(55,:) = [10, 2, 599, 7218, 35, 160]; % NR
neuronsAll(56,:) = [10, 3, 599, 562, 35, 160]; % TOO FEW SPIKES
neuronsAll(57,:) = [10, 4, 599, 2442, 35, 160]; % Slow
neuronsAll(58,:) = [10, 5, 599, 2357, 35, 160]; % NR
neuronsAll(59,:) = [10, 6, 599, 958, 35, 160]; % TOO FEW SPIKES
neuronsAll(60,:) = [10, 7, 599, 1536, 35, 160]; % 
neuronsAll(61,:) = [10, 8, 599, 5013, 35, 160]; %%%% PosSens   
neuronsAll(62,:) = [10, 9, 599, 1249, 35, 160]; % 

% hobo_2019_04_01, 1019 (45 px EV 150 FA)
neuronsAll(63,:) = [11, 1, 1019, 1432, 45, 150]; % 
neuronsAll(64,:) = [11, 2, 1019, 1617, 45, 150]; %%%%  NegSense
neuronsAll(65,:) = [11, 3, 1019, 503, 45, 150]; % TOO FEW SPIKES
neuronsAll(66,:) = [11, 5, 1019, 235, 45, 150]; % TOO FEW SPIKES

% penn_2019_04_13, 269 (65 px EV 165 FA)
neuronsAll(67,:) = [12, 1, 269, 4055, 65, 165]; % PosSlow/Pos/Slow
neuronsAll(68,:) = [12, 2, 269, 366, 65, 165]; % TOO FEW SPIKES
neuronsAll(69,:) = [12, 3, 269, 524, 65, 165]; % TOO FEW SPIKES

% tolstoy_2019_01_29, 569 (90 px EV 185 FA)
neuronsAll(70,:) = [13, 1, 569, 3666, 90, 185]; % NR*
neuronsAll(71,:) = [13, 2, 569, 28640, 90, 185]; % NR
neuronsAll(72,:) = [13, 3, 569, 13401, 90, 185]; % NR
neuronsAll(73,:) = [13, 4, 569, 11166, 90, 185]; % NR
neuronsAll(74,:) = [13, 5, 569, 13055, 90, 185]; % NR


%% Filter

% Minimum number of spikes for analysis: greater than total 2000 spikes 
    numIDX = find(neuronsAll(:,4) > 2000);
