function [ output_sig ] = MultiplySignals(sig1, sig2)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%assumes filter goes in sig2 spot
samples = max(length(sig1),length(sig2));
sig1(length(sig1)+1:samples) = 0;
sig2(length(sig2)+1:samples) = 1;
output_sig = sig1.*sig2;

end

