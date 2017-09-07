function varargout = StegGUI(varargin)
% STEGGUI MATLAB code for StegGUI.fig
%      STEGGUI, by itself, creates a new STEGGUI or raises the existing
%      singleton*.
%
%      H = STEGGUI returns the handle to a new STEGGUI or the handle to
%      the existing singleton*.
%
%      STEGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEGGUI.M with the given input arguments.
%
%      STEGGUI('Property','Value',...) creates a new STEGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StegGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StegGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StegGUI

% Last Modified by GUIDE v2.5 06-Sep-2017 15:11:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StegGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @StegGUI_OutputFcn, ...
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


% --- Executes just before StegGUI is made visible.
function StegGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StegGUI (see VARARGIN)

% Choose default command line output for StegGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StegGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StegGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_hidemsg_Callback(hObject, eventdata, handles)
% hObject    handle to edit_hidemsg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_hidemsg as text
%        str2double(get(hObject,'String')) returns contents of edit_hidemsg as a double


% --- Executes during object creation, after setting all properties.
function edit_hidemsg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_hidemsg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_chooseimage.
function popupmenu_chooseimage_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_chooseimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_chooseimage contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_chooseimage


% --- Executes during object creation, after setting all properties.
function popupmenu_chooseimage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_chooseimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_makesteg.
function pushbutton_makesteg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makesteg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_quality.
function popupmenu_quality_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_quality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_quality contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_quality


% --- Executes during object creation, after setting all properties.
function popupmenu_quality_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_quality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_decofile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_decofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_decofile as text
%        str2double(get(hObject,'String')) returns contents of edit_decofile as a double


% --- Executes during object creation, after setting all properties.
function edit_decofile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_decofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_quality_2.
function popupmenu_quality_2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_quality_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_quality_2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_quality_2


% --- Executes during object creation, after setting all properties.
function popupmenu_quality_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_quality_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_decode.
function pushbutton_decode_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_choosemethod.
function popupmenu_choosemethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_choosemethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_choosemethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_choosemethod


% --- Executes during object creation, after setting all properties.
function popupmenu_choosemethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_choosemethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dct_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dct as text
%        str2double(get(hObject,'String')) returns contents of edit_dct as a double


% --- Executes during object creation, after setting all properties.
function edit_dct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_repetition_Callback(hObject, eventdata, handles)
% hObject    handle to edit_repetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_repetition as text
%        str2double(get(hObject,'String')) returns contents of edit_repetition as a double


% --- Executes during object creation, after setting all properties.
function edit_repetition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_repetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_run.
function pushbutton_run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_start_stop.
function pushbutton_start_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_capture.
function pushbutton_capture_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_upload.
function pushbutton_upload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_upload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_mail_demo.
function pushbutton_mail_demo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_mail_demo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
