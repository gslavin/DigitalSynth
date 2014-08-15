function [ sig ] = DampedColby1(t, freq, damp)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
sig1 = .5*sawtooth(2*pi*freq*t).*exp(-damp*t);
sig2 = .8*sawtooth(2*pi*freq*t).*exp(-80*damp*t);
sig3 = 1.3*sin(4*pi*freq*t).*exp(-100*damp*t);
sigadd1 = AddSignals(sig1,sig2);
sigadd2 = AddSignals(sigadd1,sig3);
sig = MultiplySignals(sigadd1,sigadd2);




end

