function plotFeatureScatter(cDatasetPath)

    if (nargin<1)
        % this script is written for the GTZAN dataset
        % this path needs to be edited
        cDatasetPath = 'D:\dataset\GTZAN\genres/'; 
    end
    % check for dependencies
    if(exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    if ((exist([cDatasetPath 'blues']) ~= 7) || (exist([cDatasetPath 'rock']) ~= 7))
        error('Dataset path wrong or does not contain music/speech folders!')
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 8);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    [v, class, classlabel] = getData(cDatasetPath);

    iMarkerSize = 6;
    myColorMap = [ 0       0           0
                    234/256 170/256     0
                    0       0           1
                    1       0           0
                    0       0.5         0
                    0       0.75        0.75
                    0.75    0           0.75
                    0.75    0.75        0
                    0.25    0.25        0.25
                    .33     .66         1];

    % plot
    for i = 1:size(classlabel, 1)
        hold on;
        scatter(v(1, (i-1)*100+1:i*100), v(2, (i-1)*100+1:i*100), iMarkerSize, myColorMap(class((i-1)*100+1:i*100), :), 'filled', 'o')
    end
    hold off;
    ylabel('$\sigma_\mathrm{RMS}$')
    xlabel('$\sigma_\mathrm{SC}$')
    set(gca, 'XTickLabel', [], 'YTickLabel', []);
    hold on;
    legend(classlabel, 'Location', 'NorthEast')
    axis([min(v(1, :)) 1275 min(v(2, :)) 12.1])
    box on

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [v, class, classlabel] = getData(cDatasetPath)

    % read music data
    files = dir([cDatasetPath '/**/*.wav']);
 
    v_music = zeros(2, 1000);
    class = ones(1, 100);
    for i = 2:10
        class = [class i*ones(1, 100)];
    end
    classlabel = [];
    
    % assuming the same number of files in both directories....
    for i = 1:size(files, 1)
        v(:, i) = ExtractFeaturesFromFile([files(i).folder '/' files(i).name]);
        if (~mod(i-1, 100))
            [path, genre, dummy] = fileparts(files(i).folder);
            classlabel = char(classlabel,genre);
        end
    end
    classlabel = classlabel(2:end, :);
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