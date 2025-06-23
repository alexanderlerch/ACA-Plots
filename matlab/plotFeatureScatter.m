function plotFeatureScatter(cDatasetPath)

    if (nargin<1)
        % this script is written for the GTZAN dataset
        % this path needs to be edited
        cDatasetPath = 'D:\datasets\dataset-gtzan\genres/'; 
    end
    % check for dependencies
    if(exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    if ((exist([cDatasetPath 'blues']) ~= 7) || (exist([cDatasetPath 'rock']) ~= 7))
        error('Dataset path wrong or does not contain expected folders!')
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 7);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    iNumFeatures = 4; % only works for 2 or 4 atm
    [v, class, classlabel, cAxisLabel] = getData(cDatasetPath, iNumFeatures);

    iMarkerSize = 6;
    myColorMap = [  getAcaColor('black')
                    getAcaColor('main')
                    getAcaColor('blue')
                    getAcaColor('gt')
                    getAcaColor('lightgray')
                             1                         0                         0
                             0                       0.5                         0
                             0                      0.75                      0.75
                    getAcaColor('mediumgray')
                    getAcaColor('lightgray')];

    myShape = char('o', 'o', 'd', 'd', 's', 's', 'o','s', 'd', 'o');
    % plot
    iNumPlots = ceil(iNumFeatures/2);
    iNumXPlots = floor(sqrt(iNumPlots));
    iNumYPlots = floor(sqrt(iNumPlots));
    while (iNumXPlots*iNumYPlots < iNumPlots)
        if iNumYPlots < iNumXPlots
            iNumXPlots = iNumXPlots + 1;
        else
            iNumYPlots = iNumYPlots + 1;
        end
    end
    for n=1:iNumPlots
        subplot(iNumXPlots, iNumYPlots, n)
        for i = 1:size(classlabel, 1)
            hold on;
            scatter(v(2*(n-1)+1, (i-1)*100+1:i*100), ...
                v(2*n, (i-1)*100+1:i*100), ...
                iMarkerSize, myColorMap(class((i-1)*100+1:i*100), :), 'filled', char(myShape(i,:)), 'MarkerEdgeColor', .85*myColorMap(i,:))
        end
        hold off;
        ylabel(deblank(cAxisLabel(2*(n-1)+1, :)))
        xlabel(deblank(cAxisLabel(2*n, :)))
        set(gca, 'XTickLabel', [], 'YTickLabel', []);
        hold on;
        axis([-3 3 -3 3]); % 3 stds
        box on
    end
    % legend(classlabel, 'Location', 'SouthEast')


    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [v, class, classlabel, cFeatureLabels] = getData(cDatasetPath, iNumFeatures)

    % read music data
    files = dir([cDatasetPath '/**/*.wav']);

    v = zeros(iNumFeatures, size(files, 1));
    class = ones(1, 100);
    for i = 2:10
        class = [class i*ones(1, 100)];
    end
    classlabel = [];
    
    % assuming the same number of files in both directories....
    for i = 1:size(files, 1)
        [v(:, i), cFeatureLabels(:,:)] = ExtractFeaturesFromFile([files(i).folder '/' files(i).name], iNumFeatures);
        if (~mod(i-1, 100))
            [path, genre, dummy] = fileparts(files(i).folder);
            classlabel = char(classlabel,genre);
        end
    end

    % z-score normalization
    v = diag(1./std(v, [], 2)) * (v - mean(v, 2));

    classlabel = classlabel(2:end, :);
end

function [v, cFeatureLabels] = ExtractFeaturesFromFile(cFilePath, iNumFeatures)

    cFeatureNames = char('SpectralCentroid',...
    'TimeRms',...
    'TimeZeroCrossingRate',...
    'SpectralRolloff');
    cFeatureLabels = char('$\mu_\mathrm{SC}$',...
    '$\mu_\mathrm{RMS}$',...
    '$\mu_\mathrm{ZC}$',...
    '$\mu_\mathrm{SR}$');

    [x, f_s] = audioread(cFilePath);
    x = x / max(abs(x));
    
    for i = 1:iNumFeatures
        feature = ComputeFeature (deblank(cFeatureNames(i, :)), x, f_s);
        v(i, 1) = mean(feature(1, :));
    end
end