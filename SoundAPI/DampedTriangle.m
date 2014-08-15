function [ sig ] = DampedTriangle(t, freq, damp)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
sig = sawtooth(2*pi*freq*t, 0.5).*exp(-damp*t);

end

