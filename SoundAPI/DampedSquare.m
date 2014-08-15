function [ sig ] = DampedSquare(t, freq, damp)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
sig = square(2*pi*freq*t).*exp(-damp*t);
end


