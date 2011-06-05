function varargout = select_tracks(varargin)
% SELECT_TRACKS MATLAB code for select_tracks.fig
%      SELECT_TRACKS, by itself, creates a new SELECT_TRACKS or raises the existing
%      singleton*.
%
%      H = SELECT_TRACKS returns the handle to a new SELECT_TRACKS or the handle to
%      the existing singleton*.
%
%      SELECT_TRACKS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT_TRACKS.M with the given input arguments.
%
%      SELECT_TRACKS('Property','Value',...) creates a new SELECT_TRACKS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before select_tracks_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to select_tracks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select_tracks

% Last Modified by GUIDE v2.5 03-Jun-2011 03:50:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_tracks_OpeningFcn, ...
                   'gui_OutputFcn',  @select_tracks_OutputFcn, ...
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

% --- Executes just before select_tracks is made visible.
function select_tracks_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to select_tracks (see VARARGIN)

global adjres;
global res;
global images;
% Choose default command line output for select_tracks
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

res = getappdata(0,'res');
disp(res);
images = getappdata(0,'images');
m = max(res(:,4));
set(handles.slider1, 'max', m);
set(handles.slider1, 'min', 1);
set(handles.slider1, 'value', m);
adjres = res;
if strcmp(get(hObject,'Visible'),'off')
    drawTrack(handles);
end

% UIWAIT makes select_tracks wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = select_tracks_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
h = gca;
plot(h,[1,1]);
global images;
global adjres;
for i=1:max(adjres(:,3));
    hold(h, 'off');
    imagesc(images{i}, 'parent', h);
    t = adjres(adjres(:,3)==i, :)
    title(h, int2str(i));
    for j=1:length(t);
        hold(h, 'on');  
        c = double(t(j,4));
        c = [abs(sin(c)) abs(sin(c+pi/4)) abs(sin(c+pi/2))];
        scatter(h, t(j,1), t(j,2), 50,c,'x'); 
    end;
    pause(0.1);
end

function drawTrack(handles)
global adjres
ax = handles.axes1;
plot(ax, 1:10, 1:10);
for i=1:max(adjres(:,4))
    c = double(i);
    c = [abs(sin(c)) abs(sin(c+pi/4)) abs(sin(c+pi/2))];
    hold(ax,'on');
    plot(ax, adjres(adjres(:,4)==i,3),adjres(adjres(:,4)==i,5),'Color', c);
end

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global adjres
uisave adjres tracks.mat


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
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


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global adjres;
global res;
adjres = [];
num_tracks = get(handles.slider1, 'value');
j = zeros(1, max(res(:,4)));
for i=1:length(j);
    br = res(res(:,4)==i,5);
    j(i) = max(br)-min(br);
end;
[b,ix] = sort(j);
for i=(length(ix)-round(num_tracks)):length(ix);
    adjres = [adjres ; res(res(:,4)==ix(i),:)];
end;
cla(handles.axes1);
drawTrack(handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
