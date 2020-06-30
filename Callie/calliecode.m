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
    
% % % % Compute the centroid of all of the points
% % %     
% % %         convx = convhull(byFrame(kk).orig(:,1),byFrame(kk).orig(:,2)); % Get the convex hull (only border of the object)
% % %         
% % %         poly = polyshape(byFrame(kk).orig(convx,:)); % Change the data into a Matlab object known as a polyshape for use with 'centroid'
% % %         
% % %         [byFrame(kk).Centroid(1), byFrame(kk).Centroid(2)] = centroid(poly);
% % %         [byPart.CentroidX(kk), byPart.CentroidY(kk)] = centroid(poly); % centroid calculates the centroid X and Y values
                
end

%% STEP 2: Generate the byPart structure 

for j=2:3:86 % This is for each feature you tracked (there are three columns: x,y,confidence. 
    idx = (j+1)/3; % Make for convenient indexing. This starts and 1 and goes up by one for each tracked point.                
        
        byPart.X(idx,:) = in(:,j); % Get the X points for the feature        
        byPart.Y(idx,:) = in(:,j+1); % Get the Y points for the feature        
        
end



% Plot the trajectories of the points that I chose, for amusement purposes only
figure(1); clf; 

    subplot(121); hold on; % Plotting using 'byPart'

    plot(byPart.X(21,:), byPart.Y(21,:), '.b', 'MarkerSize', 8); % Trunk
    plot(byPart.X(1,:), byPart.Y(1,:), '.m', 'MarkerSize', 8); % Rostrum
    plot(byPart.X(23,:), byPart.Y(23,:), '.g', 'MarkerSize', 8); % Pelvis
    
    subplot(122); hold on; % Plotting same thing, but using foo

    for jj=1:length(byFrame)
       plot(byFrame(jj).orig(21,1), byFrame(jj).orig(21,2), '.b', 'MarkerSize', 8);
       plot(byFrame(jj).orig(23,1), byFrame(jj).orig(23,2), '.g', 'MarkerSize', 8);
       plot(byFrame(jj).orig(1,1), byFrame(jj).orig(1,2), '.m', 'MarkerSize', 8);
    end
    
    
%% STEP 2: Calculate the angle of movement and distance (speed) for each frame

% This gives the angle of movement for each point listed below for each
% frame using OUT
 for zz = 29:-1:1
    byPart.R(zz,:) = atan2(byPart.Y(zz,:), byPart.X(zz,:)); % Trunk
 end
 
    % out.rad = unwrap(out.rad); % You may need to "unwrap" the data depending on the angle of the fish in the video
        
% Plotting is fun!  
figure(2); clf; hold on;
    plot(tim, byPart.R(21,:), 'b'); % Trunk
    plot(tim, byPart.R(1,:), 'm'); % Rostrum
    plot(tim, byPart.R(23,:), 'g'); % Pelvis
    

    
    
%% STEP 3: Filter the angle change to smooth things out

% Pick your angle data
    ang = byPart.R(21,:); XX = byPart.X(21,:); YY = byPart.Y(21,:);
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

%% PROBABLY WORKS TO HERE

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

