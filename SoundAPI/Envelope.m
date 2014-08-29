% Defines an envelope function and multiplies the signal by that envelope
function [ output_sig] = Envelope(sig, levels, pivots)
    if (length(levels) ~= length(pivots))
        error('levels must be same length as pivots')
    end
    samples = length(sig);
    multiplier = zeros(1, samples);
    start = 1;
    for i = 1:length(levels)-1
        segSamples = round((pivots(i+1)-pivots(i))*samples);
        segIncrement = (levels(i+1)-levels(i))/segSamples;
        segMultiplier = levels(i):segIncrement:levels(i+1);
        % vector creation fails if two consecutive levels are the same
        if isempty(segMultiplier)
           segMultiplier = levels(i).*ones(1, segSamples);
        end
        ending = (start-1) + length(segMultiplier);
        multiplier(start:ending) = segMultiplier;
        start = ending+1;
    end
    output_sig = MultiplySignals(sig, multiplier);

end
