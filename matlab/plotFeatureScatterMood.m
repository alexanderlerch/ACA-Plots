function plotFeatureScatter(cDatasetPath)

    if (nargin<1)
        % this script is written for the Soundtracks dataset
        % this path needs to be edited
        cDatasetPath = 'D:\dataset\soundtracks\'; 
    end
    % check for dependencies
    if(exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    if (exist([cDatasetPath 'set1']) ~= 7)
        error('Dataset path wrong or does not contain set1 folders!')
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 5);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    [v, valen] = getData([cDatasetPath 'set1/']);

    iMarkerSize = 6;

    % plot
    subplot(121)
    scatter(v(1, :), v(2, :), iMarkerSize, valen(:, 1), 'filled', 'o')
    ylabel('$\sigma_\mathrm{RMS}$')
    xlabel('$\sigma_\mathrm{SC}$')
    set(gca, 'XTickLabel', [], 'YTickLabel', []);
    c = colorbar;
    c.Label.String = 'valence';
    axis([min(v(1, :)) max(v(1, :)) min(v(2, :)) max(v(2, :))])
    box on

    subplot(122)
    scatter(v(1, :), v(2, :), iMarkerSize, valen(:, 2), 'filled', 'o')
    c = colorbar;
    c.Label.String = 'energy';
    ylabel('$\sigma_\mathrm{RMS}$')
    xlabel('$\sigma_\mathrm{SC}$')
    set(gca, 'XTickLabel', [], 'YTickLabel', []);
    axis([min(v(1, :)) max(v(1, :)) min(v(2, :)) max(v(2, :))])
    box on

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [v, valen] = getData(cDatasetPath)

    % read valence data
    opts = detectImportOptions([cDatasetPath 'mean_ratings_set1.xls']);
    opts.SelectedVariableNames = [2:3]; 
    opts.DataRange = '2:361';    
    valen = readmatrix([cDatasetPath 'mean_ratings_set1.xls'], opts);

    % read music data
    files = dir([cDatasetPath 'mp3/Soundtrack360_mp3/*.mp3']);

    v = zeros(2, size(files, 1));
    for i = 1:size(files, 1)
        v(:, i) = ExtractFeaturesFromFile([files(i).folder '/' files(i).name]);
    end
end

function [v] = ExtractFeaturesFromFile(cFilePath)

    cFeatureNames = char('SpectralCentroid',...
    'TimeRms');

    [x, f_s] = audioread(cFilePath);
    x = x / max(abs(x));
    
    feature = ComputeFeature (deblank(cFeatureNames(1, :)), x, f_s);
    v(1, 1) = std(feature(1, :));
    
    feature = ComputeFeature (deblank(cFeatureNames(2, :)), x, f_s);
    v(2, 1) = std(feature(1, :));
 end