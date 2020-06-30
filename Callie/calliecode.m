function [byPart, byFrame] = calliecode(in)

Fs = 500; % This is the sample rate you used
cmp = jet(30); % This is a colormap in Matlab... 30 different colors
tim = 1/Fs:1/Fs:length(in)/Fs;

% side is 'c' center, 'r' right, 'l' left
% part is 'tr' trunk, 'fl' forelimb, 'hl' hindlimb, 'ta' tail, 'he' head

% byPart.pointname{1} = 'Rostrum'; byPart.side(1) = 'c'; byPart.part{1} = 'he';
% byPart.pointname{2} = 'MedRosForelimb'; byPart.side(2) = 'l'; byPart.part{2} = 'fl'; 
% byPart.pointname{3} = 'MidRosForelimb'; byPart.side(3) = 'l'; byPart.part{3} = 'fl'; 
% byPart.pointname{4} = 'DistalForelimb'; byPart.side(4) = 'l'; byPart.part{4} = 'fl';
% byPart.pointname{5} = 'CaudalForelimb'; byPart.side(5) = 'l'; byPart.part{5} = 'fl';


%% STEP 1: Generate the byFrame structure 

for kk = length(in):-1:1 % For each frame (there were 2500 frames)
    
% Extract all of the 29 points from the CSV file and put into structure 'foo'

    for j=2:3:86 % This is for each feature you tracked (there are three columns: x,y,confidence. 
        idx = (j+1)/3; % Make for convenient indexing. This starts and 1 and goes up by one for each tracked point.                
        
        byFrame(kk).orig(idx,:) = [in(kk,j), in(kk,j+1)]; % Get the X and Y points for each feature        
        
    end
    
% Compute the centroid of all of the points
    
        convx = convhull(byFrame(kk).orig(:,1),byFrame(kk).orig(:,2)); % Get the convex hull (only border of the object)
        
        poly = polyshape(byFrame(kk).orig(convx,:)); % Change the data into a Matlab object known as a polyshape for use with 'centroid'
        [sdfg, asdf] = centroid(poly);
        
        [byFrame(kk).Centroid(1), byFrame(kk).Centroid(2)] = centroid(poly);
        [byPart.CentroidX(kk), byPart.CentroidY(kk)] = centroid(poly); % centroid calculates the centroid X and Y values
        
        % Copy some useful points for fun (alternatives to the centroid for the center of your body rotation.
        byPart.xT(kk) = in(kk,62); % Trunk idx = 21
        byPart.yT(kk) = in(kk,63); 
        byPart.xR(kk) = in(kk,2); % Rostrum idx = 1
        byPart.yR(kk) = in(kk,3);
        byPart.xP(kk) = in(kk,68); % Pelvis idx = 23 (in foo.orig - 'foo(kk).orig(23,:)' )
        byPart.yP(kk) = in(kk,69); 
        
end

%% STEP 2: Generate the byPart structure 

for j=2:3:86 % This is for each feature you tracked (there are three columns: x,y,confidence. 
    idx = (j+1)/3; % Make for convenient indexing. This starts and 1 and goes up by one for each tracked point.                
        
        byPart.X(idx,:) = in(:,j); % Get the X points for the feature        
        byPart.Y(idx,:) = in(:,j+1); % Get the Y points for the feature        
        
end



% Plot the trajectories of the points that I chose, for amusement purposes only
figure(1); clf; 

    subplot(121); hold on; % Plotting using 'out'

%    plot(byPart.xC, byPart.yC, '.k', 'MarkerSize', 16); % Centroid
    plot(byPart.xT, byPart.yT, '.b', 'MarkerSize', 8); % Trunk
    plot(byPart.xR, byPart.yR, '.m', 'MarkerSize', 8); % Rostrum
    plot(byPart.xP, byPart.yP, '.g', 'MarkerSize', 8); % Pelvis

    subplot(122); hold on; % Plotting same thing, but using foo

    for jj=1:length(byFrame)
       plot(byFrame(jj).Centroid(1), byFrame(jj).Centroid(2), '.k', 'MarkerSize', 16);        
       plot(byFrame(jj).orig(21,1), byFrame(jj).orig(21,2), '.b', 'MarkerSize', 8);
       plot(byFrame(jj).orig(23,1), byFrame(jj).orig(23,2), '.g', 'MarkerSize', 8);
       plot(byFrame(jj).orig(1,1), byFrame(jj).orig(1,2), '.m', 'MarkerSize', 8);
    end
    
    
%% STEP 2: Calculate the angle of movement and distance (speed) for each frame

% This gives the angle of movement for each point listed below for each
% frame using OUT
    byPart.Crad = atan2(byPart.yC, byPart.xC); % Centroid
    byPart.Trad = atan2(byPart.yT, byPart.xT); % Trunk
    byPart.Rrad = atan2(byPart.yR, byPart.xR); % Rostrum
    byPart.Prad = atan2(byPart.yP, byPart.xP); % Pelvis
    
% This gives the angle of movement for each point listed below for each
% frame using FOO
    for jj=length(byFrame):-1:1
            centroid(jj,1) = byFrame(jj).Centroid(1); centroid(jj,2) = byFrame(jj).Centroid(2); 
    end
    
    % out.rad = unwrap(out.rad); % You may need to "unwrap" the data depending on the angle of the fish in the video
        
% Plotting is fun!  
figure(2); clf; hold on;
    plot(tim, byPart.Crad, 'k'); % Centroid
    plot(tim, byPart.Trad, 'b'); % Trunk
    plot(tim, byPart.Rrad, 'm'); % Rostrum
    plot(tim, byPart.Prad, 'g'); % Pelvis
    
    
%% STEP 3: Filter the angle change to smooth things out

% Pick your angle data
    ang = byPart.Crad; XX = byPart.xC; YY = byPart.yC;
    % ang = out.Trad; XX = out.xT; YY = out.yT; % As an example other choice

cutoffFreq = 2; % This is the cutoff frequency of the filter in Hz
ord = 3; % This is the 'order' of the filter

    [b,a] = butter(ord, cutoffFreq/(Fs/2), 'low'); 
    byPart.filteredAngle = filtfilt(b,a,ang);
    
figure(2); hold on; plot(tim, byPart.filteredAngle, 'c', 'LineWidth', 2);    


%% STEP 4: Rotate the fish for each frame

for kk = 1:length(byPart.filteredAngle) % For each frame
    % Rotate to face towards top of plot for this case: angle - (pi-angle)
byFrame(kk).centroidrotate = rotatorcuff(byFrame(kk).orig, [XX(kk), YY(kk)], unwrap(byPart.filteredAngle(kk)-(pi-byPart.filteredAngle(kk)))); % Rotation around centroid 

end


%% AND FINALLY, ANIMATE A PLOT
% for kk = 500:10:1700
%     
%    figure(3); clf; 
%         subplot(121); hold on;  
%         for j=1:29
%             plot(foo(kk).orig(j,1)-out.xC(kk), foo(kk).orig(j,2)-out.yC(kk), '.', 'MarkerSize', 16, 'Color', cmp(j,:)); 
%         end
%         
%         % Plot the trajectory
%             plot(out.xC(kk-400:20:kk+400)-out.xC(kk), out.yC(kk-400:20:kk+400)-out.yC(kk), 'k-', 'LineWidth', 0.5);
%         
%         plot(0,0, 'k.', 'MarkerSize', 32);
%         plot([-100, 100], [0, 0], 'k-', 'LineWidth', 0.5);
%         plot([0, 0], [-100, 100], 'k-', 'LineWidth', 0.5);
%         axis([-200, 200, -200, 200]);
% 
%         subplot(122); hold on;
%         for j=1:29
%             plot(foo(kk).centroidrotate(j,1), foo(kk).centroidrotate(j,2), '.', 'MarkerSize', 16, 'Color', cmp(j,:)); 
%         end
%                 
%         plot(out.xC(kk), out.yC(kk), 'k.', 'MarkerSize', 32);
%         plot([out.xC(kk)-100, out.xC(kk)+100], [out.yC(kk), out.yC(kk)], 'k-', 'LineWidth', 0.5);
%         plot([out.xC(kk), out.xC(kk)], [out.yC(kk)-100, out.yC(kk)+100], 'k-', 'LineWidth', 0.5);
%         axis([out.xC(kk)-200, out.xC(kk)+200, out.yC(kk)-200, out.yC(kk)+200]);
%         
%    drawnow;
%    pause(0.01);
%     
% end


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

