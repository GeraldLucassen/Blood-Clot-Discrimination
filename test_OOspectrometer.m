% Simple Code to access an OceanOptics Spectrometer from MATLAB
% It requires an installation of OmniDriver

% If the code does not work, you might have to do the following:
% Go to C:\Program Files\MATLAB\R2012a\toolbox\local (or similiar),
% open librarypath.txt, and add the OmniDriver path, e.g.
% C:\Program Files\Ocean Optics\OmniDriverSPAM\OOI_HOME (or similar),
% and, if open, restart MATLAB(!!!).
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
addpath('C:\Program Files\Ocean Optics\OmniDriver\OOI_HOME\');
% javaaddpath('C:\Program Files\Ocean Optics\OmniDriver\OOI_HOME\OmniDriver.jar');
import('com.oceanoptics.omnidriver.api.wrapper.Wrapper');
wrapper = Wrapper();
NoOfDevices = wrapper.openAllSpectrometers();

apiversion = wrapper.getApiVersion();

exception = wrapper.getLastException();

%% Some settings for device 0
wrapper.setIntegrationTime(0,50*1000); %1000 = 1ms
wrapper.setScansToAverage(0,10);

%% Get a spectrum from device 0 and plot it
wvl = wrapper.getWavelengths(0);
spectrum = wrapper.getSpectrum(0);
plot(wvl,spectrum)

%% Clean up
wrapper.closeAllSpectrometers();