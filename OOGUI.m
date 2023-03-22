

function varargout = OOGUI(varargin)
% OOGUI MATLAB code for OOGUI.fig
%      OOGUI, by itself, creates a new OOGUI or raises the existing
%      singleton*.
%
%      H = OOGUI returns the handle to a new OOGUI or the handle to
%      the existing singleton*.
%
%      OOGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OOGUI.M with the given input arguments.
%
%      OOGUI('Property','Value',...) creates a new OOGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OOGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OOGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OOGUI

% Last Modified by GUIDE v2.5 17-Jan-2023 11:32:23

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OOGUI_OpeningFcn, ...
    'gui_OutputFcn',  @OOGUI_OutputFcn, ...
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


% --- Executes just before OOGUI is made visible.
function OOGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OOGUI (see VARARGIN)
% Connect to spectrometer
%from get_OOspectrometer

addpath('C:\Program Files\Ocean Optics\OmniDriver\OOI_HOME\');
%     addpath('Toolbox')
%     addpath('C:\Users\nlv10962\OneDrive - Philips\Matlab\BloodClotDiscriminationNew\OceanOpticsMatlab\OmniDriver\');
%     javaaddpath('C:\Program Files\Ocean Optics\OmniDriver\OOI_HOME\OmniDriver.jar');
import('com.oceanoptics.omnidriver.api.wrapper.Wrapper');
wrapper = Wrapper();
handles.wrapper = wrapper;
NoOfDevices = handles.wrapper.openAllSpectrometers();
apiversion = handles.wrapper.getApiVersion();
exception = handles.wrapper.getLastException();

%initial settings
handles.Test_Name='Phantom test';
handles.Sample_Name='Spectralon';
handles.Probe_Name='200 micron PN';
handles.Splitter_Name='200 micron splitter';
handles.integration_time=20;
handles.PeakSelectionDone=false;
handles.threshold=3500;
assignin('base','PeakSelectionDone',handles.PeakSelectionDone);
handles.wavelengthcalibrationdone=false;
% Choose default command line output for OOGUI

handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OOGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OOGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
%% Some settings for device 0
str=get(hObject,'String');
val=str2num(str);
set(handles.edit1,'Value',val);
integration_time=handles.edit1.Value*1000; %1000 = 1ms
handles.wrapper.setIntegrationTime(0,integration_time);

handles.wrapper.setScansToAverage(0,handles.edit2.Value);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
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
str=get(hObject,'String');
val=str2num(str);
set(handles.edit2,'Value',val);
NrAverages=handles.edit2.Value;
handles.wrapper.setScansToAverage(0,NrAverages);
guidata(hObject, handles);


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


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in White_Ref_Pushbutton.
function White_Ref_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to White_Ref_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% fHandle1 = figure(1)
% set(fHandle1,'CurrentAxes',handles.axes1);
axes(handles.axes1);
guidata(hObject, handles);
number_of_spectra=10;
wl = handles.wrapper.getWavelengths(0)';
for ii=1:number_of_spectra
    spectrum_raw(ii,:) = handles.wrapper.getSpectrum(0)';
end
%% Subtract dark current 
if number_of_spectra>1
    spectrum_av=mean(spectrum_raw);
else
    spectrum_av=spectrum_raw;
end
dark_current=mean(spectrum_av(wl>220 & wl<380));
spectrum_av=spectrum_av-dark_current;
spectrum=spectrum_raw-dark_current;
spectrum_av(wl<400)=NaN;

% calculate the average spectrum
% spectra_av1=mean(spectrum,1);
spectra_av1=spectrum_av;
handles.spectra_av1=spectra_av1;
%store the spectrum average to base memory
assignin('base','spectra_av1',spectra_av1)
plot(wl,spectrum)
title('Spectrum raw')
xlabel('\lambda [nm]')
ylabel('Counts')

% if exist('reference','var') % If  a white reference has been defined -> show the relative spectrum
%     figure(2)
%     clf
%     plot(wl,spectrum./reference)
%     title('Spectrum/Reference')
%     xlabel('\lambda [nm]')
%     ylabel('Relative intensity')
% end

%storing the measured white reference spectrum
integration_time=handles.edit1.Value*1000;
comment{1}=handles.Test_Name; %'Home test';'Phantom test';
comment{2}=handles.Sample_Name; %'Spectralon';'Skin';'Water';'Spectralon';'Milk+Red';'Milk';
comment{3}=handles.Probe_Name; %'2-200micron PN';'NoProbe'; '100 micron fiber (Photonic Needle) 16 degree';'G1';
comment{4}=handles.Splitter_Name;%'200micron fibersplitter';'New 105 micron FiberBundle';'105 micron splitter (white=spectrometer)';'105 micron splitter (red=spectrometer)';'Circulator (blue=source)';'Old FiberBundle';
timestamp=datetime;

folder_name=['MeasuredSpectra','\',date];   % The sub-directory is named after the current date
[~, ~] = mkdir(folder_name);
% filename = nextname([folder_name,'\','OOSpectrum'],'00001','.mat');   % Use nextname to generate a unique filename
filename =  ['OOSpectrum','00001','.mat'];
save ([folder_name,'\',filename],'wl', 'spectrum','spectrum_raw', 'spectrum_av','integration_time','comment','timestamp' )
['Saved as ',folder_name,'\',filename]
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in Black_Ref_Pushbutton.
function Black_Ref_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Black_Ref_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% fHandle1 = figure(1)
% set(fHandle1,'CurrentAxes',handles.axes1);
axes(handles.axes1);
guidata(hObject, handles);
number_of_spectra=10;
wl = handles.wrapper.getWavelengths(0)';
for ii=1:number_of_spectra
    spectrum_raw(ii,:) = handles.wrapper.getSpectrum(0)';
end
%% Subtract dark current 
if number_of_spectra>1
    spectrum_av=mean(spectrum_raw);
else
    spectrum_av=spectrum_raw;
end
dark_current=mean(spectrum_av(wl>220 & wl<380));
spectrum_av=spectrum_av-dark_current;
spectrum=spectrum_raw-dark_current;
spectrum_av(wl<400)=NaN;

% calculate the average Black_Ref spectrum
spectra_av2=spectrum_av;
handles.spectra_av2=spectra_av2;
%store the spectrum average to base memory
assignin('base','spectra_av2',spectra_av2)
plot(wl,spectrum)
title('Spectrum raw')
xlabel('\lambda [nm]')
ylabel('Counts')



%storing the measured Black_Ref reference spectrum
integration_time=handles.edit1.Value*1000;
comment{1}=handles.Test_Name; %'Home test';'Phantom test';
comment{2}=handles.Sample_Name; %'Spectralon';'Skin';'Water';'Spectralon';'Milk+Red';'Milk';
comment{3}=handles.Probe_Name; %'2-200micron PN';'NoProbe'; '100 micron fiber (Photonic Needle) 16 degree';'G1';
comment{4}=handles.Splitter_Name;%'200micron fibersplitter';'New 105 micron FiberBundle';'105 micron splitter (white=spectrometer)';'105 micron splitter (red=spectrometer)';'Circulator (blue=source)';'Old FiberBundle';
timestamp=datetime;

folder_name=['MeasuredSpectra','\',date];   % The sub-directory is named after the current date
[~, ~] = mkdir(folder_name);
% filename = nextname([folder_name,'\','OOSpectrum'],'00001','.mat');   % Use nextname to generate a unique filename
filename =  ['OOSpectrum','00002','.mat'];
save ([folder_name,'\',filename],'wl', 'spectrum','spectrum_raw', 'spectrum_av','integration_time','comment','timestamp' )
['Saved as ',folder_name,'\',filename]
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in Spectrum_Pushbutton.
function Spectrum_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Spectrum_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% fHandle1 = figure(1)
% set(fHandle1,'CurrentAxes',handles.axes1);
axes(handles.axes1);
guidata(hObject, handles);
number_of_spectra=10;
wl = handles.wrapper.getWavelengths(0)';
for ii=1:number_of_spectra
    spectrum_raw(ii,:) = handles.wrapper.getSpectrum(0)';
end
%% Subtract dark current 
if number_of_spectra>1
    spectrum_av=mean(spectrum_raw);
else
    spectrum_av=spectrum_raw;
end
dark_current=mean(spectrum_av(wl>220 & wl<380));
spectrum_av=spectrum_av-dark_current;
spectrum=spectrum_raw-dark_current;
spectrum_av(wl<400)=NaN;
spectra_av=spectrum_av;
handles.spectra_av=spectra_av;
plot(wl,spectrum)
title('Spectrum raw')
xlabel('\lambda [nm]')
ylabel('Counts')


% figure(2) White Ref
axes(handles.axes2);
handles.spectra_av1=evalin('base', 'spectra_av1')

normalized_spectrum=handles.spectra_av./handles.spectra_av1;
i=find(wl>449);
i1=i(1);
i=find(wl>1049);
i2=i(1);
maxy=max(normalized_spectrum(1,i1:i2),[],2);

plot(wl,normalized_spectrum)
title('Spectrum (White Ref)')
xlabel('\lambda [nm]')
ylabel('Counts')
axis([450 1050 0 maxy ])

% figure(3) White + Blac Ref
axes(handles.axes3);

handles.spectra_av1=evalin('base', 'spectra_av1')
handles.spectra_av2=evalin('base', 'spectra_av2')
normalized_spectrum=(handles.spectra_av- handles.spectra_av2)./(handles.spectra_av1- handles.spectra_av2);
i=find(wl>449);
i1=i(1);
i=find(wl>1049);
i2=i(1);
maxy=max(normalized_spectrum(1,i1:i2),[],2);

plot(wl,normalized_spectrum)
title('Spectrum (White+Black Ref)')
xlabel('\lambda [nm]')
ylabel('Counts')
axis([450 1050 0 maxy ])

%storing the measured Sample spectrum
integration_time=handles.edit1.Value*1000;
comment{1}=handles.Test_Name; %'Home test';'Phantom test';
comment{2}=handles.Sample_Name; %'Spectralon';'Skin';'Water';'Spectralon';'Milk+Red';'Milk';
comment{3}=handles.Probe_Name; %'2-200micron PN';'NoProbe'; '100 micron fiber (Photonic Needle) 16 degree';'G1';
comment{4}=handles.Splitter_Name;%'200micron fibersplitter';'New 105 micron FiberBundle';'105 micron splitter (white=spectrometer)';'105 micron splitter (red=spectrometer)';'Circulator (blue=source)';'Old FiberBundle';
timestamp=datetime;

folder_name=['MeasuredSpectra','\',date];   % The sub-directory is named after the current date
[~, ~] = mkdir(folder_name);
filename = nextname([folder_name,'\','OOSpectrum'],'00002','.mat');   % Use nextname to generate a unique filename

if handles.wavelengthcalibrationdone
    save ([folder_name,'\',filename],'calibratedwavelength', 'spectrum','spectrum_raw', 'spectrum_av','integration_time','comment','timestamp' )
else
    save ([folder_name,'\',filename],'wl', 'spectrum','spectrum_raw', 'spectrum_av','integration_time','comment','timestamp' )
end
['Saved as ',folder_name,'\',filename]

%Show filename at bottom of plot figure
handles.text9.String=filename;
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in Wavelength_Cal_Pushbutton.
function Wavelength_Cal_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Wavelength_Cal_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 
% calibration on HG1 Mercury Argon calibration light source
% Mercury Peaks
% 253.65,296.73,302.15,313.16,334.15,365.01,404.66,435.84,546.08,576.96,579.07
% Argon Peaks
% 696.54,738.40,750.39,763.51,772.40,794.82,800.62,811.53,826.45,840.82,842.46,912.30 965.77 1014.61 
truewl=[365.01
404.66
435.84
546.08
576.96
579.07
696.54
706.72
727.29
738.40
750.39
763.51
772.40
794.82
800.62
811.53
826.45
840.82
842.46
852.14
912.30
922.45 
965.77
1014.61];

SelectedPeaks=[365.01
404.66
435.84
546.08
696.54
763.51
811.53
912.30
1014.61];


axes(handles.axes1);

number_of_spectra=10;
wl = handles.wrapper.getWavelengths(0)';
for ii=1:number_of_spectra
    spectrum_raw (ii,:) = handles.wrapper.getSpectrum(0)';
end
%% Subtract dark current 
if number_of_spectra>1
    spectrum_av=mean(spectrum_raw);
else
    spectrum_av=spectrum_raw;
end
dark_current=mean(spectrum_av(wl>220 & wl<380));
spectrum_av=spectrum_av-dark_current;
spectrum=spectrum_raw-dark_current;
spectrum_av(wl<400)=NaN;
spectra_av=spectrum_av;
handles.spectra_av=spectra_av;
 

plot(wl,spectrum)
title('Spectrum raw')
xlabel('Wavelength [nm]')
% xlabel('\lambda [nm]')
ylabel('Counts')

axes(handles.axes2);

x=1:size(spectrum,2);
plot(x,spectrum)
title('Spectrum raw')
xlabel('pixelnr')
% xlabel('\lambda [nm]')
ylabel('Counts')
integration_time=handles.edit1.Value*1000;
comment{1}=handles.Test_Name; %'Home test';'Phantom test';
comment{2}=handles.Sample_Name; %'Spectralon';'Skin';'Water';'Spectralon';'Milk+Red';'Milk';
comment{3}=handles.Probe_Name; %'2-200micron PN';'NoProbe'; '100 micron fiber (Photonic Needle) 16 degree';'G1';
comment{4}=handles.Splitter_Name;%'200micron fibersplitter';'New 105 micron FiberBundle';'105 micron splitter (white=spectrometer)';'105 micron splitter (red=spectrometer)';'Circulator (blue=source)';'Old FiberBundle';
timestamp=datetime;
folder_name=['MeasuredSpectra','\',date];   % The sub-directory is named after the current date
[~, ~] = mkdir(folder_name);
 
filename =  [folder_name,'\','OOSpectrum','00000','.mat'];   % Use nextname to generate a unique filename
save (filename,'wl', 'spectrum','spectrum_raw', 'spectrum_av','integration_time','comment','timestamp' ) % 
 

%find peaks above threshold
ys=spectra_av;
 
th=handles.threshold;

[Ypks,Xpks]=findpeaks(spectra_av,'MinPeakHeight',th)
NumberOfPeaks=size(Xpks,2);
% handles.edit7.Value=NumberOfPeaks;
guidata(hObject, handles);

peaklist=[];
for i=1:NumberOfPeaks
    disp([num2str(i) ' : ' num2str(wl(Xpks(i)))])
    peaklist(i)=wl(Xpks(i));
end
 
peaklist=num2cell(peaklist);
 


%show the measured HgAg spectrum in a separate window to check the peaks

fig = figure(10);
set(fig, 'Position', [0 0 1500 720]);
plot(wl, ys)
title('Spectrum raw')
xlabel('Wavelength [nm]')
% xlabel('\lambda [nm]')
ylabel('Counts')

h_list = uicontrol('style','list','max',11,...
   'min',1,'Position',[1400 200 80 400],...
   'string',peaklist );
set(h_list,'Max',9,'Min',0);
 
dx =10; dy = 10; % displacement so the text does not overlay the data points
for i = 1: NumberOfPeaks
    text(wl(Xpks(i))+dx, ys(Xpks(i))+dy, peaklist(i));
end

disp('Select the 9 peaks for calibration')
handles.SelectedPeaks = SelectedPeaks;
handles.Xpks = Xpks;
handles.wl = wl;
handles.h_list = h_list;
% handles.x = x;
handles.ys = ys;
guidata(hObject, handles);


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
% Test_Name = cellstr(get(hObject,'String'));
% index_selected{get(hObject,'Value')};
% handles.Test_Name=Test_Name(index_selected);

index_selected = get(hObject,'Value');
Test_Name = get(hObject,'String');
handles.Test_Name = Test_Name{index_selected};

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6

index_selected = get(hObject,'Value');
Probe_Name = get(hObject,'String');
handles.Probe_Name = Probe_Name{index_selected};
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7

index_selected = get(hObject,'Value');
Splitter_Name = get(hObject,'String');
handles.Splitter_Name = Splitter_Name{index_selected};
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version Famof MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
handles.wrapper.closeAllSpectrometers();
% f = msgbox("Close Wrappers");
delete(hObject);


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8
index_selected = get(hObject,'Value');
Fiber_Name = get(hObject,'String');
handles.Fiber_Name = Fiber_Name{index_selected};
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9

index_selected = get(hObject,'Value');
Sample_Name = get(hObject,'String');
handles.Sample_Name = Sample_Name{index_selected};
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
directoryname = uigetdir
handles.directoryname=directoryname;
get(hObject,'String')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
set(handles.edit7,'Value',val);

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



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
str=get(hObject,'String');
val=str2num(str);
set(handles.edit8,'Value',val);
threshold=handles.edit8.Value;
handles.threshold=threshold;
guidata(hObject, handles);

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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% todo: verify that more than 1 peaks are selected

fprintf('handles.PeakSelectionDone: %f\n', handles.PeakSelectionDone);

peakselected=handles.h_list.Value;
Xpks = handles.Xpks;
wl = handles.wl;
h_list = handles.h_list;
% x = handles.x;
ys = handles.ys;

Xps=[];
Xtwl=[];
Xps=wl(Xpks(h_list.Value));
Xtwl= handles.SelectedPeaks;

% fit the peak wavelengths to the true wavelengths
p=polyfit(Xps,Xtwl',3);
%calibrated wavelength axis X
X=polyval(p,wl);
 
handles.wavelengthcalibrationcoefficients=p;

%update the calibrated wavelengths 
handles.calibratedwavelength=X;
handles.wavelenghtcalibrationdone=true;
handles.PeakSelectionDone=true;
guidata(hObject, handles);

%write wavelengthcalibrationcoefficients to file
folder_name=['MeasuredSpectra','\',date];   % The sub-directory is named after the current date
save ([folder_name,'\Wavelengthcalibrationcoeff'],'p' )
 
 
% figure(11)
axes(handles.axes3);
cla(handles.axes3);
hold on
plot(wl, ys,'b')
plot(X, ys,'r')
% plot(x, Y,'sg')
hold off
 c=['original';
    'fit     '];
legend(c)
xlabel('Wavelength [nm]')
ylabel('Counts')
close(10)
 
