function plotFeatureScatterPca(cDatasetPath)

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
    hFigureHandle = generateFigure(13.12, 12 ...
        );
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    iNumFeatures = 4; % only works for 2 or 4 atm
    [v, T, eigenvalues, class, classlabel, cFeatureLabels, cPcLabels] = getData(cDatasetPath, iNumFeatures);

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
    iNumPlots = ceil(iNumFeatures/2); % + 2; % two additional pca plots
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
        subplot(iNumXPlots+1, iNumYPlots, n)
        for i = 1:size(classlabel, 1)
            hold on;
            scatter(v(2*(n-1)+1, (i-1)*100+1:i*100), ...
                v(2*n, (i-1)*100+1:i*100), ...
                iMarkerSize, myColorMap(class((i-1)*100+1:i*100), :), 'filled', char(myShape(i,:)), 'MarkerEdgeColor', .85*myColorMap(i,:))
        end
        hold off;
        ylabel(deblank(cFeatureLabels(2*(n-1)+1, :)))
        xlabel(deblank(cFeatureLabels(2*n, :)))
        set(gca, 'XTickLabel', [], 'YTickLabel', []);
        hold on;
        axis([-3 3 -3 3]); % 3 stds
        box on
    end
    subplot(iNumXPlots+1, iNumYPlots, iNumPlots+1);
    imagesc(abs(T)')
    set(gca, "XTick", [1:size(T', 1)])
    set(gca, "YTick", [1:size(T', 2)])
    set(gca, "XTickLabel", cFeatureLabels)
    set(gca, "YTickLabel", cPcLabels)

    xlabel('feature')
    ylabel('component');
    subplot(iNumXPlots+1, iNumYPlots, iNumPlots+2);
    plot(eigenvalues)
        grid on
    hold on; 
    plot(ones(1, size(v, 1)), 'Color', getAcaColor('mediumgray')); 
    hold off;
    xlabel('component')
    ylabel('eigenvalue');
    set(gca, 'XTick', 1:length(eigenvalues))
    axis([1 length(eigenvalues) 0 max(eigenvalues)+.1 ])

    % legend(classlabel, 'Location', 'NorthEastOutside')

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [pc, T, eigenvalues, class, classlabel, cFeatureLabels, cPcLabels] = getData(cDatasetPath, iNumFeatures)

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
    classlabel = classlabel(2:end, :);

    % override feature labels for pca
    cPcLabels = char('$pc_\mathrm{1}$',...
    '$pc_\mathrm{2}$',...
    '$pc_\mathrm{3}$',...
    '$pc_\mathrm{4}$');

    % z-score normalization
    v = diag(1./std(v, [], 2)) * (v - mean(v, 2));

    % compute principal components
    [pc, T, eigenvalues] = ToolPca(v);

    % normalize pca output for plotting
    pc = diag(1./std(pc, [], 2)) * pc;

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