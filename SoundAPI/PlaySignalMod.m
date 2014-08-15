function [ audio] = PlaySignalMod(y)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
fs = 8000;
audio = audioplayer(y, fs);
playblocking(audio) %changed play to playblocking
%pause(max(size(y))/fs);
end

