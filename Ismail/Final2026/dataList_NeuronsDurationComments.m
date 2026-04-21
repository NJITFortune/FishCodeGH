% Neuron listing for the duration analysis project.
% Source data file: ismailCompleteFinal2024.mat
%
% Each row of neuronsAll encodes one recorded neuron with the following columns:
%   Col 1 - Fish index (see fishNames lookup table below)
%   Col 2 - Neuron index within that fish
%   Col 3 - Recording duration (seconds)
%   Col 4 - Total spike count
%   Col 5 - Speed threshold for slow/fast split, escape velocity condition (px/s)
%   Col 6 - Speed threshold for slow/fast split, free active condition (px/s)
%
% The speed thresholds (cols 5-6) define a median split: spikes below the
% threshold are in the slow half, spikes above are in the fast half.
%
% Classification labels used in comments:
%   NR         - No significant response detected
%   PosCent    - Positive center response
%   PosIcon    - Positive iconic response
%   NegIcon    - Negative iconic response
%   PosSens    - Positive sensory response
%   NegSens    - Negative sensory response
%   PosAccel   - Positive acceleration response
%   PosHi/NegHi- High-speed bias for positive/negative direction
%   Excluded   - Neuron excluded from analysis (reason noted)

%% Load data (edit path as needed)
% load /Users/efortune/NotCloudy/ismailCompleteFinal2024.mat

%% Fish name lookup table
fishNames{1}  = 'Andre';
fishNames{2}  = 'Ankara';
fishNames{3}  = 'BammBamm';
fishNames{4}  = 'Bent';
fishNames{5}  = 'Brown';
fishNames{6}  = 'BrownieOne';
fishNames{7}  = 'BrownieTwo';
fishNames{8}  = 'Bumpy';
fishNames{9}  = 'Fin';
fishNames{10} = 'Goldy';
fishNames{11} = 'Hobo';
fishNames{12} = 'Penn';
fishNames{13} = 'Tolstoy';

%% Neuron data table
clear neuronsAll

% --- Andre (fish 1) | andre_2019_04_10 | duration: 1439 s | EV: 65 px/s, FA: 270 px/s ---
neuronsAll(1,:)  = [1, 1, 1439, 10270, 40, 100]; % NR
neuronsAll(2,:)  = [1, 2, 1439,  2236, 170, 0]; % NR
neuronsAll(3,:)  = [1, 3, 1439,  5557, 0, 0]; % NR
neuronsAll(4,:)  = [1, 4, 1439,  1605, 65, 270]; % NR % No data availble ~Smita
neuronsAll(5,:)  = [1, 5, 1439,  2857, 0, 195]; % NR
neuronsAll(6,:)  = [1, 6, 1439,   849, 65, 270]; % Excluded: too few spikes % No data available ~Smita

% --- Ankara (fish 2) | ankara_2019_01_31 | duration: 689 s | EV: 90 px/s, FA: 220 px/s ---
neuronsAll(7,:)  = [2, 1, 689,  6851, 0, 0]; % NR
neuronsAll(8,:)  = [2, 2, 689,  8355, 0, 0]; % NR
neuronsAll(9,:)  = [2, 3, 689,  1160, 90, 220]; % NR % No data available ~Smita
neuronsAll(10,:) = [2, 4, 689, 14515, 0, 0]; % NR
neuronsAll(11,:) = [2, 5, 689,  7346, 0, 0]; % NR
neuronsAll(12,:) = [2, 6, 689, 18630, 0, 0]; % NR
neuronsAll(13,:) = [2, 7, 689,   661, 90, 220]; % Excluded: too few spikes
neuronsAll(14,:) = [2, 8, 689,  5033, 0, 0]; % NR

% --- BammBamm (fish 3) | bammbamm_2019_04_12 | duration: 809 s | EV: 100 px/s, FA: 525 px/s ---
neuronsAll(15,:) = [3, 1, 809, 15627, 0, 180]; % PosCent   | PosHi/PosHi | more sensory | STA flat
neuronsAll(16,:) = [3, 2, 809,  9609, 60, 110]; % PosIcon   | PosHi/NR    | velocity      | STA flat
neuronsAll(17,:) = [3, 3, 809,  8538, 0, 180]; % PosCent   | PosHi/PosHi | more sensory | STA flat
neuronsAll(18,:) = [3, 4, 809, 11327, 0, 120]; % NegIcon   | NegHi/NegHi | more sensory | STA flat
neuronsAll(19,:) = [3, 5, 809, 10009, 40, 120]; % NegIcon   | NegHi/NegHi |               STA flat
neuronsAll(20,:) = [3, 6, 809,  6637, 60, 75]; % NegIcon   | NegHi/NegHi |               STA flat

% --- Bent (fish 4) | bent_2019_02_26 | duration: 1469 s | EV: 75 px/s, FA: 260 px/s ---
neuronsAll(21,:) = [4, 1, 1469, 28860, 0, 0]; % NR                          | STA flat
neuronsAll(22,:) = [4, 2, 1469, 30154, 200, 180]; % PosSens (weak) | WeakPosHi/WeakNegHi | STA flat
neuronsAll(23,:) = [4, 3, 1469,  9759, 80, 260]; % PosSens        | PosHi/NegHi         | STA flat
neuronsAll(24,:) = [4, 4, 1469,  4220, 140, 60]; % PosSens (weak) | PosHi/irregular     | STA flat
neuronsAll(25,:) = [4, 5, 1469, 27233, 0, 0]; % NR                          | STA flat
neuronsAll(26,:) = [4, 6, 1469,  7761, 90, 0]; % PosSens        | PosHi, possibly sensory/passive | STA flat

% --- Brown (fish 5) | brown_2018_09_25 | duration: 299 s | EV: 14 px/s, FA: 70 px/s ---
% Note: tracking data are scaled by a factor of 10 relative to other fish.
neuronsAll(27,:) = [5, 1, 299, 3600, 0, 0]; % NR
neuronsAll(28,:) = [5, 2, 299, 5271, 0, 0]; % NR
neuronsAll(29,:) = [5, 3, 299, 1444, 14, 70]; % No data available ~ Smita
neuronsAll(30,:) = [5, 4, 299, 1909, 14, 70]; % No data available ~ Smita
neuronsAll(31,:) = [5, 5, 299,  807, 14, 70]; % Excluded: too few spikes % No data available ~ Smita

% --- BrownieOne (fish 6) | brownie_p1_2019_01_26 | duration: 539 s | EV: 125 px/s, FA: 330 px/s ---
neuronsAll(32,:) = [6, 1, 539, 2777, 75, 0]; % NegSens        | sensory NegHi
neuronsAll(33,:) = [6, 2, 539, 3501, 0, 0]; % NR
neuronsAll(34,:) = [6, 3, 539, 2433, 0, 0]; % NR             | weakest sensory NegHi
neuronsAll(35,:) = [6, 4, 539, 4106, 0, 0]; % NR
neuronsAll(36,:) = [6, 5, 539, 2937, 95, 0]; % NegSens (weak)
neuronsAll(37,:) = [6, 6, 539, 1334, 125, 330]; % No data available ~ Smita
neuronsAll(38,:) = [6, 7, 539, 2597, 190, 0]; % NR             | weak sensory NegHi
neuronsAll(39,:) = [6, 8, 539,  516, 125, 330]; % Excluded: too few spikes % No data available ~ Smita

% --- BrownieTwo (fish 7) | brownie_p2_2019_01_26 | duration: 389 s | EV: 100 px/s, FA: 360 px/s ---
neuronsAll(40,:) = [7, 1, 389, 3847, 0, 140]; % PosCent | STA flat
neuronsAll(41,:) = [7, 2, 389, 1055, 100, 360]; % Messy
neuronsAll(42,:) = [7, 3, 389,  277, 100, 360]; % Excluded: too few spikes
neuronsAll(43,:) = [7, 4, 389, 1072, 100, 360]; % NR

% --- Bumpy (fish 8) | bumpy_2019_04_03 | duration: 1229 s | EV: 55 px/s, FA: 165 px/s ---
neuronsAll(44,:) = [8, 1, 1229, 24303, 0, 0]; % NR (late response)           | STA flat
neuronsAll(45,:) = [8, 2, 1229, 10599, 0, 0]; % Messy                         | STA flat
neuronsAll(46,:) = [8, 3, 1229,  8508, 95, 80]; % NegIcon (fast only)           | NegNeg | barbell pattern | STA flat
neuronsAll(47,:) = [8, 4, 1229,  7867,110, 0]; % NegIcon (fast only, weak)     | NegNeg | barbell pattern | motor, ~0 delay | STA flat
neuronsAll(48,:) = [8, 5, 1229, 12816, 0, 90]; % PosAccel (iconic, weak)       | positive fast bias | STA flat
neuronsAll(49,:) = [8, 6, 1229, 18279, 0, 90]; % PosAccel (iconic, weak)       | PosPos | barbell pattern | positive fast bias | STA flat
neuronsAll(50,:) = [8, 7, 1229,  7954, 0, 0]; % PosCent (sensory)             | positive fast motor | STA flat

% --- Fin (fish 9) | fin_2019_04_14 | duration: 1019 s | EV: 85 px/s, FA: 345 px/s ---
neuronsAll(51,:) = [9, 2, 1019, 12079, 85, 345]; % NR
neuronsAll(52,:) = [9, 3, 1019,  5172, 120, 100]; % PosIcon | PosHi/PosHi
neuronsAll(53,:) = [9, 4, 1019, 31508, 120, 90]; % PosIcon | PosHi/PosHi

% --- Goldy (fish 10) | goldy_2019_03_28 | duration: 599 s | EV: 35 px/s, FA: 160 px/s ---
neuronsAll(54,:) = [10, 1, 599, 1412, 35, 160]; %
neuronsAll(55,:) = [10, 2, 599, 7218, 300, 200]; % NR
neuronsAll(56,:) = [10, 3, 599,  562, 35, 160]; % Excluded: too few spikes
neuronsAll(57,:) = [10, 4, 599, 2442, 100, 100]; % Slow
neuronsAll(58,:) = [10, 5, 599, 2357, 0, 0]; % NR
neuronsAll(59,:) = [10, 6, 599,  958, 35, 160]; % Excluded: too few spikes
neuronsAll(60,:) = [10, 7, 599, 1536, 35, 160]; %
neuronsAll(61,:) = [10, 8, 599, 5013, 250, 375]; % PosSens | STA flat
neuronsAll(62,:) = [10, 9, 599, 1249, 35, 160]; %

% --- Hobo (fish 11) | hobo_2019_04_01 | duration: 1019 s | EV: 45 px/s, FA: 150 px/s ---
neuronsAll(63,:) = [11, 1, 1019, 1432, 45, 150]; %
neuronsAll(64,:) = [11, 2, 1019, 1617, 45, 150]; % NegSens
neuronsAll(65,:) = [11, 3, 1019,  503, 45, 150]; % Excluded: too few spikes
neuronsAll(66,:) = [11, 5, 1019,  235, 45, 150]; % Excluded: too few spikes

% --- Penn (fish 12) | penn_2019_04_13 | duration: 269 s | EV: 65 px/s, FA: 165 px/s ---
neuronsAll(67,:) = [12, 1, 269, 4055, 0, 80]; % PosSlow/Pos/Slow | STA flat
neuronsAll(68,:) = [12, 2, 269,  366, 65, 165]; % Excluded: too few spikes
neuronsAll(69,:) = [12, 3, 269,  524, 65, 165]; % Excluded: too few spikes

% --- Tolstoy (fish 13) | tolstoy_2019_01_29 | duration: 569 s | EV: 90 px/s, FA: 185 px/s ---
neuronsAll(70,:) = [13, 1, 569,  3666, 0, 0]; % NR
neuronsAll(71,:) = [13, 2, 569, 28640, 0, 0]; % NR
neuronsAll(72,:) = [13, 3, 569, 13401, 0, 0]; % NR
neuronsAll(73,:) = [13, 4, 569, 11166, 0, 0]; % NR
neuronsAll(74,:) = [13, 5, 569, 13055, 0, 0]; % NR

%% Filter: retain only neurons with sufficient spike counts for analysis
% Minimum threshold: > 2000 total spikes
numIDX = find(neuronsAll(:,4) > 2000);
