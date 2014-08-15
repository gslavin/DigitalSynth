function [ output_sig ] = FadeSignal(sig, amount)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
samples = length(sig);
fade = 1:-((1-amount)/samples):amount;

output_sig = MultiplySignals(sig, fade);
end

