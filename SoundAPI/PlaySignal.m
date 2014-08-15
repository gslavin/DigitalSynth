function [ audio] = PlaySignal(y)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
fs = 8000;
audio = audioplayer(y, fs);
play(audio)
end

