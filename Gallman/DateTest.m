iFile = uigetfile('*.avi');

% iFiler = dir(iFile);
% 
% iFiler.datenum

%function modTime = GetFileTime(iFile.name)

listing = dir(iFile);
% check we got a single entry corresponding to the file
assert(numel(listing) == 1, 'No such file: %s', iFile.name);
modTime = listing.datenum;

modTime