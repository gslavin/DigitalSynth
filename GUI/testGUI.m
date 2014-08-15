% George Slavin and Colby Bennett - Group 5 Section 62
function varargout = testGUI(varargin)
% TESTGUI MATLAB code for testGUI.fig
%      TESTGUI, by itself, creates a new TESTGUI or raises the existing
%      singleton*.
%
%      H = TESTGUI returns the handle to a new TESTGUI or the handle to
%      the existing singleton*.
%
%      TESTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTGUI.M with the given input arguments.
%
%      TESTGUI('Property','Value',...) creates a new TESTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

addpath('../SoundAPI/')
addpath('../Plugins/')

% Edit the above text to modify the response to help testGUI

% Last Modified by GUIDE v2.5 09-Aug-2014 18:42:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @testGUI_OpeningFcn, ...
    'gui_OutputFcn',  @testGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before testGUI is made visible.
function testGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testGUI (see VARARGIN)

%initialize comport variables
handles.setupState = 0;
global filterDataFlag;
filterDataFlag = 0;
global thresholdFlag;
thresholdFlag = 0;
global overThresholdFlag;
overThresholdFlag = 0;
global sampleStartFlag;
sampleStartFlag = 0;
global songStartFlag;
songStartFlag = 0;

% Initialize oscillator states
global osc1;
osc1.type = 'Osc';
osc1.sliderName = 'osc1Slider';
osc1.settingName = 'settingSelect1';
osc1.textName = 'osc1SettingText';
osc1.amplitude = .2;
osc1.damping = 0.1;
osc1.detuning = 0;

global osc2;
osc2.type = 'Osc';
osc2.sliderName = 'osc2Slider';
osc2.settingName = 'settingSelect2';
osc2.textName = 'osc2SettingText';
osc2.amplitude = .2;
osc2.damping = 0.1;
osc2.detuning = 0;

global volume;
volume.type = 'Volume';
volume.sliderName = 'volumeSlider';
volume.textName = 'volumeText';

% TODO: allowing the user to control alpha is a bad idea
global alpha;
alpha.type = 'Alpha';
alpha.sliderName = 'filterSlider';
alpha.textName = 'filterText';

global currentControl;
currentControl = osc1;



% initialize song buffers
% entire piece
global song;
song = [0];
% current working block
global currentSongBlock;
currentSongBlock = [0];
% current sequence
global currentMelody;
currentMelody = [0];

% sample and song audio
global sampleAudio;
global songAudio;
sampleAudio = [];
songAudio = [];



%initialize setting select values TODO
set(handles.osc1Slider,'Value',.2);
set(handles.osc2Slider,'Value',.2);

% Choose default command line output for testGUI
handles.output = hObject;

axes(handles.knob1);
imshow('macro-knob.jpg');

axes(handles.knob2);
imshow('macro-knob.jpg');

% Update handles structure
guidata(hObject, handles);


% This sets up the initial plot - only do when we are invisible
% so window can get raised using testGUI.
if strcmp(get(hObject,'Visible'),'off')
    %plot(rand(5));
end


% --- Outputs from this function are returned to the command line.
function varargout = testGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in GoButton.
function GoButton_Callback(hObject, eventdata, handles)
% hObject    handle to GoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% intialize buffers to zero
% pull data from audino
% calc mag stuff
% plot

global dataFlag;
dataFlag = 1;
global sampleStartFlag;
global songStartFlag;
global currentControl;
global alpha;
global sampleAudio;
global songAudio;

if ~isfield(handles,'initialized') % this sets up an if statement that
    % prevents the user from causing an error in the GUI if they were to
    % hit go before initializing
    msgbox('Please Initialize the accelerometer')
    % sends a message back to the user if it needs initialized
else

    cla; %clears the axes

    % initializes the buffers and sets the x, y, and mag ones to zero
    buf_len = 200; % sets the buffer length
    index = 1:buf_len; % sets up an index for the plot to reference

    % filtered results
    gxdataFiltered = zeros(buf_len,1);
    gydataFiltered = zeros(buf_len,1);
    magdataFiltered = zeros(buf_len,1);

    while(dataFlag == 1) % sets up a while loop to do a rolling plot
        handles.alpha = get(handles.(alpha.sliderName), 'Value');
        % Get the new values from the accelerometer and store them in gx,
        % gy, and gz
        [gx gy gz] = readAcc(handles.accelerometer, handles.calCo);

        mag = norm([gx gy]);
        % calls the axes from the AccelPlot
        axes(handles.AccelPlot); 
        
        gxFiltered = gx*(1-handles.alpha) + gxdataFiltered(end)*(handles.alpha);
        gyFiltered = gy*(1-handles.alpha) + gydataFiltered(end)*(handles.alpha);
        magFiltered = mag*(1-handles.alpha) + magdataFiltered(end)*(handles.alpha);

        gxdataFiltered = [gxdataFiltered(2:end) ; gxFiltered]; % updates the plot for x
        gydataFiltered = [gydataFiltered(2:end) ; gyFiltered]; % updates the plot for y
        magdataFiltered = [magdataFiltered(2:end) ; magFiltered]; % updates the mag data

        % subplot for resultant magnitude, x and y magnitude
        plot(index,magdataFiltered, 'k',index,gxdataFiltered,'b',index,gydataFiltered,'r');

        axis([1 buf_len -2 2]);  % sets up axis limits
        xlabel('time'); % sets an x axis label
        ylabel('Mag of acceleration'); % sets a y axis label
        grid on
        drawnow; %force MATLAB to redraw the figure
            
        if (strcmp(currentControl.type, 'Osc'))
            % updates the current slider
            handles = updateSlider(handles, currentControl,...
            gxFiltered);

            % Update the text of the slider
            handles = updateSliderText(handles, currentControl);

            currentControl = updateOscillatorState(handles, currentControl);
        else
            handles = updateSlider(handles, currentControl,...
            gxFiltered);
            handles = updateSliderText(handles, currentControl);
        end

        guidata(hObject, handles);
        if (sampleStartFlag == 1 &&...
            (isempty(sampleAudio) || strcmp(sampleAudio.running, 'off')));
            sampleAudio = playUserSample(handles);
        elseif (songStartFlag == 1 &&...
        (isempty(songAudio) || strcmp(songAudio.running, 'off')));
            songAudio = playSong(handles);
        end
    end

end

% Helper Functions
function [currentOsc] = updateOscillatorState(handles, currentOsc)
global osc1;
global osc2;
setting = handles.(currentOsc.settingName);
slider = handles.(currentOsc.sliderName);
valueName = get(setting, 'String');
valIndex = get(setting, 'Value');
valueName = valueName{valIndex};
while (valueName(end) == sprintf('\r') ||...
       valueName(end) == sprintf('\n'))
   valueName = valueName(1:end-1); 
end
valSlider = get(slider, 'Value');
currentOsc.(lower(valueName)) = valSlider;
if strcmp(currentOsc.settingName, 'settingSelect1')
   osc1 = currentOsc; 
else
   osc2 = currentOsc;
end

function [audio] = playSong(handles)
    global song;
    volume = get(handles.volumeSlider, 'Value');
    song = volume*NormalizeSignal(song);
    audio = PlaySignal(song);

function [output_sig] = genUserSample(handles)
global osc1;
global osc2;

duration = str2double(get(handles.speed1,'String'));
base = getSequence(handles.bass1);
output_sig = [];
for base = base
    seq = getSequence(handles.sample1);
    chord = seq + base;
    tone1 = getToneFunction(handles, 'waveformSelect1');
    melody1 = GenChordSeq(chord + osc1.detuning, duration, osc1.amplitude,...
        10*osc1.damping, tone1);
    tone2 = getToneFunction(handles, 'waveformSelect2');
    melody2 = GenChordSeq(chord + osc2.detuning, duration, osc2.amplitude,...
        10*osc2.damping, tone2);
    melody = AddSignals(melody1, melody2);
    output_sig = AppendSignals(output_sig, melody);
end

function [seq] = getSequence(textBox)
    seqString = get(textBox, 'String');
    disp('string stuff')
    seqString = strrep(seqString,'r','-Inf')
    seq = sscanf(seqString, '%f');
    seq = seq';
 
% TODO: current sample must be played to be generated
function [audio] = playUserSample(handles)
global currentMelody;
global currentSongBlock;

currentMelody = genUserSample(handles);
muteSeq = get(handles.muteSequence, 'Value');
muteCurrentBlock = get(handles.muteCurrentBlock, 'Value');
if (muteSeq == 0 && muteCurrentBlock == 0)
    output_sig = AddSignals(currentMelody, currentSongBlock);
elseif (muteCurrentBlock == 0)
    output_sig = currentSongBlock;
elseif (muteSeq == 0)
    output_sig = currentMelody;
else 
    output_sig = 0;
end
volume = get(handles.volumeSlider, 'Value');
output_sig = volume*NormalizeSignal(output_sig);
audio = PlaySignal(output_sig);

function [tone] = getToneFunction(handles, waveSelMenu)
    funcName = get(handles.(waveSelMenu), 'String');
    valIndex = get(handles.(waveSelMenu), 'Value');
    funcName = funcName{valIndex};
    % Last function in will have CR that must be removed
    while (funcName(end) == sprintf('\r') ||...
           funcName(end) == sprintf('\n'))
       funcName = funcName(1:end-1); 
    end
    tone = str2func(funcName);
    
    

function [handles] = updateSlider(handles, control, filterValue)
sliderName = control.sliderName;
increment = 0;
% if value > 0.8 increment by 0.1
% if value > 0.3 increment by 0.01
% if value > -0.3 increment by 0
% if value > -0.8 increment by -0.01
% else increment by -0.1
% check bounds - make sure slider doesnt go below 0 or higher than 1
if (filterValue > 0.8)
    increment = 0.1;
elseif (filterValue > 0.3)
    increment = 0.01;
elseif (filterValue > -0.3)
    increment = 0;
elseif (filterValue > -0.8)
    increment = -0.01;
else
    increment = -0.1;
end
sliderVal = get(handles.(sliderName),'Value');
sliderVal = sliderVal + increment;
if (sliderVal < 0)
    sliderVal = 0;
elseif (sliderVal > 1)
    sliderVal = 1;
end
set(handles.(sliderName),'Value',sliderVal);

function [handles] = updateSliderText(handles, currentControl)
if (strcmp(currentControl.type, 'Osc'))
    setting = handles.(currentControl.settingName);
    valueName = get(setting, 'String');
    valIndex = get(setting, 'Value');
    valueName = [valueName{valIndex} ': ']; 
elseif (strcmp(currentControl.type, 'Volume'))
    valueName = 'Volume: ';
elseif (strcmp(currentControl.type, 'Alpha'))
    valueName = 'alpha value: ';
end
text = handles.(currentControl.textName);
slider = handles.(currentControl.sliderName);
valSlider = get(slider, 'Value');
set(text, 'String', [valueName num2str(valSlider)]);

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes when the stop button is pushed in the GUI
function StopButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% calls the global dataFlag into the function and sets it to 0, stopping
% the rolling plot which is a while loop for when dataFlag equals 1
global dataFlag;
dataFlag = 0;

% Update handles structure
guidata(hObject, handles);

% --- Executes when the initialize button is pressed
function ComSetup_Callback(hObject, eventdata, handles)
% hObject    handle to ComSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% sets initialized variable to 1, uses handles to allow access outside
% this funtion - for use with 'go' function to check if initialized for
% example
handles.initialized = 1;

if (handles.setupState == 1) % sets up an if statement that checks if the setupState is 1
    %tell user it is already setup
    disp('COM already set up') % if the initialization is already done, nothing happens and a message is printed out
else
    %run the COM serial code to initialize it
    comPort = 'COM11'; % sets the COM port that the Arduino is connected to
    if (~exist('serialFlag','var')) % sets up the serial connection using setupSerial
        [handles.accelerometer.s,handles.serialFlag] = setupSerial(comPort);
    end
    if(~exist('calCo', 'var')) % sets up the calibration after serial connection using calibrate
        handles.calCo = calibrate(handles.accelerometer.s);
    end
    % sets the setupState to 1 indicating setup is complete
    handles.setupState = 1;
    set(handles.initText, 'Visible', 'on')
end
% Update handles structure
guidata(hObject, handles);


% --- Executes when the close serial button is pressed in the GUI
function closeSerialButton_Callback(hObject, eventdata, handles)
% hObject    handle to closeSerialButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closeSerial; % uses the closeSerial command


% --- Executes on slider movement.
function filterSlider_Callback(hObject, eventdata, handles)
% hObject    handle to filterSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% TODO: allowing the user to control alpha is a bad idea
% global currentControl;
% global alpha;
% currentControl = alpha;

handles.alpha = get(handles.filterSlider, 'Value');
set(handles.filterText, 'String', ['Alpha value: ' num2str(handles.alpha)]);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function filterSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

guidata(hObject, handles);



function sample1_Callback(hObject, eventdata, handles)
% hObject    handle to sample1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sample1 as text
%        str2double(get(hObject,'String')) returns contents of sample1 as a double


% --- Executes during object creation, after setting all properties.
function sample1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sample1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function bass1_Callback(hObject, eventdata, handles)
% hObject    handle to bass1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bass1 as text
%        str2double(get(hObject,'String')) returns contents of bass1 as a double


% --- Executes during object creation, after setting all properties.
function bass1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bass1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function speed1_Callback(hObject, eventdata, handles)
% hObject    handle to speed1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speed1 as text
%        str2double(get(hObject,'String')) returns contents of speed1 as a double


% --- Executes during object creation, after setting all properties.
function speed1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in waveformSelect1.
function waveformSelect1_Callback(hObject, eventdata, handles)
% hObject    handle to waveformSelect1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns waveformSelect1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from waveformSelect1
global currentControl;
global osc1;
currentControl = osc1;

% --- Executes during object creation, after setting all properties.
function waveformSelect1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveformSelect1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in settingSelect1.
function settingSelect1_Callback(hObject, eventdata, handles)
% hObject    handle to settingSelect1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns settingSelect1 contents as cell array
            % updates the slider at the bottom for current oscillator
global currentControl;
global osc1;
currentControl = osc1;
setting = handles.(currentControl.settingName);
valueName = get(setting, 'String');
valIndex = get(setting, 'Value');
% Get current setting name
valueName = lower(valueName{valIndex});
% remove newlines on last entry
while (valueName(end) == sprintf('\r') ||...
       valueName(end) == sprintf('\n'))
   valueName = valueName(1:end-1); 
end
% Update the slider with the stored value of the current setting
set(handles.(currentControl.sliderName),...
    'Value', currentControl.(valueName));

% Update the text of the slider
handles = updateSliderText(handles, currentControl);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function settingSelect1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to settingSelect1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function osc1Slider_Callback(hObject, eventdata, handles)
% hObject    handle to osc1Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currentControl;
global osc1;
currentControl = osc1;



% --- Executes during object creation, after setting all properties.
function osc1Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc1Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in sampleStart.
function sampleStart_Callback(hObject, eventdata, handles)
% hObject    handle to sampleStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sampleStartFlag;
global sampleAudio;
global songStartFlag;
% if the Start Song button was pressed and is still on, start sample will
% not work
if (songStartFlag == 0)
    strVal = get(handles.sampleStart,'String');
    if (strcmp(strVal,'Start Sample'))
        set(handles.sampleStart,'String','Stop Sample');
        sampleStartFlag = 1;
        % starts the oscillator
    else
        set(handles.sampleStart,'String','Start Sample');
        sampleStartFlag = 0;
        if (~isempty(sampleAudio))
            stop(sampleAudio);
        end
        % stops the oscillator
    end
    % sets the current view on the waveform graph to the sample
    set(handles.waveformSelect,'Value',2);
    waveformSelect_Callback(hObject, eventdata, handles);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in waveformSelect2.
function waveformSelect2_Callback(hObject, eventdata, handles)
% hObject    handle to waveformSelect2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns waveformSelect2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from waveformSelect2
global currentControl;
global osc2;
currentControl = osc2;

% --- Executes during object creation, after setting all properties.
function waveformSelect2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveformSelect2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in settingSelect2.
function settingSelect2_Callback(hObject, eventdata, handles)
% hObject    handle to settingSelect2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns settingSelect2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from settingSelect2
global currentControl;
global osc2;
currentControl = osc2;
setting = handles.(currentControl.settingName);
valueName = get(setting, 'String');
valIndex = get(setting, 'Value');
% Get current setting name
valueName = lower(valueName{valIndex});
% Update the slider with the stored value of the current setting
set(handles.(currentControl.sliderName),...
    'Value', currentControl.(valueName));

% Update the text of the slider
handles = updateSliderText(handles, currentControl);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function settingSelect2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to settingSelect2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function osc2Slider_Callback(hObject, eventdata, handles)
% hObject    handle to osc2Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global currentControl;
global osc2;
currentControl = osc2;

% --- Executes during object creation, after setting all properties.
function osc2Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc2Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in addButton.
function addButton_Callback(hObject, eventdata, handles)
% hObject    handle to addButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currentSongBlock;
global currentMelody;
global sampleStartFlag;
currentSongBlock = AddSignals(currentSongBlock, currentMelody);
% current sequence
% stops the audio from running and resets the start button if it is pushed
if (sampleStartFlag == 1)
    sampleStartFlag = 0;
    set(handles.sampleStart,'String','Start Sample');
end
% sets the waveform display to only the specific section
set(handles.waveformSelect,'Value',2);
waveformSelect_Callback(hObject, eventdata, handles);


% --- Executes on button press in appendButton.
function appendButton_Callback(hObject, eventdata, handles)
% hObject    handle to appendButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global song;
global currentSongBlock;
global sampleStartFlag;
song = AppendSignals(song, currentSongBlock);
volume = get(handles.volumeSlider, 'Value');
if (get(handles.waveformSelect, 'Value') == 1)
    axes(handles.WavePlot)
    plot(volume*NormalizeSignal(song))
    ylim([-1 1])
end
% stops the audio from running and resets the start button if it is pushed
if (sampleStartFlag == 1)
    sampleStartFlag = 0;
    set(handles.sampleStart,'String','Start Sample');
end
% sets the waveform display to the entire song
set(handles.waveformSelect,'Value',1);
waveformSelect_Callback(hObject, eventdata, handles);

% --- Executes on button press in exportButton.
function exportButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global song;
filename = get(handles.exportText, 'String');
audiowrite([filename '.wav'], song, 8000)
msgbox([filename '.wav has been saved'])


function exportText_Callback(hObject, eventdata, handles)
% hObject    handle to exportText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exportText as text
%        str2double(get(hObject,'String')) returns contents of exportText as a double


% --- Executes during object creation, after setting all properties.
function exportText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exportText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in songButton.
function songButton_Callback(hObject, eventdata, handles)
% hObject    handle to songButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global songStartFlag;
global songAudio;
global sampleStartFlag;
% if the Start Sample button was pressed and hasn't been stopped, the start
% song button will not work until the sample button is stopped
if (sampleStartFlag == 0)
    strVal = get(handles.songButton,'String');
    if (strcmp(strVal,'Start Song'))
        set(handles.songButton,'String','Stop Song');
        songStartFlag = 1;
        % starts the oscillator
    else
        set(handles.songButton,'String','Start Song');
        songStartFlag = 0;
        if (~isempty(songAudio))
            stop(songAudio);
        end
        % stops the oscillator
    end
    % sets the current view on the waveform graph to the whole song
    set(handles.waveformSelect,'Value',1);
    waveformSelect_Callback(hObject, eventdata, handles);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in resetSongButton.
function resetSongButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetSongButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global song;
song = [0];
% sets the current view on the waveform graph to the whole song
set(handles.waveformSelect,'Value',1);
waveformSelect_Callback(hObject, eventdata, handles);
axes(handles.WavePlot)
plot(NormalizeSignal(song))


% --- Executes on button press in resetSample.
function resetSample_Callback(hObject, eventdata, handles)
% hObject    handle to resetSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currentSongBlock;
currentSongBlock = [0];
% sets the current view on the waveform graph to current sample
set(handles.waveformSelect,'Value',2);
waveformSelect_Callback(hObject, eventdata, handles);

% --- Executes on slider movement.
function volumeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to volumeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global currentControl;
global volume;
currentControl = volume;

% TODO: remove when new dynamic controls work
%volume = get(handles.volumeSlider, 'Value');
%set(handles.volumeText, 'String', ['Volume: ' num2str(volume)])


% --- Executes during object creation, after setting all properties.
function volumeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volumeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in muteSequence.
function muteSequence_Callback(hObject, eventdata, handles)
% hObject    handle to muteSequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of muteSequence


% --- Executes on selection change in waveformSelect.
function waveformSelect_Callback(hObject, eventdata, handles)
% hObject    handle to waveformSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns waveformSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from waveformSelect
global song;
global currentSongBlock;
axes(handles.WavePlot)
select = get(handles.waveformSelect, 'Value');
volume = get(handles.volumeSlider, 'Value');

switch(select)
    case 1
        plotData = song;
    case 2
        plotData = currentSongBlock;
end
plot(volume*NormalizeSignal(plotData))
ylim([-1 1])

% --- Executes during object creation, after setting all properties.
function waveformSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveformSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in effectMenu.
function effectMenu_Callback(hObject, eventdata, handles)
% hObject    handle to effectMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns effectMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from effectMenu
global currentSongBlock;
global song;
songSelect = get(handles.waveformSelect,'Value');
switch songSelect
    case 1
        select = get(handles.effectMenu,'Value');
        switch select
            case 1 % repeat
                song = RepeatGUI(song);
            case 2 % normalize
                song = NormalizeGUI(song);
            case 3 % delay
                song = DelayGUI(song);
        end
    case 2
        select = get(handles.effectMenu,'Value');
        switch select
            case 1 % repeat
                currentSongBlock = RepeatGUI(currentSongBlock);
            case 2 % normalize
                currentSongBlock = NormalizeGUI(currentSongBlock);
            case 3 % delay
                currentSongBlock = DelayGUI(currentSongBlock);
        end
end
waveformSelect_Callback(hObject, eventdata, handles); % update the waveform graph

% --- Executes during object creation, after setting all properties.
function effectMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to effectMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in effectButton.
function effectButton_Callback(hObject, eventdata, handles)
% hObject    handle to effectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% TODO: calls appropriate effect GUI


% --- Executes on button press in muteCurrentBlock.
function muteCurrentBlock_Callback(hObject, eventdata, handles)
% hObject    handle to muteCurrentBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of muteCurrentBlock
