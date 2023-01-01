function varargout = communication(varargin)
%COMMUNICATION MATLAB code file for communication.fig
%      COMMUNICATION, by itself, creates a new COMMUNICATION or raises the existing
%      singleton*.
%
%      H = COMMUNICATION returns the handle to a new COMMUNICATION or the handle to
%      the existing singleton*.
%
%      COMMUNICATION('Property','Value',...) creates a new COMMUNICATION using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to communication_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      COMMUNICATION('CALLBACK') and COMMUNICATION('CALLBACK',hObject,...) call the
%      local function named CALLBACK in COMMUNICATION.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help communication

% Last Modified by GUIDE v2.5 01-Jan-2023 21:17:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @communication_OpeningFcn, ...
                   'gui_OutputFcn',  @communication_OutputFcn, ...
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


% --- Executes just before communication is made visible.
function communication_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for communication
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes communication wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = communication_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
set(handles.radiobutton2,'value',0);%12互斥
usrdata=get(handles.pushbutton2,'UserData');

%如果非空，则播放音乐
if isempty(usrdata)==0
    l1=usrdata(7,1);
    f1=usrdata(7,11);
    % l2=usrdata(7,2);
    % f2=usrdata(7,12);
    x1=usrdata(1,1:l1);
    % x2=usrdata(2,1:l2);
    sound(x1,f1);
    % sound(x2,f2);
end


% filename=get(handles.edit1,'UserData');
% disp(filename);
% if isempty(filename)==0
%     [x,fs_music]=audioread(filename);
%     sound(x,fs_music)%播放原音
% end





% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
set(handles.radiobutton1,'value',0);%12互斥
clear sound;
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
set(handles.radiobutton4,'value',0);%34互斥
usrdata=get(handles.pushbutton2,'UserData');

%如果非空，则播放音乐
if isempty(usrdata)==0
    %如果第三音轨长度不为0
    if usrdata(7,3)~=0
        l3=usrdata(7,3);
        f3=usrdata(7,13);
        % l4=usrdata(7,4);
        % f4=usrdata(7,14);
        x3=usrdata(3,1:l3);%取第三音轨
        % x4=usrdata(4,1:l4);%取第四音轨
        sound(x3,f3);
        % sound(x4,f4);
    end
end



% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
set(handles.radiobutton3,'value',0);%34互斥
clear sound;
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
guidata(hObject, handles)

set(handles.pushbutton2,'String',"传输中...");

%关闭所有播放按钮
clear sound
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',1);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',1);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',1);

filename=get(handles.edit1,'UserData');
disp(filename);
if isempty(filename)==0

    [x,fs_music]=audioread(filename);

    N=length(x);
    t=0:1/fs_music:(N-1)/fs_music;

    usrdata=zeros(7,N);%左右声道，原音/下采样/接收，6条音轨,第七维度用来防止6条音轨的长度信息
    set(handles.pushbutton2,'UserData',usrdata);
    
    x1=x(:,1)';%抽取x第1声道
    x2=x(:,2)';%抽取x第2声道
    
    inteval_second=str2double(get(handles.edit2,'String'));%截取15s测试
    inteval=fs_music*inteval_second;
    start_second=str2double(get(handles.edit3,'String'));
    start=fs_music*start_second;%从第start_second秒开始播放

    x1=x1(start:start+inteval-1);
    x2=x2(start:start+inteval-1);
    
    l1=length(x1);
    l2=length(x2);
    usrdata(1,1:l1)=x1;
    usrdata(2,1:l2)=x2;
    usrdata(7,1)=l1;
    usrdata(7,2)=l2;
    set(handles.pushbutton2,'UserData',usrdata);%左右声道，原音/下采样/接收，6条音轨
    %disp(size(get(handles.pushbutton2,'UserData')));%用于调试代码
    
    ds_list=str2double(get(handles.popupmenu1,'String'));%downsample rate,44100的因数,参考下采样率:2,3,4,5,6,8
    ds_key=get(handles.popupmenu1,'Value');
    ds=ds_list(ds_key);
    %disp(ds);%用于代码调试
    fs=fs_music/ds;%通信采样(8khz)远小于音频播放(40khz)采样
    l_sam=floor(length(x1)/ds);%向下取整

    
    sam1=zeros(l_sam,1);%采样信号
    sam2=zeros(l_sam,1);%采样信号
    for i =1:l_sam
        sam1(i)=x1(ds*i);
        sam2(i)=x2(ds*i);
    end
    
    l3=length(sam1);
    l4=length(sam2);
    usrdata(3,1:l3)=sam1;
    usrdata(4,1:l4)=sam2;
    usrdata(7,3)=l3;
    usrdata(7,4)=l4;
    set(handles.pushbutton2,'UserData',usrdata);

    
    usrdata(7,11)=fs_music;
    usrdata(7,12)=fs_music;
    usrdata(7,13)=fs;
    usrdata(7,14)=fs;
    set(handles.pushbutton2,'UserData',usrdata);


    % %输入抽样信号,输出量化编码
    pcm1=quantization(sam1);
    
    
    
    symbol_rate=str2double(get(handles.edit4,'String'));%码元速率,Baud/s
    fc=str2double(get(handles.edit7,'String'));%模拟载波频率,Hz
    smooth=str2double(get(handles.edit8,'String'));

    start_plot=str2double(get(handles.edit9,'String'));
    axes(handles.axes1);
    fsk16=fsk16mod(pcm1,symbol_rate,fc,smooth,false,start_plot);
    axes(handles.axes2);
    qam16=qam16mod(pcm1,symbol_rate,fc,smooth,false,start_plot);

end
set(handles.pushbutton2,'String',"开始传输");


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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.wav;*.mp3');
if isequal(file,0)
   disp('User selected Cancel');
   set(handles.edit1,'String',"(无文件)")
   guidata(hObject, handles)
   set(handles.edit1,'UserData','');
else
   disp(['User selected ', fullfile(path,file)]);
   set(handles.edit1,'String',file)
   guidata(hObject, handles)
   filename=fullfile(path,file);
   set(handles.edit1,'UserData',filename);
  
   [x,fs_music]=audioread(filename);
   N=length(x);
   usrdata=zeros(7,N);
   usrdata(1,:)=x(:,1)';
   usrdata(2,:)=x(:,2)';
   usrdata(7,1)=N;
   usrdata(7,2)=N;
   usrdata(7,11)=fs_music;
   usrdata(7,12)=fs_music;
   set(handles.pushbutton2,'UserData',usrdata);
   
end


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
set(handles.radiobutton6,'value',0);%56互斥
clear sound;
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
set(handles.radiobutton5,'value',0);%56互斥
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6