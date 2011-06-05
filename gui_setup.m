function varargout = gui_setup(varargin)
% GUI_SETUP MATLAB code for gui_setup.fig
%      GUI_SETUP, by itself, creates a new GUI_SETUP or raises the existing
%      singleton*.
%
%      H = GUI_SETUP returns the handle to a new GUI_SETUP or the handle to
%      the existing singleton*.
%
%      GUI_SETUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SETUP.M with the given input arguments.
%
%      GUI_SETUP('Property','Value',...) creates a new GUI_SETUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_setup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_setup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_setup

% Last Modified by GUIDE v2.5 03-Jun-2011 02:13:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_setup_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_setup_OutputFcn, ...
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


% --- Executes just before gui_setup is made visible.
function gui_setup_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global fp;
fp = 0;
%set(handles.threshslider, 'value', 0);
setText(handles);
% UIWAIT makes gui_setup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function setText(handles)
    global radius;
    global noise;
    global thresh;

    radius = str2double(get(handles.rslider, 'String'));
    noise = str2double(get(handles.filterslider, 'String'));
    thresh = str2double(get(handles.threshslider, 'String'));
    if(~radius); radius = 10; end;
    if(~noise); noise = 1; end;
    if(~thresh); thresh=20; end;
    drawMod(handles);

% --- Outputs from this function are returned to the command line.
function varargout = gui_setup_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fp;
global pos;
[file, path, ~] = uigetfile('*.tif');
fp = strcat(path, file);
pos = 1;
try
    drawOrig(handles);
    drawMod(handles);
    okbutton_Callback(hObject, eventdata, handles)

catch err
    msgbox(err.message);
end

function [b] = getImg
global fp
global pos
global noise
global radius
img = imread(fp, pos);
b = bpass(img, noise, radius);

function drawOrig(handles)
    global fp;
    global pos;
    global click;
    click = true;
    axes = handles.axes1;
    img = imread(fp,pos);
    imagesc(img,'parent', axes)

function drawMod(handles)
    global thresh;
    global fp;
    global click;
    
    if ~fp
        return
    end
    axes = handles.axes2;
    b = getImg;
    if click;
        thresh =  max(max(b))*.2;
        set(handles.threshslider, 'String', thresh);
        click = ~click;
    end;
    b(b < thresh) = 0;
    imagesc(b, 'parent', axes)
        

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on slider movement.
function rslider_Callback(hObject, eventdata, handles)

setText(handles);

% --- Executes during object creation, after setting all properties.
function rslider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function threshslider_Callback(hObject, eventdata, handles)

setText(handles);

% --- Executes during object creation, after setting all properties.
function threshslider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function filterslider_Callback(hObject, eventdata, handles)
setText(handles);

% --- Executes during object creation, after setting all properties.
function filterslider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in runs tracking.
function pushbutton5_Callback(hObject, eventdata, handles)
global fp;
if ~fp;
    msgbox('Please choose a file first.')
    return;
end;
trackingCells


% --- Executes on button press in set button.
function okbutton_Callback(hObject, eventdata, handles)
global thresh;
global radius;
global fp;
if ~fp;
    msgbox('Please choose a file first.')
    return;
end;
axes = handles.axes2;
b = getImg;
pk = pkfnd(b, thresh, radius);
b(b < thresh) = 0;
hold(axes, 'off');
imagesc(b, 'parent', axes)
for i=1:length(pk);
    hold(axes, 'on');
    scatter(axes, pk(i,1), pk(i,2),radius*4);
end;

function analyzeTracks(tmpres, images)
global radius;
fr = radius;
frwidth = size(images{1},2);
res = [];
for i=1:length(tmpres);
    t = tmpres(i,:);
    xmin = max(t(1)-fr,1);
    xmax = min(t(1)+fr,frwidth-1);
    ymin = max(t(2)-fr,1);
    ymax = min(t(2)+fr,frwidth-1);
    try
        b = images{t(3)}(xmin:xmax,ymin:ymax);
        med = sum(b(:));
        res = [res; t(1:4), med];
    catch err
        disp(err);
    end;
    if (i < length(tmpres)-1) && t(4)~=tmpres(i+1,4);
        % add 5 frames to end
        for j=1:min(5, length(images)-t(3));
            try
                b = images{t(3)+j}(xmin:xmax,ymin:ymax);
                med = sum(b(:));
                res = [res; t(1), t(2), t(3)+j, t(4), med];
            catch err
                disp(err.message);
            end
        end
    end
end

setappdata(0,'res', res);
setappdata(0,'images', images);
select_tracks;
%figure;
%for i=1:max(res(:,4))
%    c = double(i);
%    c = [abs(sin(c)) abs(sin(c+pi/4)) abs(sin(c+pi/2))];
%    hold on;
%    plot(res(res(:,4)==i,3),res(res(:,4)==i,5),'Color', c);
%end

function trackingCells
global thresh
global noise
global radius
global fp

info = imfinfo(fp);
num = numel(info);
r = [];
a = cell(1,num);
for ix=1:num;
    img = imread(fp, ix);
    b = bpass(img, noise, radius);
    pk = pkfnd(b, thresh, radius);
    b(b < thresh) = 0;
    a{ix} = b;
    for j=1:length(pk);
        r = [r; pk(j,1) pk(j,2) ix];
    end
end;

% param.mem is steps that can be forgotten. limit to 5 works well.
param.mem = 3;
% param.dim kept at default.
param.dim = 2;
% param.quiet lets us get some text output.
param.quiet = 0;
% param.good removes short, useless sequences.
param.good = 10;
% distance traveled in single timeframe ~ radius
res = track(r, radius, param);
msgbox('tracking complete.');
analyzeTracks(res, a)
