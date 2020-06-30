function [out, foo] = calliecode(in)

Fs = 500; % This is the sample rate you used
cmp = jet(30); % This is a colormap in Matlab... 30 different colors


%% STEP 1: Get centroid for every frame 

for kk = 1:length(in) % For each frame (there were 2500 frames)
    
    % Get the centroid of ALL points. (If you wanted to get the centroid of a subset of points, you could set up a list)  
    
    for j=2:3:86 % This is for each feature you tracked (there are three columns: x,y,confidence. 
        idx = (j+1)/3; % Make for convenient indexing. This starts and 1 and goes up by one for each tracked point                
        
        foo(kk).orig(idx,:) = [in(kk,j), in(kk,j+1)]; % Get the X and Y points for each feature        

    end
    
        convx = convhull(foo(kk).orig(:,1),foo(kk).orig(:,2)); % Get the convex hull (only border of the object)
        poly = polyshape(foo(kk).orig(convx,:)); % Change the data into a Matlab object known as a polyshape for use with 'centroid'
        [out.xC(kk),out.yC(kk)] = centroid(poly); % centroid calculates the centroid X and Y values
        
        % Copy some useful points for fun (alternatives to the centroid for the center of your body rotation.
        out.xT(kk) = in(kk,62); % Trunk
        out.yT(kk) = in(kk,63);
        out.xR(kk) = in(kk,2); % Rostrum
        out.yR(kk) = in(kk,3);
        out.xP(kk) = in(kk,68); % Pelvis
        out.yP(kk) = in(kk,69); 
        
end

% Plot the trajectories of the points that I chose, for amusement purposes only
figure(1); clf; hold on;

    plot(out.xC, out.yC, '.k', 'MarkerSize', 16); % Centroid
    plot(out.xT, out.yT, '.b', 'MarkerSize', 8); % Trunk
    plot(out.xR, out.yR, '.m', 'MarkerSize', 8); % Rostrum
    plot(out.xP, out.yP, '.g', 'MarkerSize', 8); % Pelvis

%% STEP 2: Calculate the angle of movement and distance (speed) for each frame

% This gives the angle of movement for each point listed below for each frame
    out.Crad = atan2(out.yC, out.xC); % Centroid
    out.Trad = atan2(out.yT, out.xT); % Trunk
    out.Rrad = atan2(out.yR, out.xR); % Rostrum
    out.Prad = atan2(out.yP, out.xP); % Pelvis
    
    % out.rad = unwrap(out.rad); % You may need to "unwrap" the data depending on the angle of the fish in the video
        
% Plotting is fun!  
figure(2); clf; hold on;
    plot(out.Crad, 'k'); % Centroid
    plot(out.Trad, 'b'); % Trunk
    plot(out.Rrad, 'm'); % Rostrum
    plot(out.Prad, 'g'); % Pelvis
    
       
    
%% STEP 3: Filter the angle change to smooth things out

cutoffFreq = 2; % This is the cutoff frequency of the filter in Hz
ord = 3; % This is the 'order' of the filter

    [b,a] = butter(ord, cutoffFreq/(Fs/2), 'low'); 
    out.fCrad = filtfilt(b,a,out.Crad);
    
figure(2); hold on; plot(out.fCrad, 'c');    

%% STEP 4: Perhaps you might want to move the fish to the 'origin'

for kk = 1:length(in) % For each frame (you gave me 2500 frames)    
    
% This is a repeat of what was done above, but now put into two Matlab 'structures' 
% foo has the data centered around the origin, out has the original data.
    for j=2:3:86 % This is for each feature you tracked
        idx = (j+1)/3; % Making for a convenient indexing
    end
    
end

%% Rotate the fish for each frame

for kk = 1:length(out.fCrad) % For each frame
    
    foo(kk).centroidrotate = rotatorcuff(foo(kk).orig, [out.xC(kk), out.yC(kk)], out.fCrad(kk)-(pi-out.fCrad(kk))); % Rotation around centroid 

end

for kk = 400:10:1700
    
   figure(3); clf; 
        subplot(121); hold on;  
        for j=1:29
            plot(foo(kk).orig(j,1)-out.xT(kk), foo(kk).orig(j,2)-out.yT(kk), '.', 'MarkerSize', 16, 'Color', cmp(j,:)); 
        end
        plot(0,0, 'k.', 'MarkerSize', 32);
        plot([-100, 100], [0, 0], 'k-', 'LineWidth', 0.5);
        plot([0, 0], [-100, 100], 'k-', 'LineWidth', 0.5);
        axis([-200, 200, -200, 200]);

        subplot(122); hold on;
        for j=1:29
            plot(foo(kk).centroidrotate(j,1), foo(kk).centroidrotate(j,2), '.', 'MarkerSize', 16, 'Color', cmp(j,:)); 
        end
        
        % Plot the trajectory
            plot(out.xC(kk-100:kk+100), out.yC(kk-100:kk+100), 'k-', 'LineWidth', 0.5);
        
        plot(out.xC(kk), out.yC(kk), 'k.', 'MarkerSize', 32);
        plot([out.xC(kk)-100, out.xC(kk)+100], [out.yC(kk), out.yC(kk)], 'k-', 'LineWidth', 0.5);
        plot([out.xC(kk), out.xC(kk)], [out.yC(kk)-100, out.yC(kk)+100], 'k-', 'LineWidth', 0.5);
        axis([out.xC(kk)-200, out.xC(kk)+200, out.yC(kk)-200, out.yC(kk)+200]);
        
   drawnow;
   pause(0.1);
    
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

