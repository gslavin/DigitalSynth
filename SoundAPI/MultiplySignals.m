% Allows two signals to be multiplied together.
% If the signals are of different lengths:
%   the first signal is padded with 1s
%   the second signal is padded with 0s
function [ output_sig ] = MultiplySignals(sig1, sig2)
%assumes filter goes in sig2 spot
samples = max(length(sig1),length(sig2));
sig1(length(sig1)+1:samples) = 0;
sig2(length(sig2)+1:samples) = 1;
output_sig = sig1.*sig2;

end

