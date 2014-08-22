duration = 2.0;
volume = .2;
base = 40;
output_sig = [];
chord = [4 4 -inf 4 -inf 0 4 -inf 7 -inf -inf -inf -5 -inf -inf -inf] + base;
intro = GenChordSeq(chord, duration, volume, 1, @DampedColby2);
for base = [base]
    chord2 = [0 -inf -inf -5 -inf -inf -8 -inf -inf -3 -inf -1 -inf -2 -3 -inf] + base;
    chord3 = [-5 4 7] + base;
    chord4 = [9 -inf 5 7 -inf 4 -inf 0 2 -1 -inf -inf] + base;
    melody2 = GenChordSeq(chord2, duration, volume, 1, @DampedColby2);
    melody3 = GenChordSeq(chord3, duration/4, volume, 1, @DampedColby2);
    melody4 = GenChordSeq(chord4, duration*(3/4), volume, 1, @DampedColby2);
    mel = AppendSignals(melody2,melody3);
    verse1 = AppendSignals(mel,melody4);
    verse1 = RepeatSignal(verse1,2);
    verse1 = DelayEffect(verse1,.5,.5);
end

for base = [base]
    chord1 = [-inf -inf 7 6 5 3 -inf 4 -inf -4 -3 0 -inf -3 0 2 -inf -inf 7 6 5 3 -inf 4 -inf 12 -inf 12 12 -inf -inf -inf -inf -inf 7 6 5 3 -inf 4 -inf -4 -3 0 -inf -3 0 2 -inf -inf 3 -inf -inf 2 -inf -inf 0 -inf -inf -inf -inf -inf -inf -inf] + base;
    melody1 = GenChordSeq(chord1, duration*4, volume, 1, @DampedColby2);
    chord2 = [-12 -inf -inf -5 -inf -inf 0 -inf -7 -inf -inf 0 0 -inf -7 -inf -12 -inf -inf -8 -inf -inf -5 0 -inf -inf -inf -inf -inf -inf -5 -inf -12 -inf -inf -5 -inf -inf 0 -inf -7 -inf -inf 0 0 -inf -7 -inf -12 -inf -4 -inf -inf -2 -inf -inf 0 -inf -inf -5 -5 -inf -12 -inf] + base;
    melody2 = GenChordSeq(chord2, duration*4, volume, 1, @DampedColby2);
    chorus = AddSignals(melody1,melody2);
    chorus = RepeatSignal(chorus,2);
    chorus = DelayEffect(chorus,.5,.5);
end

output_sig = AppendSignals(intro,verse1);
output_sig = AppendSignals(output_sig,chorus);

output_sig = volume*NormalizeSignal(output_sig);
audio = PlaySignal(output_sig);