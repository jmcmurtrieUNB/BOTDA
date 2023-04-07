function varargout = Laser_Initialization(varargin)
%LASER_INITIALIZATION MATLAB code file for Laser_Initialization.fig
%      LASER_INITIALIZATION, by itself, creates a new LASER_INITIALIZATION or raises the existing
%      singleton*.
%
%      H = LASER_INITIALIZATION returns the handle to a new LASER_INITIALIZATION or the handle to
%      the existing singleton*.
%
%      LASER_INITIALIZATION('Property','Value',...) creates a new LASER_INITIALIZATION using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Laser_Initialization_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LASER_INITIALIZATION('CALLBACK') and LASER_INITIALIZATION('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LASER_INITIALIZATION.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Laser_Initialization

% Last Modified by GUIDE v2.5 13-Jun-2018 23:46:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Laser_Initialization_OpeningFcn, ...
                   'gui_OutputFcn',  @Laser_Initialization_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Laser_Initialization is made visible.
function Laser_Initialization_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Laser_Initialization
handles.output = hObject;
handles.CWEnabled=0;
handles.PulseEnabled=0;
handles.Pulse=['COM' get(handles.PulsePort,'String')];
handles.CW=['COM' get(handles.CWPort,'String')];
%DARKPULSE_Lock(5);
% UNB_BOTDA_Lock(5);
handles.CWFine=0;
handles.PulseFine=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Laser_Initialization wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Laser_Initialization_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function CWPort_Callback(hObject, eventdata, handles)
% hObject    handle to CWPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CWPort as text
%        str2double(get(hObject,'String')) returns contents of CWPort as a double


% --- Executes during object creation, after setting all properties.
function CWPort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CWPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PulsePort_Callback(hObject, eventdata, handles)
% hObject    handle to PulsePort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PulsePort as text
%        str2double(get(hObject,'String')) returns contents of PulsePort as a double


% --- Executes during object creation, after setting all properties.
function PulsePort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PulsePort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CWFreq_Callback(hObject, eventdata, handles)
% hObject    handle to CWFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CWFreq as text
%        str2double(get(hObject,'String')) returns contents of CWFreq as a double


% --- Executes during object creation, after setting all properties.
function CWFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CWFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PulseFreq_Callback(hObject, eventdata, handles)
% hObject    handle to PulseFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PulseFreq as text
%        str2double(get(hObject,'String')) returns contents of PulseFreq as a double


% --- Executes during object creation, after setting all properties.
function PulseFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PulseFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in WhisperRadioButton.
function WhisperRadioButton_Callback(hObject, eventdata, handles)
% hObject    handle to WhisperRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WhisperRadioButton


% --- Executes on button press in DitherRadioButton.
function DitherRadioButton_Callback(hObject, eventdata, handles)
% hObject    handle to DitherRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DitherRadioButton


% --- Executes on button press in NoDitherRadioButton.
function NoDitherRadioButton_Callback(hObject, eventdata, handles)
% hObject    handle to NoDitherRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NoDitherRadioButton



function CWPower_Callback(hObject, eventdata, handles)
% hObject    handle to CWPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CWPower as text
%        str2double(get(hObject,'String')) returns contents of CWPower as a double


% --- Executes during object creation, after setting all properties.
function CWPower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CWPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PulsePower_Callback(hObject, eventdata, handles)
% hObject    handle to PulsePower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PulsePower as text
%        str2double(get(hObject,'String')) returns contents of PulsePower as a double


% --- Executes during object creation, after setting all properties.
function PulsePower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PulsePower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in disableCW.
function disableCW_Callback(hObject, eventdata, handles)
% hObject    handle to disableCW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LaserDisable(handles.CW);
handles.CWEnabled=0;
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of disableCW


% --- Executes on button press in enablePulse.
function enablePulse_Callback(hObject, eventdata, handles)
% hObject    handle to enablePulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Pulse=['COM' get(handles.PulsePort,'String')];
handles.PulseFrequency=str2double(get(handles.PulseFreq,'String'));
handles.PulseP=str2double(get(handles.PulsePower,'String'));

ret=LaserPower(handles.PulseP,handles.Pulse); % Set the pulse laser power level
if isempty(ret)
    ret=LaserSetFrequency(handles.PulseFrequency,handles.Pulse); % Sets the pulse laser operating frequency
    if isempty(ret)
        ret=LaserEnable(handles.Pulse); % Turn the laser on
        if isempty(ret)
            handles.time=tic;
            handles.PulseEnabled=1;
        end
    end
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of enablePulse


% --- Executes on button press in disablePulse.
function disablePulse_Callback(hObject, eventdata, handles)
% hObject    handle to disablePulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

LaserDisable(handles.Pulse);
handles.PulseEnabled=0;
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of disablePulse


% --- Executes on button press in changeMode.
function changeMode_Callback(hObject, eventdata, handles)
% hObject    handle to changeMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.CWEnabled==1 && handles.PulseEnabled==1
    t=toc(handles.time);
    if t<70
        H=waitbar(t/70,'Changing Mode. Please Wait...');
        while t<70
            H=waitbar(t/70,H);
            pause(1)
            t=toc(handles.time);
        end
        close(H);
    end
    dither=get(handles.DitherRadioButton,'Value');
    whisper=get(handles.WhisperRadioButton,'Value');
    noDither=get(handles.NoDitherRadioButton,'Value');

    if whisper==1
        handles.mode=2;
    elseif dither==1
        handles.mode=0;
    elseif noDither==1
        handles.mode=1;
    end

    ret=LaserMode(handles.CW,handles.mode);
    ret=LaserMode(handles.Pulse,handles.mode);
    guidata(hObject,handles)
else
    warndlg('Must Enable both lasers before the mode can be changed.','Warning')
end
    
% Hint: get(hObject,'Value') returns toggle state of changeMode


% --- Executes on button press in enableCW.
function enableCW_Callback(hObject, eventdata, handles)
% hObject    handle to enableCW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.CW=['COM' get(handles.CWPort,'String')];
handles.CWFrequency=str2double(get(handles.CWFreq,'String'));
handles.CWP=str2double(get(handles.CWPower,'String'));

ret=LaserPower(handles.CWP,handles.CW); % Set the CW laser power level
if isempty(ret)
    ret=LaserSetFrequency(handles.CWFrequency,handles.CW); % Sets the CW laser operating frequency
    if isempty(ret)
        ret=LaserEnable(handles.CW); % Turn the laser on
        if isempty(ret)
            handles.time=tic;
            handles.CWEnabled=1;
        end
    end
end
guidata(hObject,handles)



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.CWFineFrequency=str2double(get(handles.edit10,'String'));
handles.PulseFineFrequency=str2double(get(handles.edit11,'String'));
FineFrequency(handles.CWFineFrequency,handles.CW,1);
FineFrequency(handles.PulseFineFrequency,handles.Pulse,1);
guidata(hObject,handles)



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LockFrequency=str2double(get(handles.edit12,'String'));
% DARKPULSE_Lock(handles.LockFrequency);
UNB_BOTDA_Lock(handles.LockFrequency);
[handles.CWFine handles.PulseFine]=Auto_Lock_UNB_BOTDA(handles.CW,handles.Pulse,handles.CWFine,handles.PulseFine);
disp('locked')
guidata(hObject,handles)
