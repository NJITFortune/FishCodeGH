function out = u_signalprep(positionData)
% This converts from pixels to cm.

% Two constants: Fs and scaling.
% Fs is 25 Hz
% position scaling is 48 pixels per cm

scal = 48;
Fs = 25;

out.pos = positionData / scal;

out.vel = diff(out.pos) / (1/Fs);
    out.vel(end+1) = out.vel(end); % Keep everything the same length

out.acc = diff(out.vel) / (1/Fs);
    out.acc(end+1) = out.acc(end); % Keep everything the same length

