% Simple Code to access an OceanOptics Spectrometer from MATLAB
% It requires an installation of OmniDriver

% If the code does not work, you might have to do the following:
% Go to C:\Program Files\MATLAB\R2012a\toolbox\local (or similiar),
% open librarypath.txt, and add the OmniDriver path, e.g.
% C:\Program Files\Ocean Optics\OmniDriverSPAM\OOI_HOME (or similar),
% and, if open, restart MATLAB(!!!).
% Attention: You may have to run Notepad as Admin (right click in the Start menue)
% Attention: Don't use clear!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 %
% The file might then look like this:
% ##
% ## FILE: librarypath.txt
% ##
% ## Entries:
% ##    o path_to_jnifile
% ##    o [alpha,glnx86,sol2,unix,win32,mac]=path_to_jnifile
% ##    o $matlabroot/path_to_jnifile
% ##    o $jre_home/path_to_jnifile
% ##
% $matlabroot/bin/$arch
% C:\Program Files\Ocean Optics\OmniDriverSPAM\OOI_HOME
%
%
% Have fun! Tim Rehm, 18.08.2014

%% Connect the spectrometer
if ~exist ('wrapper')
    addpath('C:\Program Files\Ocean Optics\OmniDriver\OOI_HOME\');
    addpath('.\Toolbox')
    addpath('C:\Users\nlv10962\OneDrive - Philips\Matlab\BloodClotDiscriminationNew\OceanOpticsMatlab\OmniDriver\');
    javaaddpath('C:\Program Files\Ocean Optics\OmniDriver\OOI_HOME\OmniDriver.jar');       
    import('com.oceanoptics.omnidriver.api.wrapper.Wrapper');
    wrapper = Wrapper();
end
NoOfDevices = wrapper.openAllSpectrometers();    
apiversion = wrapper.getApiVersion();    
exception = wrapper.getLastException();


%% Some settings for device 0
integration_time=50*1000; %1000 = 1ms
wrapper.setIntegrationTime(0,integration_time); 
wrapper.setScansToAverage(0,10);

%% Get a spectrum from device 0 
number_of_spectra=10;
wl = wrapper.getWavelengths(0)';
for ii=1:number_of_spectra
    spectrum_raw (ii,:) = wrapper.getSpectrum(0)';
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


%% Output plots
figure(1)
clf
plot(wl,spectrum_raw)
hold on
plot([min(wl),max(wl)],[dark_current,dark_current],'k:')
title('Spectrum raw')
xlabel('\lambda [nm]')
ylabel('Counts')


if exist('reference','var') % If  a white reference has been defined -> show the relative spectrum 
    figure(2)
    clf
    plot(wl,spectrum./reference)
    title('Spectrum/Reference')
    xlabel('\lambda [nm]')
    ylabel('Relative intensity')
end

if exist('blackreference','var') % If  a white reference has been defined -> show the relative spectrum 
    figure(3)
    clf
    plot(wl,(spectrum-blackreference)./(reference-blackreference))
    title('Spectrum-Black/Reference-Black')
    xlabel('\lambda [nm]')
    ylabel('Relative intensity')
    axis([400,950,0,1.5])
end

%% Store the spectrum
comment{1}='Phantom test';'Spectrometer test'; 
comment{2}='HMilch RT';'Water RT'; 'HMilch';'Cold Water';'Water';'Darkness'; 'LightSource'; 'HMilch+Mango';'HMilch+Red';  'Darkness';  'Intralipid+Red'; 'Intralipid'; 'Spectralon';  % Sample
comment{3}='GBF-01';'SM-02'; 'Black Needle (VIS-NIR)';'None';'Concept EPOTEC301'; 'NoProbe';'Concept1'; '100 micron fiber (Photonic Needle) 16 degree';'G1';  % Device'
comment{4}= 'New 105 micron FiberBundle';'No fiber splitter';'105 micron splitter (red=spectrometer)';'105 micron splitter (red=source)';'105 micron splitter (red=spectrometer)';'Circulator (blue=source)';'Old FiberBundle'; % Splitter
comment{5}=[char(datetime('now','Format','HH:mm:ss')),': ',comment{2}]; %'MAYAP11833';
timestamp=datetime;

folder_name=['MeasuredSpectra','\',char(datetime('today','Format','y-MMM-dd'))] %string(datetime('today','Format','y-MMM-dd'))];   % The sub-directory is named after the current date
[~, ~] = mkdir(folder_name);
[filename, filenumber] = nextname([folder_name,'\','OOSpectrum'],'00001','.mat');   % Use nextname to generate a unique filename
save ([folder_name,'\',filename],'wl', 'spectrum','spectrum_raw', 'spectrum_av', 'integration_time','comment','timestamp' )
['Saved as ',folder_name,'\',filename]

%% Plot changes
if isempty(findobj('type','figure','Number',100))
    figure(100)
    tracers=0;
    tracers_legend={};
end
figure(100)
hold on
plot(wl, mean(spectrum))
tracers=tracers+1;
tracers_legend{tracers}=[num2str(filenumber),': ',comment{5}];
legend(tracers_legend)
xlabel('\lambda [nm]')
ylabel('Counts')
title('History (raw data)')
xlim([200,1150])

%% Clean up
wrapper.closeAllSpectrometers();