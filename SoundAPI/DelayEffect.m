function [ output_sig ] = DelayEffect(sig, delay, volume)
output_sig = [];
chord = [ -inf  ]; % adds a rest in to delay the signal
% creates the signal associated with the rest - this line gives the signal
% its delay amount
melody1 = GenChordSeq(chord, delay*.75, .2, 1, @DampedSin);
% appends the rest with the original signal to delay it
sigDelayNoVolumeAdjust = AppendSignals(melody1,sig);
% sets the overall volume of the delay signal
delaySig = sigDelayNoVolumeAdjust*volume;
% the two lines below find the length of the two audio signals - the
% delayed and original signal
delaySigSize = size(delaySig);
originalSigSize = size(sig);
% finds the difference in length between the two signals
signalSizeDiff = delaySigSize(2) - originalSigSize(2);
% adds the two signals together to get the delay effect
output_sig = AddSignals(sig,delaySig);
% trims the difference in signal length off of the end of the signal so
% there is no problem when using delay multiple times at different sections
% of the song
output_sig = output_sig(1:end-signalSizeDiff);
end