function plotPcaClassification(cDatasetPath)

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
    iNumFeatures = 4; 
    [fAcc, cFeatureLabels, cPcLabels] = getData(cDatasetPath, iNumFeatures);

    % plot
    subplot(211)
    b = bar(cellstr(cFeatureLabels), fAcc(:, 1)')
    ylim([0 .4]); 
    ylabel('accuracy')
    box on

    subplot(212)
    b = bar(cellstr(cPcLabels), fAcc(:, 2)')
    ylim([0 .4]); 
    ylabel('accuracy')
    box on


    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [acc, cFeatureLabels, cPcLabels] = getData(cDatasetPath, iNumFeatures)

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

    % z-score normalization
    v = diag(1./std(v, [], 2)) * (v - mean(v, 2));

    % compute principal components
    [pc, T, eigenvalues] = ToolPca(v);

    % normalize principal components for classification
    pc = diag(1./std(pc, [], 2)) * pc;

    % run classification
    acc = zeros(iNumFeatures+1, 2);
    iNumFeatures = size(pc, 1);
    for i = 1:iNumFeatures
        [acc(i, 1), dummy] = ToolLooCrossVal(v(i,:), class-1);
        [acc(i, 2), dummy] = ToolLooCrossVal(pc(i,:), class-1);
    end
    [acc(iNumFeatures+1, 1), dummy] = ToolLooCrossVal(v, class-1);
    cFeatureLabels = [char(cFeatureLabels,'all')];
    [acc(iNumFeatures+1, 2), dummy] = ToolLooCrossVal(pc, class-1);    
    cPcLabels = char('$pc_\mathrm{1}$',...
    '$pc_\mathrm{2}$',...
    '$pc_\mathrm{3}$',...
    '$pc_\mathrm{4}$',...
    'all');


end

function [v, cFeatureLabels] = ExtractFeaturesFromFile(cFilePath, iNumFeatures)

    cFeatureNames = char('SpectralCentroid',...
    'TimeRms',...
    'TimeZeroCrossingRate',...
    'SpectralRolloff');
    cFeatureLabels = char('$\sigma_\mathrm{SC}$',...
    '$\sigma_\mathrm{RMS}$',...
    '$\sigma_\mathrm{ZC}$',...
    '$\sigma_\mathrm{SR}$');

    [x, f_s] = audioread(cFilePath);
    x = x / max(abs(x));
    
    for i = 1:iNumFeatures
        feature = ComputeFeature (deblank(cFeatureNames(i, :)), x, f_s);
        v(i, 1) = std(feature(1, :));
    end
end