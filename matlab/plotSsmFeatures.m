function plotSsmFeatures ()

    % check for dependency
    if(exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 3);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName = 'bad.mp3';

    % read audio and get plot data
    [tv, Dpc, Drms, Dmfcc, Dms, Dpcb, Drmsb, Dmfccb, Dmsb] = getData(cAudioPath, cName);

    % plot
    ax = subplot(141);
    imagesc(tv, tv, applyNonlinearity_I(Dpc, 2))
    c=colormap(ax, 'parula');
    colormap(ax, flipud(c));
    ylabel('$t / \mathrm{s}$')
    set(gca, 'XTickLabels', {})
    set(gca, 'YTickLabels', {})
    xlabel('$t / \mathrm{s}$')    

    ax = subplot(142);
    imagesc(tv, tv, applyNonlinearity_I(Drms, 10))
    c=colormap(ax, 'parula');
    colormap(ax, flipud(c));
    ylabel('$t / \mathrm{s}$')
    set(gca, 'XTickLabels', {})
    set(gca, 'YTickLabels', {})
    xlabel('$t / \mathrm{s}$')    

    ax = subplot(143);
    imagesc(tv, tv, applyNonlinearity_I(Dmfcc, 2))
    c=colormap(ax, 'parula');
    colormap(ax, flipud(c));
    ylabel('$t / \mathrm{s}$')
    set(gca, 'XTickLabels', {})
    set(gca, 'YTickLabels', {})
    xlabel('$t / \mathrm{s}$')    

    ax = subplot(144);
    imagesc(tv, tv, applyNonlinearity_I(Dms, 3))
    c=colormap(ax, 'parula');
    colormap(ax, flipud(c));
    ylabel('$t / \mathrm{s}$')
    set(gca, 'XTickLabels', {})
    set(gca, 'YTickLabels', {})
    xlabel('$t / \mathrm{s}$')    

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [tv, Dpc, Drms, Dmfcc, Dms, Dpcb, Drmsb, Dmfccb, Dmsb] = getData(cAudioPath, cName)

    cFeatureNames = char('SpectralPitchChroma', 'TimeRms', 'SpectralMfccs', 'TimeAcfCoeff');%char('TimeAcfCoeff');

    iBlockLength = 65536; 
    iHopLength = 4096; 
    
    % read sample data
    [x, f_s] = audioread([cAudioPath '/' cName]);
    x = mean(x, 2); 
    x = x / max(abs(x));
 
    % compute features
    [vpc, tpc] = ComputeFeature(deblank(cFeatureNames(1, :)), x, f_s, [], iBlockLength, iHopLength);
    [vrms, trms] = ComputeFeature(deblank(cFeatureNames(2, :)), x, f_s, [], iBlockLength, iHopLength);
    vrms = 10.^(vrms*.05);
    vrms = vrms / max(max(vrms));
    [vmfcc, tmfcc] = ComputeFeature (deblank(cFeatureNames(3, :)), x, f_s, [], iBlockLength, iHopLength);
    vmfcc = 10.^(vmfcc*.05);
    vmfcc = vmfcc / max(max(vmfcc));

    [M, f_c, t_MS] = ComputeMelSpectrogram (x, f_s, false, [], iBlockLength, iHopLength, 128, 16000);
 
    % compute distance matrices
    tv = tpc;
    Dpc = zeros(length(tv));
    Drms = zeros(length(tv));
    Dmfcc = zeros(length(tv));
    Dms = zeros(length(tv));
    for i = 1:length(tv)
        Dpc(i, :) = sqrt(sum((repmat(vpc(:, i), 1, length(tv))-vpc).^2));
        Drms(i, :) = sqrt(sum((repmat(vrms(:, i), 1, length(tv))-vrms).^2));
        Dmfcc(i, :) = sqrt(sum((repmat(vmfcc(:, i), 1, length(tv))-vmfcc).^2));
        Dms(i, :) = sqrt(sum((repmat(M(:, i), 1, length(tv))-M).^2));
    end
  
    % normalize
    Dpc = normalize_I(Dpc);
    Drms = normalize_I(Drms);
    Dmfcc = normalize_I(Dmfcc);
    Dms = normalize_I(Dms);
    
    % quantize
    thresh = .89;
    Dpcb = 1-Dpc;
    Dpcb(Dpcb<=thresh) = 0;
    
    thresh = .985;
    Drmsb = 1-Drms;
    Drmsb(Drmsb<=thresh) = 0;
    
    thresh = .85;
    Dmfccb = 1-Dmfcc;
    Dmfccb(Dmfccb<=thresh) = 0;
    
    thresh = .825;
    Dmsb = 1-Dms;
    Dmsb(Dmsb<=thresh) = 0;
end

function [D] = applyNonlinearity_I(D, scale)
    if nargin < 2
        scale = 1;
    end
    D = normalize_I(D) * scale;
    D = tanh(D-scale/8);
end

function [D] = normalize_I(D)
    D = D - min(min(D));
    D = D / max(max(D));
end
