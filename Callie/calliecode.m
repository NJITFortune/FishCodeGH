function [out, foo] = calliecode(in)

Fs = 500;
cmp = parula(30);

%% Get centroid for every frame

for kk = 1:length(in) % For each frame (you gave me 2500 frames)
    
    % Get the centroid of ALL points.
    % If you wanted to get the centroid of a subset of points, use
    % something like:     
    
    for j=2:3:86 % This is for each feature you tracked
        idx = (j+1)/3; % Making for a convenient indexing
        dat(idx,:) = [in(kk,j), in(kk,j+1)]; % Get the X and Y points for each feature
    end
    
        convx = convhull(dat(:,1),dat(:,2)); % Get the convex hull (only border of the object)
        poly = polyshape(dat(convx,:)); % Change the data into a Matlab object known as a polyshape for use with 'centroid'
        [out.xC(kk),out.yC(kk)] = centroid(poly); % centroid calculates the centroid X and Y values
        
        % Copy some useful points for fun
        out.xT(kk) = in(kk,62); % Trunk
        out.yT(kk) = in(kk,63);
        out.xR(kk) = in(kk,2); % Rostrum
        out.yR(kk) = in(kk,3);
        out.xP(kk) = in(kk,68); % Pelvius
        out.yP(kk) = in(kk,69); 
end

% Plot for amusement purposes only
figure(1); clf; hold on;

    plot(out.xC, out.yC, '.k', 'MarkerSize', 8);
    plot(out.xT, out.yT, '.b', 'MarkerSize', 8);
    plot(out.xR, out.yR, '.m', 'MarkerSize', 8);
    plot(out.xP, out.yP, '.g', 'MarkerSize', 8);

%% Calculate the angle of movement for each frame

    % This gives the angle for each frame
    out.Crad = atan2(out.yC, out.xC); % Centroid
    out.Trad = atan2(out.yT, out.xT); % Trunk
    out.Rrad = atan2(out.yR, out.xR); % Rostrum
    out.Prad = atan2(out.yP, out.xP); % Pelvis
    
    % out.rad = unwrap(out.rad); % You may need to "unwrap" the data depending on the angle of the fish in the video

% Plotting is fun!  
figure(2); clf; hold on;
    plot(out.Crad, 'k');
    plot(out.Trad, 'b');
    plot(out.Rrad, 'm');
    plot(out.Prad, 'g');


       
    
%% Filter the angle change to smooth things out

cutoffFreq = 2;

    [b,a] = butter(3, cutoffFreq/(Fs/2), 'low');
    out.fCrad = filtfilt(b,a,out.Crad);
    
figure(2); hold on; plot(out.fCrad, 'c');    

%% Move the fish to the center

for kk = 1:length(in) % For each frame (you gave me 2500 frames)
    
    % Get the centroid of ALL points.
    % If you wanted to get the centroid of a subset of points, use
    % something like:     
    
    for j=2:3:86 % This is for each feature you tracked
        idx = (j+1)/3; % Making for a convenient indexing
        foo(kk).dat(idx,:) = [in(kk,j) - out.xT(kk), in(kk,j+1) - out.yT(kk)]; % Get the X and Y points for each feature        
    end
    
end

%% Rotate the fish for each frame

for kk = 1:length(out.fCrad)
    
        for j=2:3:86 % This is for each feature you tracked
            idx = (j+1)/3; % Making for a convenient indexing
            dat(idx,:) = [in(kk,j), in(kk,j+1)]; % Get the X and Y points for each feature
        end
        
    foo(kk).centroidrotate = rotatorcuff(dat, [out.xT(kk), out.yT(kk)], out.fCrad(kk)-(pi-out.fCrad(kk))); % Rotation around centroid 

end

for kk = 500:10:1600
    
   figure(3); clf; 
        subplot(121); hold on;  
        for j=1:29
            plot(foo(kk).dat(j,1), foo(kk).dat(j,2), '.', 'MarkerSize', 16, 'Color', cmp(j,:)); 
        end
        plot(0, 0, 'k.', 'MarkerSize', 16);
        axis([-200, 200, -200, 200]);

        subplot(122); hold on;
        plot(foo(kk).centroidrotate(:,1), foo(kk).centroidrotate(:,2), 'b.', 'MarkerSize', 16); 
        plot(out.xT(kk), out.yT(kk), 'k.', 'MarkerSize', 16);
        axis([out.xT(kk)-200, out.xT(kk)+200, out.yT(kk)-200, out.yT(kk)+200]);
        
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

