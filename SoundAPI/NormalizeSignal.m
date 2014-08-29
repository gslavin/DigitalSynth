% Normalizes the signals so the max value is 1 
function [ output_sig ] = NormalizeSignal( sig )
output_sig = sig./max(abs(sig));
end

