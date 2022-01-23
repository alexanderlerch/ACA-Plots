function plotSequentialForwardSelection(cDatasetPath)

    % check dependencies
    if (nargin<1)
        % this script is written for the GTZAN music/speech dataset
        % modify this path or use the function parameter to specify your
        % dataset path
        cDatasetPath = 'd:\dataset\music_speech\'; 
    end
    if (exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    if ((exist([cDatasetPath 'music']) ~= 7) || (exist([cDatasetPath 'speech']) ~= 7))
        error('Dataset path wrong or does not contain music/speech folders!')
    end
    
    % generate new figure
    hFigureHandle = generateFigure(13.12, 4);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % generate data
    [Acc, selectedFeatures, cFeatureLabels] = getData(cDatasetPath);

    % plot
    plot(Acc)
    xlabel('\# of Features')
    ylabel('classification accuracy')  
    axis([1 length(selectedFeatures) 0.85 1.01])
    a = gca;
    a.Position(3) = 0.7;
    cFeatureLabels = char('\textbf{Top 10 Features}', cFeatureLabels);
    annotation('textbox', [0.84, 0.83, 0.1, 0.1], 'String', cFeatureLabels([1 selectedFeatures(1:10)+1], :), 'FontSize',6.5, 'EdgeColor', [1 1 1], 'FitBoxToText', 'on', 'Interpreter', 'latex');

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [Acc, selectedFeatures, cFeatureLabels] = getData(cDatasetPath)
    
    iNumFeatures = 62;
    
    % read list of files
    music_files = dir([cDatasetPath 'music/*.au']);
    speech_files = dir([cDatasetPath 'speech/*.au']);
 
    v_music = zeros(iNumFeatures,size(music_files, 1));
    v_speech = zeros(iNumFeatures,size(speech_files, 1)); 
    
    % this may take a while...
    for i = 1:size(music_files, 1)
        [v_music(:,i), cFeatureLabels] = ExtractFeaturesFromFile([cDatasetPath 'music/' music_files(i).name]);
    end
    for i = 1:size(speech_files, 1)
        [v_speech(:,i), cFeatureLabels] = ExtractFeaturesFromFile([cDatasetPath 'speech/' speech_files(i).name]);
    end

    % normalize
    v = [v_music, v_speech];
    m = mean(v, 2);
    s = std(v, 0, 2);
    
    v = (v - repmat(m, 1,size(music_files, 1)+size(speech_files, 1))) ./ repmat(s, 1, size(music_files, 1)+size(speech_files, 1));
    C = [zeros(1, size(music_files, 1)) ones(1,size(speech_files, 1))];

    %select features
    [selectedFeatures, Acc] =  ToolSeqFeatureSel(v, C);
end

function [v, cFeatureLabels] = ExtractFeaturesFromFile(cFilePath)

    cFeatureNames = char('SpectralCentroid',...
        'SpectralCrestFactor',...
        'SpectralDecrease',...
        'SpectralFlatness',...
        'SpectralFlux',...
        'SpectralKurtosis',...
        'SpectralMfccs',...
        'SpectralRolloff',...
        'SpectralSkewness',...
        'SpectralSlope',...
        'SpectralSpread',...
        'SpectralTonalPowerRatio',...
        'TimeAcfCoeff',...
        'TimeMaxAcf',...
        'TimePeakEnvelope',...
        'TimeRms',...
        'TimeZeroCrossingRate');

    cFeatureAbbrev = char('SC',...
        'Tsc',...
        'SD',...
        'Tf',...
        'SF',...
        'SK',...
        'MFCC',...
        'SR',...
        'SSk',...
        'SSl',...
        'SS',...
        'Tpr',...
        'ACF',...
        'Ta',...
        'Peak',...
        'RMS',...
        'ZC');

    cSubFeatureNames = char('$\mu_\mathrm{', '$\sigma_\mathrm{');
 
    % read audio
    [x, f_s] = audioread(cFilePath);
 
    % extract features
    cFeatureLabels = [];
    v = [];
    for i = 1:size(cFeatureNames, 1)
        feature = ComputeFeature(deblank(cFeatureNames(i, :)), x, f_s);
        v = [v; mean(feature, 2); std(feature, 0, 2)];
        if (size(feature, 1) == 1)
            cFeatureLabels = char(cFeatureLabels, ...
                [deblank(cSubFeatureNames(1, :)) deblank(cFeatureAbbrev(i, :)) '}$'], ...
                [deblank(cSubFeatureNames(2, :)) deblank(cFeatureAbbrev(i, :)) '}$']);
        else
            for j = 1:size(feature, 1)
                cFeatureLabels = char(cFeatureLabels, ...
                    [deblank(cSubFeatureNames(1, :)) deblank(cFeatureAbbrev(i, :)) ', ' num2str(j-1) '}$']);
            end
            for j = 1:size(feature, 1)
                cFeatureLabels = char(cFeatureLabels, ...
                    [deblank(cSubFeatureNames(2, :)) deblank(cFeatureAbbrev(i, :)) ', ' num2str(j-1) '}$']);
            end
        end
    end
    cFeatureLabels = cFeatureLabels(2:end, :);
end
