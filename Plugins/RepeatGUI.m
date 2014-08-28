% George Slavin and Colby Bennett - Group 5 Section 62
function varargout = RepeatGUI(varargin)
% RepeatGUI MATLAB code for RepeatGUI.fig
%      RepeatGUI, by itself, creates a new RepeatGUI or raises the existing
%      singleton*.
%
%      H = RepeatGUI returns the handle to a new RepeatGUI or the handle to
%      the existing singleton*.
%
%      RepeatGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RepeatGUI.M with the given input arguments.
%
%      RepeatGUI('Property','Value',...) creates a new RepeatGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before outputGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to outputGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RepeatGUI

% Last Modified by GUIDE v2.5 07-Aug-2014 23:18:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @outputGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @outputGUI_OutputFcn, ...
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


% --- Executes just before RepeatGUI is made visible.
function outputGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RepeatGUI (see VARARGIN)

% Choose default command line output for RepeatGUI
handles.output = hObject;

handles.sig = varargin{1};
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RepeatGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = outputGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.sig;
close(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% input signal is 

%Perform Plugin work here:
repeatAmount = str2double(get(handles.repeatNumber, 'String'));
handles.sig = RepeatSignal(handles.sig,repeatAmount);

% save and output data
guidata(hObject, handles);
close(handles.figure1);



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end



function repeatNumber_Callback(hObject, eventdata, handles)
% hObject    handle to repeatNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repeatNumber as text
%        str2double(get(hObject,'String')) returns contents of repeatNumber as a double


% --- Executes during object creation, after setting all properties.
function repeatNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repeatNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
