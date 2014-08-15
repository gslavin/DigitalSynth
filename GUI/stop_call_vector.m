
% stop and starts the program from executing depending n the current mode
% of operation

running = get(button, 'UserData');

if(running)
    set(button, 'UserData', 0, 'String', 'Start');
else
    set(button, 'UserData', 1, 'String', 'Stop');
 %  evalin('base', caller)
    wk3_vector

end

