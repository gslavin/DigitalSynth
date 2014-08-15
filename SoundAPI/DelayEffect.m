function [ output_sig ] = DelayEffect(sig, delay, volume)
output_sig = [];
chord = [ -inf  ];
melody1 = GenChordSeq(chord, delay*.75, .2, 1, @DampedColby3);
sigDelayNoVolumeAdjust = AppendSignals(melody1,sig);
delaySig = sigDelayNoVolumeAdjust*volume;
output_sig = AddSignals(sig,delaySig);
end