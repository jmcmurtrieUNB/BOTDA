function varargout = plotwindow(varargin)
% PLOTWINDOW MATLAB code for plotwindow.fig
%      PLOTWINDOW, by itself, creates a new PLOTWINDOW or raises the existing
%      singleton*.
%
%      H = PLOTWINDOW returns the handle to a new PLOTWINDOW or the handle to
%      the existing singleton*.
%
%      PLOTWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTWINDOW.M with the given input arguments.
%
%      PLOTWINDOW('Property','Value',...) creates a new PLOTWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotwindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotwindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotwindow

% Last Modified by GUIDE v2.5 21-Jun-2017 10:24:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @plotwindow_OutputFcn, ...
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


% --- Executes just before plotwindow is made visible.
function plotwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotwindow (see VARARGIN)

% Choose default command line output for plotwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotwindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slidefrequency_Callback(hObject, eventdata, handles)
% hObject    handle to slidefrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slidefrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slidefrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slideposition_Callback(hObject, eventdata, handles)
% hObject    handle to slideposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slideposition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slideposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in plotbrowse.
function plotbrowse_Callback(hObject, eventdata, handles)
% hObject    handle to plotbrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath]=uigetfile();
load([FilePath FileName]);
complete = strcat(FilePath,FileName);
global finalavgplot;
finalavgplot=FinalAVG;
set(handles.plotpath,'string',complete);
frequencyheader1= num2str(FinalAVG(1,2));
frequencyheader2= num2str(FinalAVG(1,5));
frequencyheader3= num2str(FinalAVG(1,3));
frequencyheader4= num2str(FinalAVG(1,4));


set(handles.text10,'String',frequencyheader1);
set(handles.text12,'String',frequencyheader2);
set(handles.text14,'String',frequencyheader3);
set(handles.text16,'String',frequencyheader4);

fsize=size(FinalAVG);
plot(handles.plotfrequency,FinalAVG(1,(21:fsize(2))));
plot(handles.plottime,FinalAVG(:,21));
handles.AVG=FinalAVG;
guidata(hObject,handles)

function plotpath_Callback(hObject, eventdata, handles)
% hObject    handle to plotpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotpath as text
%        str2double(get(hObject,'String')) returns contents of plotpath as a double


% --- Executes during object creation, after setting all properties.
function plotpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotfrequency1.
function plotfrequency1_Callback(hObject, eventdata, handles)
% hObject    handle to plotfrequency1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
finalavgplot=handles.AVG;
fsize=size(finalavgplot);

Frquencyget =get(handles.edit2,'string');
set(handles.showfrequency,'String',Frquencyget);
Frquencyget = str2num(Frquencyget);


frequencygetplot1= (((Frquencyget - finalavgplot(1,2))/finalavgplot(1,3))+1);
if frequencygetplot1 > fsize(1,1)
    frequencygetplot1=fsize(1,1);
end
plot(handles.plotfrequency,finalavgplot(frequencygetplot1,(21:fsize(2))));


function plotposition_Callback(hObject, eventdata, handles)
% hObject    handle to plotposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotposition as text
%        str2double(get(hObject,'String')) returns contents of plotposition as a double


% --- Executes during object creation, after setting all properties.
function plotposition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotposition1.
function plotposition1_Callback(hObject, eventdata, handles)
% hObject    handle to plotposition1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
finalavgplot=handles.AVG;
fsize=size(finalavgplot);

positionget =get(handles.plotposition,'string');

set(handles.showposition,'String',positionget);
positionget = str2num(positionget);
if positionget > fsize(1,2)
    positionget=fsize(1,2);
end
plot(handles.plottime,finalavgplot(:,(21+positionget)));


% --- Executes on button press in plotthreed.
function plotthreed_Callback(hObject, eventdata, handles)
% hObject    handle to plotthreed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
finalavgplot=handles.AVG;
fsize=size(finalavgplot);
hsurf = surf(handles.plotall,finalavgplot(:,(21:fsize(2))),'EdgeColor','none','LineStyle','none','FaceLighting','phong');
ylabel('Frequency');
xlabel('Position');
zlabel('Intensity');


% --- Executes during object creation, after setting all properties.
function plotfrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotfrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate plotfrequency



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
