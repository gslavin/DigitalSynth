output_sig = [];
for i = [0 0 5 0]
    %-Inf represents a rest
    %chord = [40 44 47 -Inf -Inf -Inf 47 44];
    chord = [40 44 47 49 51 49 47 44];
    duration = 1.5;
    volume = 0.1;
    sig1 = GenChordSeq(chord+i, duration, volume);
    sig2 = GenChordSeq(40 + i, duration, volume);
    sig = AddSignals(sig1, sig2);
    sig = RepeatSignal(sig, 2);
%     while(strcmp(audio.running,'on'))
%         disp('running')
%         pause(0.001)
%     end
    output_sig = AppendSignals(output_sig,sig);
end
output_sig = volume*NormalizeSignal(output_sig);
audio = PlaySignal(output_sig);