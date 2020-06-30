function [out, foo] = calliecode(in)

Fs = 500; % This is the sample rate you used
cmp = jet(30); % This is a colormap in Matlab... 30 different colors
tim = 1/Fs:1/Fs:length(in)/Fs;

% side is 'c' center, 'r' right, 'l' left
% part is 'tr' trunk, 'fl' forelimb, 'hl' hindlimb, 'ta' tail, 'he' head

out.pointname{1} = 'Rostrum'; out.side(1) = 'c'; out.part{1} = 'he';
out.pointname{2} = 'MedRosForelimb'; out.side(2) = 'l'; out.part{2} = 'fl'; 
out.pointname{3} = 'MidRosForelimb'; out.side(3) = 'l'; out.part{3} = 'fl'; 
out.pointname{4} = 'DistalForelimb'; out.side(4) = 'l'; out.part{4} = 'fl';
out.pointname{5} = 'CaudalForelimb'; out.side(5) = 'l'; out.part{5} = 'fl';


%% STEP 1: Get centroid for every frame 


for kk = 1:length(in) % For each frame (there were 2500 frames)
    
% Extract all of the 29 points from the CSV file and put into structure 'foo'

    for j=2:3:86 % This is for each feature you tracked (there are three columns: x,y,confidence. 
        idx = (j+1)/3; % Make for convenient indexing. This starts and 1 and goes up by one for each tracked point.                
        
        foo(kk).orig(idx,:) = [in(kk,j), in(kk,j+1)]; % Get the X and Y points for each feature        
        
    end
    
% Compute the centroid of all of the points
    
        convx = convhull(foo(kk).orig(:,1),foo(kk).orig(:,2)); % Get the convex hull (only border of the object)
        poly = polyshape(foo(kk).orig(convx,:)); % Change the data into a Matlab object known as a polyshape for use with 'centroid'
        [out.xC(kk), out.yC(kk)] = centroid(poly); % centroid calculates the centroid X and Y values
        foo(kk).Centroid = centroid(poly);
        
        % Copy some useful points for fun (alternatives to the centroid for the center of your body rotation.
        out.xT(kk) = in(kk,62); % Trunk idx = 21
        out.yT(kk) = in(kk,63); 
        out.xR(kk) = in(kk,2); % Rostrum idx = 1
        out.yR(kk) = in(kk,3);
        out.xP(kk) = in(kk,68); % Pelvis idx = 23 (in foo.orig - 'foo(kk).orig(23,:)' )
        out.yP(kk) = in(kk,69); 
        
end

% Plot the trajectories of the points that I chose, for amusement purposes only
figure(1); clf; 

    subplot(121); hold on; % Plotting using 'out'

    plot(out.xC, out.yC, '.k', 'MarkerSize', 16); % Centroid
    plot(out.xT, out.yT, '.b', 'MarkerSize', 8); % Trunk
    plot(out.xR, out.yR, '.m', 'MarkerSize', 8); % Rostrum
    plot(out.xP, out.yP, '.g', 'MarkerSize', 8); % Pelvis

    subplot(122); hold on; % Plotting same thing, but using foo

    plot(foo.Centroid(:,1), foo.Centroid(:,2), '.k', 'MarkerSize', 16);
    
%% STEP 2: Calculate the angle of movement and distance (speed) for each frame

% This gives the angle of movement for each point listed below for each frame
    out.Crad = atan2(out.yC, out.xC); % Centroid
    out.Trad = atan2(out.yT, out.xT); % Trunk
    out.Rrad = atan2(out.yR, out.xR); % Rostrum
    out.Prad = atan2(out.yP, out.xP); % Pelvis
    
    % out.rad = unwrap(out.rad); % You may need to "unwrap" the data depending on the angle of the fish in the video
        
% Plotting is fun!  
figure(2); clf; hold on;
    plot(tim, out.Crad, 'k'); % Centroid
    plot(tim, out.Trad, 'b'); % Trunk
    plot(tim, out.Rrad, 'm'); % Rostrum
    plot(tim, out.Prad, 'g'); % Pelvis
    
    
%% STEP 3: Filter the angle change to smooth things out

% Pick your angle data
    ang = out.Crad; XX = out.xC; YY = out.yC;
    % ang = out.Trad; XX = out.xT; YY = out.yT; % As an example other choice

cutoffFreq = 2; % This is the cutoff frequency of the filter in Hz
ord = 3; % This is the 'order' of the filter

    [b,a] = butter(ord, cutoffFreq/(Fs/2), 'low'); 
    out.filteredAngle = filtfilt(b,a,ang);
    
figure(2); hold on; plot(tim, out.filteredAngle, 'c', 'LineWidth', 2);    


%% STEP 4: Rotate the fish for each frame

for kk = 1:length(out.filteredAngle) % For each frame
    % Rotate to face towards top of plot for this case: angle - (pi-angle)
foo(kk).centroidrotate = rotatorcuff(foo(kk).orig, [XX(kk), YY(kk)], unwrap(out.filteredAngle(kk)-(pi-out.filteredAngle(kk)))); % Rotation around centroid 

end


%% AND FINALLY, ANIMATE A PLOT
for kk = 500:10:1700
    
   figure(3); clf; 
        subplot(121); hold on;  
        for j=1:29
            plot(foo(kk).orig(j,1)-out.xC(kk), foo(kk).orig(j,2)-out.yC(kk), '.', 'MarkerSize', 16, 'Color', cmp(j,:)); 
        end
        
        % Plot the trajectory
            plot(out.xC(kk-400:20:kk+400)-out.xC(kk), out.yC(kk-400:20:kk+400)-out.yC(kk), 'k-', 'LineWidth', 0.5);
        
        plot(0,0, 'k.', 'MarkerSize', 32);
        plot([-100, 100], [0, 0], 'k-', 'LineWidth', 0.5);
        plot([0, 0], [-100, 100], 'k-', 'LineWidth', 0.5);
        axis([-200, 200, -200, 200]);

        subplot(122); hold on;
        for j=1:29
            plot(foo(kk).centroidrotate(j,1), foo(kk).centroidrotate(j,2), '.', 'MarkerSize', 16, 'Color', cmp(j,:)); 
        end
                
        plot(out.xC(kk), out.yC(kk), 'k.', 'MarkerSize', 32);
        plot([out.xC(kk)-100, out.xC(kk)+100], [out.yC(kk), out.yC(kk)], 'k-', 'LineWidth', 0.5);
        plot([out.xC(kk), out.xC(kk)], [out.yC(kk)-100, out.yC(kk)+100], 'k-', 'LineWidth', 0.5);
        axis([out.xC(kk)-200, out.xC(kk)+200, out.yC(kk)-200, out.yC(kk)+200]);
        
   drawnow;
   pause(0.01);
    
end


function rot = rotatorcuff(data, cent, degR)
% data is the x,y values
% cent is the rotation center [x,y]
% degR is the rotation angle in radians

    centermatrix = repmat([cent(1); cent(2)], 1, length(data(:,1))); % Make a matrix for the center of rotation

    R = [cos(degR) -sin(degR); sin(degR) cos(degR)]; % Create rotation matrix
    
    rot = (R * (data' - centermatrix)) + centermatrix; % Rotate points
    rot = rot'; % Because I am lousy at coding

end

end

