function plotKnn ()

    if (nargin<1)
        % this script is written for the GTZAN dataset
        % this path needs to be edited
        cDatasetPath = 'd:\dataset\music_speech\';  
    end

    % check for dependency
    if(exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    if ((exist([cDatasetPath 'music']) ~= 7) || (exist([cDatasetPath 'speech']) ~= 7))
        error('Dataset path wrong or does not contain music/speech folders!')
    end
    fDimensionsInCm = [8.5, 6];

    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
  
    cMusic = 'music';
    cSpeech = 'speech';

    % generate new figure
    hFigureHandle = generateFigure(fDimensionsInCm(1), fDimensionsInCm(2));

    % read music data
    music_files = dir([cDatasetPath 'music/*.au']);
    speech_files = dir([cDatasetPath 'speech/*.au']);
 
    v_music = zeros(2, size(music_files, 1));
    v_speech = zeros(2, size(speech_files, 1)); 
    
    % assuming the same number of files in both directories....
    for (i=1:size(music_files, 1))
        v_music(:, i) = ExtractFeaturesFromFile([cDatasetPath 'music/' music_files(i).name]);
        v_speech(:, i) = ExtractFeaturesFromFile([cDatasetPath 'speech/' speech_files(i).name]);
    end

    % normalization
    for (f = 1:size(v_music, 1))
        minimum = min([v_music(f, :) v_speech(f, :)]);
        maximum = max([v_music(f, :) v_speech(f, :)]) - minimum;
        v_music(f, :) = (v_music(f, :) - minimum) / maximum;
        v_speech(f, :) = (v_speech(f, :) - minimum) / maximum;
    end
    
    iMarkerSize = 8;
    scatter(v_music(1, :), v_music(2, :), iMarkerSize, getAcaColor('darkgray'), 'filled', 'o', 'MarkerEdgeColor', getAcaColor('darkgray', true));
    box on;
    set(gca, 'XTickLabel', [], 'YTickLabel', []);
    hold on;
    scatter(v_speech(1, :), v_speech(2, :), iMarkerSize, getAcaColor('main', true), 'filled', 'd', 'MarkerEdgeColor', getAcaColor('main', true));
    
    % test data
    query = [.32 .281];
    scatter(query(1), query(2), iMarkerSize+4, getAcaColor('gt'), 'filled', 's', 'MarkerEdgeColor', getAcaColor('gt', true));
    scatter(query(1), query(2), 3100, getAcaColor('lightgray'), 'o');
    text(.31, .25, '$k=3$', 'Color', getAcaColor('main'))
    scatter(query(1), query(2), 5000, getAcaColor('lightgray'), 'o');
    text(.31, .19, '$k=5$', 'Color', getAcaColor('darkgray'))
    scatter(query(1), query(2), 6650, getAcaColor('lightgray'), 'o');
    text(.35, .17, '$k=7$', 'Color', getAcaColor('darkgray'))
    legend(cMusic,cSpeech, 'query', 'Location', 'NorthWest')
    axis([query(1)-.1 query(1)+.1 query(2)-.2 query(2)+.2]);

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [v] = ExtractFeaturesFromFile(cFilePath)

    cFeatureNames = char('SpectralCentroid',...
        'TimeRms');

    % read audio
    [x, f_s] = audioread(cFilePath);
    x = x / max(abs(x));
    
    % extract features and aggregate
    feature = ComputeFeature (deblank(cFeatureNames(1, :)), x, f_s);
    v(1, 1) = mean(feature(1, :));
    
    feature = ComputeFeature (deblank(cFeatureNames(2, :)), x, f_s);
    v(2, 1) = std(feature(1, :));
end    