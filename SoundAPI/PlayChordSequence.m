function [ audio ] = PlayChordSequence(seq, duration, volume)
fs = 8000;
T = duration/(length(seq));
t = 0:(1/fs):T;
%y = zeros(1, length(t)*length(seq));
y = [];
for chord = seq
    temp = zeros(1,length(t));
    for note = chord'
        freq = 2^((note-49)/12)*440;
        temp = temp + (volume/(length(chord)))*sin(2*pi*freq*t).*exp(-t);
    end 
    y = [y temp];
end
plot(y)
xlim([0 100])
audio = audioplayer(y, fs);
play(audio)
end
