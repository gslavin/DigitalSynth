function [ output_sig ] = FadeReturnSignal(sig, amount, position, finalAmp)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

samples = length(sig);
fadeOutSamples = samples*(1-position);
fadeInSamples = samples*(position);
fadeOut = 1:-((1-amount)/fadeInSamples):amount;
fadeIn = amount:((finalAmp-amount)/fadeOutSamples):finalAmp;
fade = zeros(1,length(fadeOut)+length(fadeIn));
fade(1:length(fadeOut)) = fadeOut;
fade(length(fadeOut)+1:end) = fadeIn;
output_sig = MultiplySignals(sig, fade);
end

