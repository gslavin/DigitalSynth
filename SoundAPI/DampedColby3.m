function [ sig ] = DampedColby3(t, freq, damp)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
sig1 = sin(2*pi*freq*t).*exp(-damp*t);
sig2 = 1.5*sawtooth(2*pi*freq*t).*(200.^(-damp*t));
sig3 = 5*sin(-8*pi*freq*t).*((-damp*t));
sig4 = 1.2*square(-16*pi*freq*t).*(100.^(-damp*t));
sigadd1 = AddSignals(sig1,sig2);
sigadd2 = AddSignals(sigadd1,sig3);
sig = AddSignals(sigadd2,sig4);




end

