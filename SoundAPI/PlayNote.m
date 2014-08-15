%function [ audio ] = PlayNote(note, duration)
note = 40;
duration = 1;
fs = 8000;
T = duration;
t = 0:(1/fs):T;

freq = 2^((note-49)/12)*440;
a = 0.1;

y = a*square(2*pi*freq*t).*exp(-5*t);

audio = audioplayer(y, fs);
play(audio);
%end

