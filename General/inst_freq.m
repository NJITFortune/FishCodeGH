function [inst_f,tinst_f] = inst_freq(y,fs,zerocross)
% computes instantaneous frequency of input signal y based on sampling rate
% fs using threshold value "zerocross" (usually zero V)

y1 = y(1:end-1);
y2 = y(2:end);
zerocross_idx = find((y1<=zerocross) & (y2>zerocross));
amp_step = y(zerocross_idx+1)-y(zerocross_idx);   % amplitude step between samples just below and just above zero
amp_frac = (zerocross-y(zerocross_idx))./amp_step;    % fraction of amp. step that is below zero
y_frac = zerocross_idx + amp_frac;                % add fraction to time stamp just below zero crossing to get the "real" zero crossing

inst_f = 1./(diff(y_frac)/fs);      % instantanous frequency
tinst_f = cumsum(diff(y_frac)/fs)+y_frac(1)/fs;  % time points for plotting of inst. f.
