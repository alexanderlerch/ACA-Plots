function plotFeaturespace (cDatasetPath)

    if (nargin<1)
        % this script is written for the GTZAN dataset
        % this path needs to be edited
        cDatasetPath = 'd:\dataset\music_speech\';  
    end

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    if ((exist([cDatasetPath 'music']) ~= 7) || (exist([cDatasetPath 'speech']) ~= 7))
        error('Dataset path wrong or does not contain music/speech folders!')
    end

    hFigureHandle = generateFigure(13.12,8);
    %fDimensionsInCm = [ 8.5, 6 ];

    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    %cAudioPath = [cPath '/../audio'];
	
  
    cMusic = 'music';
    cSpeech = 'speech';
    hist_axis = 0:.05:1;


    % read music data
    music_files     = dir([cDatasetPath cMusic '/*.au']);
    speech_files    = dir([cDatasetPath cSpeech '/*.au']);
 
    v_music         = zeros(2,size(music_files,1));
    v_speech        = zeros(2,size(speech_files,1)); 
    
    % assuming the same number of files in both directories....
    for (i=1:size(music_files,1))
        v_music(:,i)    = ExtractFeaturesFromFile([cDatasetPath 'music/' music_files(i).name]);
        v_speech(:,i)   = ExtractFeaturesFromFile([cDatasetPath 'speech/' speech_files(i).name]);
    end

    % normalization
    for (f = 1:size(v_music,1))
        minimum = min([v_music(f,:) v_speech(f,:)]);
        maximum = max([v_music(f,:) v_speech(f,:)]) - minimum;
        v_music(f,:) = (v_music(f,:)- minimum) / maximum;
        v_speech(f,:) = (v_speech(f,:)- minimum) / maximum;
    end
    
    iMarkerSize = 8;
    subplot(5,5,[6:9,11:14,16:19,21:24])
    scatter(v_music(1,:),v_music(2,:), iMarkerSize,[0 0 0],'filled','o');
    %axis square;
    xlabel('$\mu_\mathrm{SC}$')
    ylabel('$\sigma_\mathrm{RMS}$')
    set(gca,'XTickLabel',[],'YTickLabel',[]);
    hold on;
    scatter(v_speech(1,:),v_speech(2,:), iMarkerSize,[234/256 170/256 0],'filled','o');
    %res = hist_axis(2)-hist_axis(1);
    legend(cMusic,cSpeech,'Location','NorthWest')

    subplot(5,5,1:4)
    histogram(v_music(1,:),hist_axis)
    hold on;
    histogram(v_speech(1,:),hist_axis)
    axis([0 1 0 11])
    set(gca,'YTickLabel',{})
    set(gca,'XTickLabel',{})

    subplot(5,5,[10,15,20,25])
    histogram(v_music(2,:),hist_axis)
    hold on;
    histogram(v_speech(2,:),hist_axis)
    view([-270 -90])
    axis([0 1 0 24])
    set(gca,'YTickLabel',{})
    set(gca,'XTickLabel',{})

    printFigure(hFigureHandle, cOutputPath)
end

function [v] = ExtractFeaturesFromFile(cFilePath)

    cFeatureNames = char('SpectralCentroid',...
    'TimeRms');

    [x,fs]  = audioread(cFilePath);
    x       = x/max(abs(x));
    [X,f,tf]= spectrogram(x, hann(2048,'periodic'),1024,2048,fs);
    
    feature = ComputeFeature (deblank(cFeatureNames(1,:)), x, fs);
    v(1,1)    = mean(feature(1,:));
    
    feature = ComputeFeature (deblank(cFeatureNames(2,:)), x, fs);
    v(2,1)    = std(feature(1,:));
    
end    