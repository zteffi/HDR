function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 04-May-2015 19:02:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[i_file,i_PathName] = uigetfile({'*.jpg;*.png;*.tif;*.bmp', 'Image File';...
  '*.*', 'All Files (*.*)'},...
    'Select the image (Hold Ctrl to select multiple images, Ctrl+A to select all)',[cd '\'], 'MultiSelect', 'on'); 
if ~isequal(i_file, 0) || size(i_file,2) < 3
    %% Reading the Images files
    fileCount = size(i_file,2);
    ff = char(fullfile(i_PathName, i_file(1)));
    I = imread(ff);
    Imgs = zeros(fileCount,size(I,1),size(I,2),size(I,3));
    Imgs(1,:,:,:) = I;
    inf = imfinfo(ff);
    logExps = 1:fileCount;
    logExps(1) = log(inf.DigitalCamera.ExposureTime);

    InIms = I;
    for i = 2:fileCount
        ff = char(fullfile(i_PathName, i_file(i)));
        I = imread(ff);
        Imgs(i,:,:,:) = I;
        inf = imfinfo(ff);
        logExps(i) = log(inf.DigitalCamera.ExposureTime);
        InIms = [InIms,I];
    end
    %%
    axes(handles.axes1);
    imshow(InIms);
    
    E = illuminationMap(Imgs, logExps);
    I = normalizeToneMap(E);
    axes(handles.axes2);
    imshow(I),title('Nomalization');
    figure;imshow(I),title('Nomalization');
    I = durand02(I);
    axes(handles.axes4);
    imshow(I),title('Dourand02');
    figure;imshow(I),title('Dourand02');
else
    beep;
    msgbox('Select at least 3 images','Error');
    return;
end
