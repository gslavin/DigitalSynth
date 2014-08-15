function [ output_sig ] = NormalizeSignal( sig )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
output_sig = sig./max(abs(sig));
end

