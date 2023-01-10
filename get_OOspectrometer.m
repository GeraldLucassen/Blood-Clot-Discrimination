% Simple Code to access an OceanOptics Spectrometer from MATLAB
% It requires an installation of OmniDriver

% If the code does not work, you might have to do the following:
% Go to C:\Program Files\MATLAB\R2012a\toolbox\local (or similiar),
% open librarypath.txt, and add the OmniDriver path, e.g.
% C:\Program Files\Ocean Optics\OmniDriverSPAM\OOI_HOME (or similar),
% and, if open, restart MATLAB(!!!).
% Attention: You may have to run Notepad as Admin (right click in the Start menue)
% Attention: Don't use clear!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% It will delete the path
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
integration_time=20*1000; %1000 = 1ms
wrapper.setIntegrationTime(0,integration_time); 
wrapper.setScansToAverage(0,10);

%% Get a spectrum from device 0 and plot it
number_of_spectra=10;
wl = wrapper.getWavelengths(0)';
for ii=1:number_of_spectra
    spectrum (ii,:) = wrapper.getSpectrum(0)';
end
figure(1)
clf
plot(wl,spectrum)
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


%% Store the spectrum
comment{1}='Phantom test';
comment{2}='Water';'Milk+Red';'Milk';   'Spectralon';   
comment{3}='NoProbe'; '100 micron fiber (Photonic Needle) 16 degree';'G1';
comment{4}='New 105 micron FiberBundle';'105 micron splitter (white=spectrometer)';'105 micron splitter (red=spectrometer)';'Circulator (blue=source)';'Old FiberBundle';
timestamp=datetime;

folder_name=['MeasuredSpectra','\',date];   % The sub-directory is named after the current date
[~, ~] = mkdir(folder_name);
filename = nextname([folder_name,'\','OOSpectrum'],'00001','.mat');   % Use nextname to generate a unique filename
save ([folder_name,'\',filename],'wl', 'spectrum','integration_time','comment','timestamp' )
['Saved as ',folder_name,'\',filename]

%% Clean up
wrapper.closeAllSpectrometers();