function varargout = Homography(varargin)
% HOMOGRAPHY MATLAB code for Homography.fig
%      HOMOGRAPHY, by itself, creates a new HOMOGRAPHY or raises the existing
%      singleton*.
%
%      H = HOMOGRAPHY returns the handle to a new HOMOGRAPHY or the handle to
%      the existing singleton*.
%
%      HOMOGRAPHY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOMOGRAPHY.M with the given input arguments.
%
%      HOMOGRAPHY('Property','Value',...) creates a new HOMOGRAPHY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Homography_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Homography_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Homography

% Last Modified by GUIDE v2.5 21-Oct-2018 21:53:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Homography_OpeningFcn, ...
                   'gui_OutputFcn',  @Homography_OutputFcn, ...
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


% --- Executes just before Homography is made visible.
function Homography_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Homography (see VARARGIN)

% Choose default command line output for Homography
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global x1 y1 x2 y2 x3 y3 x4 y4 x1_ y1_ x2_ y2_ x3_ y3_ x4_ y4_ w w1_ w2_ w3_ w4_ src
x1 = 0;
y1 = 0;
x2 = 0; 
y2 = 0;
x3 = 0;
y3 = 0;
x4 = 0; 
y4 = 0;
x1_ = 0;
y1_ = 0;
x2_ = 0;
y2_ = 0;
x3_ = 0;
y3_ = 0;
x4_ = 0;
y4_ = 0;
w1_ = 1;
w2_ = 1;
w3_ = 1;
w4_ = 1;
w = 1;
src = imread('src.jpg');

% UIWAIT makes Homography wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Homography_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x1 y1 x2 y2 x3 y3 x4 y4 x1_ y1_ x2_ y2_ x3_ y3_ x4_ y4_ src
xi = [x1,y1 1;
            x2,y2 1;
            x3,y3 1;
            x4,y4 1;]
xi_ =   [x1_,y1_ 1;
            x2_,y2_ 1;
            x3_,y3_ 1;
            x4_,y4_ 1;]
npoints = 4;
A = zeros(2*npoints, 9);


k = 1
for i = 1:2:8
    xi_s = xi_(k,:);
    x = xi_s(1);
    y = xi_s(2);
    w = xi_s(3);
    A(i,4:6)= -w*xi(k,:); 
    A(i,7:9)= y*xi(k,:);
    A(i+1,1:3)= w*xi(k,:); 
    A(i+1,7:9)= -x*xi(k,:);
    k = k+1;
end;


if npoints==4
    H = null(A);
else
    [U,S,V] = svd(A);
    H = V(:,9);
end;

H_shaped = reshape(H,3,3);
tform = projective2d(H_shaped);
transformed = imwarp(src, tform);
imshow(transformed);
        
        
% --- Executes on button press in Calibrate.
function Calibrate_Callback(hObject, eventdata, handles)
% hObject    handle to Calibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 cla
 xlim(handles.axes1,[0 700]);
 ylim(handles.axes1,[0 700]);
 zlim(handles.axes1,[0 700]);
 xlim(handles.axes2,[0 700]);
 ylim(handles.axes2,[0 700]);
 zlim(handles.axes2,[0 700]);
 hold(handles.axes1,'on');
 hold(handles.axes2,'on');
 grid(handles.axes1,'on');
 grid(handles.axes2,'on');


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x1 y1 x2 y2 x3 y3 x4 y4 src
imshow(src);
[xa,ya] = getpts(handles.axes2);
x1 = xa(1);
x2 = xa(2);
x3 = xa(3);
x4 = xa(4);
y1 = ya(1);
y2 = ya(2);
y3 = ya(3);
y4 = ya(4);
scatter(xa,ya, 'fill');



% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x1_ y1_ x2_ y2_ x3_ y3_ x4_ y4_ 
[xa_,ya_] = getpts(handles.axes1);
x1_ = xa_(1);
x2_ = xa_(2);
x3_ = xa_(3);
x4_ = xa_(4);
y1_ = ya_(1);
y2_ = ya_(2);
y3_ = ya_(3);
y4_ = ya_(4);
scatter(xa_,ya_, 'fill')
