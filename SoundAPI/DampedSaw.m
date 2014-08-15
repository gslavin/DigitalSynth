function [ sig ] = DampedSaw(t, freq, damp)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
sig = sawtooth(2*pi*freq*t).*exp(-damp*t);
%sig = Envelope(sig,[0 1 0.5 0.5], [0 0.98 0.99 1]);
end

