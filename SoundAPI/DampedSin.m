function [ sig ] = DampedSin(t, freq, damp)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
sig = sin(2*pi*freq*t).*exp(-damp*t);
%sig = ReverseSignal(sig);
%sig = Envelope(sig,[0 .5 1 .5 0 .5 1 .5 0 .5 1 .5 0 .5 1 1], 0:(1/15):1);
end

