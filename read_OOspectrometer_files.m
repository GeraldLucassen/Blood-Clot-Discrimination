% Read in all the spectra from a given dtae(folder

folder_name='MeasuredSpectra\27-Oct-2022\'; 'MeasuredSpectra\26-Oct-2022\'; 
for ii=1:99999
    filename=['.\',folder_name,'OOSpectrum',num2str(ii,'%05d'),'.mat'];
    if isfile(filename)
        ii
        load(filename)
        spectra_av(ii,:)=mean(spectrum);
        sample{ii}=comment{2};
        device{ii}=comment{3};
        device{ii}=strrep(device{ii},'100 micron fiber (Photonic Needle) 16 degree', '100\mu,16°');   % Shorten device names 
        splitter{ii}=comment{4}; 
        device_splitter_combination{ii}=[device{ii},'+',splitter{ii}]
    else
        break
    end
end

% House keeping
unique_samples=unique(sample,'stable');
unique_device_splitter_combinations=unique(device_splitter_combination,'stable');

% Determine white and black reference for each device splitter combination
for jj=1:length(unique_device_splitter_combinations)
    mask=ismember(sample, 'Milk')& ismember(device_splitter_combination, unique_device_splitter_combinations{jj});  % I use Milk for the white reference
    wr=mean(spectra_av(mask,:)); % I average over all Milk spectra
    mask=ismember(device_splitter_combination, unique_device_splitter_combinations{jj});
    white_ref(mask,:)=repmat(wr, sum(mask),1);
    
    mask=ismember(sample, 'Water')& ismember(device_splitter_combination, unique_device_splitter_combinations{jj});  % I use Water for the black reference
    wr=mean(spectra_av(mask,:)); % I average over all Water spectra
    mask=ismember(device_splitter_combination, unique_device_splitter_combinations{jj});
    black_ref(mask,:)=repmat(wr, sum(mask),1);
    
end


%% Plotting
colors={'r','b','k','g','c','m','y'};
lines={'-.','-',':','--'};

%% Per sample
%% Absolute
for ii=1:length(unique_samples)
    figure(ii)
    clf
    leg={};
    counter=1;
    for jj=1:length(unique_device_splitter_combinations)
        mask=ismember(sample, unique_samples{ii})& ismember(device_splitter_combination, unique_device_splitter_combinations{jj});
        if sum(mask)>0  % Only plot combinations that exist
            plot([-1,-1],[-0,-0],colors{counter}) % Dummy plot to get the labels right
            hold on
            plot(wl, spectra_av(mask,:),colors{counter},'HandleVisibility','off')
            leg{length(leg)+1}=unique_device_splitter_combinations{jj};
            counter=counter+1;
        end
    end
    title(['Raw spectra: ',unique_samples{ii}])
    legend(leg)
    xlabel('\lambda [nm]')
    ylabel('Counts')
    xlim([200,1100])
    
end

%% With white reference
for ii=1:length(unique_samples)
    figure(ii)
    clf
    leg={};
    counter=1;
    for jj=1:length(unique_device_splitter_combinations)
        mask=ismember(sample, unique_samples{ii})& ismember(device_splitter_combination, unique_device_splitter_combinations{jj});
        if sum(mask)>0  % Only plot combinations that exist
            plot([-1,-1],[-0,-0],colors{counter}) % Dummy plot to get the labels right
            hold on
            plot(wl, spectra_av(mask,:)./white_ref(mask,:),colors{counter},'HandleVisibility','off')
            leg{length(leg)+1}=unique_device_splitter_combinations{jj};
            counter=counter+1;
        end
    end
    title(['Calibrated Spectra(WhiteRef): ',unique_samples{ii}])
    legend(leg)
    xlabel('\lambda [nm]')
    ylabel('Relative Intensity')
    xlim([200,1100])
    
end

%% With white-black reference
for ii=1:length(unique_samples)
    figure(ii)
    clf
    leg={};
    counter=1;
    for jj=1:length(unique_device_splitter_combinations)
        mask=ismember(sample, unique_samples{ii})& ismember(device_splitter_combination, unique_device_splitter_combinations{jj});
        if sum(mask)>0  % Only plot combinations that exist
            plot([-1,-1],[-0,-0],colors{counter}) % Dummy plot to get the labels right
            hold on
            plot(wl, (spectra_av(mask,:)-black_ref(mask,:))./(white_ref(mask,:)-black_ref(mask,:)),colors{counter},'HandleVisibility','off')
            leg{length(leg)+1}=unique_device_splitter_combinations{jj};
            counter=counter+1;
        end
    end
    title(['Calibrated Spectra(White+Black Ref): ',unique_samples{ii}])
    legend(leg)
    xlabel('\lambda [nm]')
    ylabel('Relative Intensity')
    xlim([200,1100])
    
end
        
%% Per device_splitter_combination
%% Absolute

for jj=1:length(unique_device_splitter_combinations)
    figure(jj)
    clf
    leg={};
    counter=1;
    for ii=1:length(unique_samples)
        mask=ismember(sample, unique_samples{ii})& ismember(device_splitter_combination, unique_device_splitter_combinations{jj});
        if sum(mask)>0  % Only plot combinations that exist
            plot([-1,-1],[-0,-0],colors{counter}) % Dummy plot to get the labels right
            hold on
            plot(wl, spectra_av(mask,:),colors{counter},'HandleVisibility','off')
            leg{length(leg)+1}=unique_samples{ii}
            counter=counter+1;
        end
    end
    title(['Raw spectra:  ',unique_device_splitter_combinations{jj}])
    legend(leg)
    xlabel('\lambda [nm]')
    ylabel('Relative Intensity')
    xlim([200,1100])
    1+1

end


%% With white reference

for jj=1:length(unique_device_splitter_combinations)
    figure(jj)
    clf
    leg={};
    counter=1;
    for ii=1:length(unique_samples)
        mask=ismember(sample, unique_samples{ii})& ismember(device_splitter_combination, unique_device_splitter_combinations{jj});
        if sum(mask)>0  % Only plot combinations that exist
            plot([-1,-1],[-0,-0],colors{counter}) % Dummy plot to get the labels right
            hold on
            plot(wl, spectra_av(mask,:)./white_ref(mask,:),colors{counter},'HandleVisibility','off')
            leg{length(leg)+1}=unique_samples{ii}
            counter=counter+1;
        end
    end
    title(['Calibrated Spectra(WhiteRef): ',unique_device_splitter_combinations{jj}])
    legend(leg)
    xlabel('\lambda [nm]')
    ylabel('Relative Intensity')
    xlim([200,1100])
    1+1

end
    

