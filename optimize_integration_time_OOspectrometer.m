% Simple Code to access an OceanOptics Spectrometer from MATLAB
% It requires an installation of OmniDriver

% If the code does not work, you might have to do the following:
% Go to C:\Program Files\MATLAB\R2012a\toolbox\local (or similiar),
% open librarypath.txt, and add the OmniDriver path, e.g.
% Automaticall optimze integration time
%
%
%C:\Program Files\Ocean Optics\OmniDriverSPAM\OOI_HOME (or similar),
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

%% Settings
max_steps=10;       % Maximum number of iteration steps
min_intime=6;      % Minimal integration time [ms]
max_intime=500;     % Maximum integration time
start_intime=20;
min_count_range=50000;  % The routine will try to find an integration time that has a count maximum >=min_count_range and <= max_count_range
max_count_range=60000;



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
wrapper.setScansToAverage(0,10);
wl = wrapper.getWavelengths(0)';

%% Iteration
optimum_intime=start_intime;
for step=1:max_steps
    wrapper.setIntegrationTime(0,optimum_intime*1000); 
    spectrum  = wrapper.getSpectrum(0)';
    optimum_intime
    measured_maximum=max(spectrum)
    if measured_maximum>max_count_range  % If the count is too high ...
        if optimum_intime>2*min_intime  % Half integration time ... if possible ... or set to min_intime
            optimum_intime=ceil(optimum_intime/2);
        else
            optimum_intime=min_intime;
        end
    elseif measured_maximum<min_count_range  % If the  count is too low
        correction_factor=((max_count_range+min_count_range)/2)/measured_maximum     % I try to guestimate the correction factor
        optimum_intime=ceil(optimum_intime*correction_factor);
        if optimum_intime>max_intime
            optimum_intime=max_intime;    % But make sure not to exceed the  maximum integration time
        end
    else    % Otherwise the optimum range has been reached already
        break
    end
end

if measured_maximum>max_count_range || measured_maximum<min_count_range
    'Optimization failed'
    % optimum_intime=NaN;
else
    'Optimization successfull'
    optimum_intime
end

%% Determine linearity
ceil((optimum_intime-min_intime)/4)
time_steps=[min_intime:ceil((optimum_intime-min_intime)/4):optimum_intime,optimum_intime]

figure(43)
clf
hold on
figure(44)
clf
hold on
leg={};
spectrum_av=[];
for ii=1:length(time_steps)

    number_of_spectra=10;
    wrapper.setIntegrationTime(0,time_steps(ii)*1000); 
    for jj=1:number_of_spectra
        spectrum (jj,:) = wrapper.getSpectrum(0)';
    end
    spectrum_av(ii,:)=mean(spectrum);
    figure(43)
    plot(wl, spectrum_av(ii,:))
    leg{ii}=[num2str(time_steps(ii)),' ms'];
    legend(leg)
    figure(44)
    plot(wl, spectrum_av(ii,:)./spectrum_av(1,:))
end
figure(43)
xlim([min(wl),max(wl)])
xlabel('Wavelength [nm]')
ylabel('Counts #')
figure(44)
xlim([min(wl),max(wl)])
xlabel('Wavelength [nm]')
ylabel('Relative intensity')
legend(leg)

%% Subtract dark current
figure(44)
clf
hold on
for ii=1:size(spectrum_av,1)
    dark_current(ii)=mean(spectrum_av(ii,wl>220 & wl<380));
    spectrum_raw(ii,:)=spectrum_av(ii,:);
    spectrum_av(ii,:)=spectrum_av(ii,:)-dark_current(ii);  % I subtract the dark current
    figure(44)
    plot(wl, spectrum_av(ii,:)./spectrum_av(1,:))
end
xlabel('Wavelength [nm]')
ylabel('Relative intensity')
legend(leg)

%% Linearity plots)
colors={'ro','bo','ko','go','co','mo','yo','rx','bx','kx','gx','cx','mx','yx'};
wl_diff=10;   
figure(45)
clf
hold on
leg2={};
for center_wl=200:100:1100
    averaged_intensity=mean(spectrum_av(:,wl>=(center_wl-wl_diff) & wl<=(center_wl+wl_diff)),2);
    plot(time_steps,averaged_intensity,[colors{length(leg2)+1}])    
    mdl=fitlm(time_steps,averaged_intensity);
    intercept=table2array(mdl.Coefficients(1,1));
    slope=table2array(mdl.Coefficients(2,1));
    plot([0,max(time_steps)],[intercept,intercept+max(time_steps)*slope],colors{length(leg2)+1}(1),'HandleVisibility','off')
    leg2{length(leg2)+1}=num2str(center_wl);

end
legend(leg2)
xlim([0,max(time_steps)])
ylabel('Counts #')
xlabel('integration time [ms]')
title('Lines are linear interpolations')

%% Intercept & Slope for each wavelengths
for ii=1:length(wl)
    averaged_intensity=spectrum_av(:,ii);
    mdl=fitlm(time_steps,averaged_intensity);
    intercept_wl(ii)=table2array(mdl.Coefficients(1,1));
    slope_wl(ii)=table2array(mdl.Coefficients(2,1));
end

figure(77)
clf
plot(wl,intercept_wl)
xlabel('Wavelength (nm')
ylabel('Intecept [counts]')
xlim([min(wl),max(wl)])
figure(78)
clf
plot(wl,slope_wl)
xlabel('Wavelength (nm')
ylabel('Slope [counts/ms]')
xlim([min(wl),max(wl)])
         
%% Clean up
wrapper.closeAllSpectrometers();

%% Write data
folder_name=['MeasuredSpectra\Calibration\']; %string(datetime('today','Format','y-MMM-dd'))];   % The sub-directory is named after the current date
[filename, filenumber] = nextname([folder_name,'\','Linearity'],'00001','.mat');   % Use nextname to generate a unique filename
save ([folder_name,'\',filename],'wl', 'spectrum_av','integration_time','time_steps','timestamp', 'optimum_intime','intercept_wl','slope_wl', 'spectrum_raw', 'dark_current' )
['Saved as ',folder_name,'\',filename]