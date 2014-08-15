function [ output_sig] = AddSignals(sig1, sig2)
%Somtimes signals generated have slightly different number of samples

samples = max(length(sig1),length(sig2));
sig1(length(sig1)+1:samples) = 0;
sig2(length(sig2)+1:samples) = 0;
output_sig = sig1 + sig2;


end

