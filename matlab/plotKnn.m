function plotKnn ()

    if (nargin<1)
        % this script is written for the GTZAN dataset
        % this path needs to be edited
        cDatasetPath = 'd:\dataset\music_speech\';  
    end

    % check for dependency
    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    if ((exist([cDatasetPath 'music']) ~= 7) || (exist([cDatasetPath 'speech']) ~= 7))
        error('Dataset path wrong or does not contain music/speech folders!')
    end
    fDimensionsInCm = [ 8.5, 6 ];

    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
  
    cMusic = 'music';
    cSpeech = 'speech';
    hist_axis = 0:.05:1;

    % generate new figure
    hFigureHandle = generateFigure(fDimensionsInCm(1), fDimensionsInCm(2));

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
    scatter(v_music(1,:),v_music(2,:), iMarkerSize,[0 0 0],'filled','o');
    axis([.2 .4 0.05 .45]);
    box on;
    set(gca,'XTickLabel',[],'YTickLabel',[]);
    hold on;
    scatter(v_speech(1,:),v_speech(2,:), iMarkerSize,[234/256 170/256 0],'filled','o');
    
    % test data
    test = [.32 .28];
    scatter(test(1),test(2), iMarkerSize+4,'r','filled','o');
    scatter(test(1),test(2), 3100,[.5 .5 .5],'o');
    text(.31, .25,'$k=3$','Color',[234/256 170/256 0])
    scatter(test(1),test(2), 5000,[.5 .5 .5],'o');
    text(.32, .19,'$k=5$','Color',[0 0 0])
    scatter(test(1),test(2), 6600,[.5 .5 .5],'o');
    text(.35, .17,'$k=7$','Color',[0 0 0])

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [v] = ExtractFeaturesFromFile(cFilePath)

    cFeatureNames = char('SpectralCentroid',...
    'TimeRms');

    % read audio
    [x,fs]  = audioread(cFilePath);
    x       = x/max(abs(x));
    
    % spectrogram
    [X,f,tf]= spectrogram(x, hann(2048,'periodic'),1024,2048,fs);
    
    % extract features and aggregate
    feature = ComputeFeature (deblank(cFeatureNames(1,:)), x, fs);
    v(1,1)    = mean(feature(1,:));
    
    feature = ComputeFeature (deblank(cFeatureNames(2,:)), x, fs);
    v(2,1)    = std(feature(1,:));
end    