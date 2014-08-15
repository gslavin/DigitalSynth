function [ audio ] = PlaySequence( seq, duration, volume)
fs = 8000;
T = duration/(length(seq));
t = 0:(1/fs):T;
%y = zeros(1, length(t)*length(seq));
y = [];
for note = seq
    freq = 2^((note-49)/12)*440;
    temp = volume*sawtooth(2*pi*freq*t);
    y = [y temp];
end
plot(y)
xlim([0 100])
audio = audioplayer(y, fs);
play(audio)
end

