function [ output_sig ] = RepeatSignal(sig, n)
%Duplicates the signal n times
output_sig = [];
for i = 1:n
    output_sig = [output_sig sig];
end

