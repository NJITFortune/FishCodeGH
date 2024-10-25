% Sample signal (replace with your actual signal)
signal = curfish(9).error_vel; % Random signal with both positive and negative values

% Get the initial number of positive and negative values
num_pos = sum(signal > 0);
num_neg = sum(signal < 0);

% Define a small constant to adjust the signal
adjustment_constant = 0.01; 

% Adjust the signal until the number of positives and negatives are equal
while abs(num_pos - num_neg) > 5
    fprintf('Num Pos = %i \n', num_pos)
    if num_pos > num_neg
        % If more positives, subtract a constant to reduce the number of positives
        signal = signal - adjustment_constant;
    elseif num_neg > num_pos
        % If more negatives, add a constant to reduce the number of negatives
        signal = signal + adjustment_constant;
    end
    % Recalculate the number of positive and negative values
    num_pos = sum(signal > 0);
    num_neg = sum(signal < 0);
end

% Plot the adjusted signal
figure;
plot(signal);
title('Adjusted Signal with Equal Positive and Negative Values');

% Display the final count of positive and negative values
fprintf('Number of positive values: %d\n', num_pos);
fprintf('Number of negative values: %d\n', num_neg);
