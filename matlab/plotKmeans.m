function plotKmeans ()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    hFigureHandle = generateFigure(13.12,5);
    %fDimensionsInCm = [ 8.5, 6 ];

    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    %cAudioPath = [cPath '/../audio'];
	cDatasetPath = 'd:\dataset\music_speech\'; 
  
    cMusic = 'Music';
    cSpeech = 'Speech';
    hist_axis = 0:.05:1;


    % read music data
    music_files     = dir([cDatasetPath 'music/*.au']);
    speech_files    = dir([cDatasetPath 'speech/*.au']);
 
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

    v = [v_music, v_speech];
    m = [0.437494,0.82097;0.474319,0.0431548];
    state = struct('m',m);
    aiIteration2Plot = [1 4 8];
    for (i = 1:9)
        [clusterIdx,state] = ToolSimpleKmeans(v, 2, 1,state);
        n = find(aiIteration2Plot == i);
        if ~isempty(n)
            subplot(1,length(aiIteration2Plot),n)
        else
            continue;
        end
       
        k = 1;
        scatter(state.m(1,k),state.m(2,k), iMarkerSize*4,[0 0 0],'filled','s');
        hold on;
        scatter(v(1,clusterIdx==k),v(2,clusterIdx==k), iMarkerSize,[0 0 0],'filled','o');
        
        k = 2;
        scatter(state.m(1,k),state.m(2,k), iMarkerSize*4,[234/256 170/256 0],'filled','s');
        scatter(v(1,clusterIdx==k),v(2,clusterIdx==k), iMarkerSize,[234/256 170/256 0],'filled','o');
        hold off;
        axis([0.04 1 0 .9]);
        text(.1,.85, ['iteration = ' num2str(i)]);
        set(gca,'XTickLabel',[],'YTickLabel',[]);
        set(gca,'visible','off');
        
    end
    %axis square;
%     xlabel('mean spectral centroid')
%     ylabel('std rms')
%     set(gca,'XTickLabel',[],'YTickLabel',[]);
    %scatter(v_speech(1,:),v_speech(2,:), iMarkerSize,[234/256 170/256 0],'filled','o');
    %res = hist_axis(2)-hist_axis(1);
    %legend(cMusic,cSpeech,'Location','NorthWest')

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