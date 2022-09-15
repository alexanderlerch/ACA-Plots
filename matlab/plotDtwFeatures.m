function plotDtwFeatures ()

    % check for dependency
    if(exist('ToolSimpleDtw') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 4);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName = 'originals_splanky.mp3';

    cXLabel = '$t_2\; [\mathrm{s}]$';
    cYLabel = '$t_1\; [\mathrm{s}]$';


    % read audio and generate plot data
    [tv1, tv2,Dpc, Drms, Dmfcc,ppc, prms, pmfcc] = getData(cAudioPath, cName);

    % plot
    ax = subplot(131);
    imagesc(tv2, tv1, applyNonlinearity_I(Dpc, 1))
    c = colormap(ax, 'parula');
    colormap(ax, c);
    xlabel(cXLabel)
    box on;
    hold on; plot(tv2(ppc(:, 2)), tv1(ppc(:, 1)), 'Color', [0 0 0]); 
    hold off
    ylabel(cYLabel)

    ax = subplot(132);
    imagesc(tv2, tv1, applyNonlinearity_I(Drms, 4))
    c = colormap(ax, 'parula');
    colormap(ax, c);
    xlabel(cXLabel)
    box on;
    hold on; plot(tv2(prms(:, 2)), tv1(prms(:, 1)), 'Color', [0 0 0]); 
    hold off
    ylabel(cYLabel)
    
    ax = subplot(133);
    imagesc(tv2, tv1, applyNonlinearity_I(Dmfcc, 1))
    c = colormap(ax, 'parula');
    colormap(ax, c);
    xlabel(cXLabel)
    box on;
    hold on; plot(tv2(pmfcc(:, 2)), tv1(pmfcc(:, 1)), 'Color', [0 0 0]); hold off
    ylabel(cYLabel)

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [tv1, tv2,Dpc, Drms, Dmfcc,ppc, prms, pmfcc] = getData(cAudioPath, cName)

    cFeatureNames = char('SpectralPitchChroma', 'TimeRms', 'SpectralMfccs');

    iBlockLength = 65536; %65536
    iHopLength = 4096; %4096
    
    % read sample data
    [x, f_s] = audioread([cAudioPath '/' cName]);
    
    % strip zeros
    x1 = ToolStripZeros(x(:, 1) / max(abs(x(:, 1))));
    x2 = ToolStripZeros(x(:, 2) / max(abs(x(:, 2))));
    
    % extract features
    [vpc1, tv1] = ComputeFeature (deblank(cFeatureNames(1, :)), x1, f_s, [], iBlockLength, iHopLength);
    [vrms1, trms] = ComputeFeature (deblank(cFeatureNames(2, :)), x1, f_s, [], iBlockLength, iHopLength);
    vrms1 = 10.^(vrms1*.05);
    vrms1 = vrms1 / max(max(vrms1));
    [vmfcc1, tmfcc] = ComputeFeature (deblank(cFeatureNames(3, :)), x1, f_s, [], iBlockLength, iHopLength);
    vmfcc1 = 10.^(vmfcc1*.05);
    vmfcc1 = vmfcc1/max(max(vmfcc1));
    
    [vpc2, tv2] = ComputeFeature (deblank(cFeatureNames(1, :)), x2, f_s, [], iBlockLength, iHopLength);
    [vrms2, trms] = ComputeFeature (deblank(cFeatureNames(2, :)), x2, f_s, [], iBlockLength, iHopLength);
    vrms2 = 10.^(vrms2*.05);
    vrms2 = vrms2 / max(max(vrms2));
    [vmfcc2, tmfcc] = ComputeFeature (deblank(cFeatureNames(3, :)), x2, f_s, [], iBlockLength, iHopLength);
    vmfcc2 = 10.^(vmfcc2*.05);
    vmfcc2 = vmfcc2 / max(max(vmfcc2));

    % compute distance matrices
    Dpc = zeros(length(tv1), length(tv2));
    Drms = zeros(length(tv1), length(tv2));
    Dmfcc = zeros(length(tv1), length(tv2));
    for i=1:length(tv1)
        Dpc(i, :) = sqrt(sum((repmat(vpc1(:, i), 1, length(tv2))-vpc2).^2));
        Drms(i, :) = sqrt(sum((repmat(vrms1(:, i), 1, length(tv2))-vrms2).^2));
        Dmfcc(i, :) = sqrt(sum((repmat(vmfcc1(:, i), 1, length(tv2))-vmfcc2).^2));
    end
  
    Dpc = normalize(Dpc);
    Drms = normalize(Drms);
    Dmfcc = normalize(Dmfcc);
    
    % compute path
    [ppc, C] = ToolSimpleDtw(Dpc);    
    [prms, C] = ToolSimpleDtw(Drms);    
    [pmfcc, C] = ToolSimpleDtw(Dmfcc);    

end

function [D] = applyNonlinearity_I(D, scale)
    if nargin < 2
        scale = 1;
    end
    D = normalize(D) * scale;
    D = tanh(D-scale/8);
end

function [D] = normalize(D)
    D = D - min(min(D));
    D = D / max(max(D));
end

function [x] = ToolStripZeros(x)
    xs = cumsum(abs(x));
    x = x(find(xs, 1, 'first'):end);
    xs = cumsum(flipud(abs(x)));
    x = x(1:end-find(xs, 1, 'first')+2);
end