function plotSsmLowPass ()

    % check for dependency
    if(exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 8);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName = 'bad.mp3';

    % read audio and get plot data
    [tv, Dv, homogeneity, tannot, annot] = getData(cAudioPath, cName);

    % plot
    subplot(4, 5, [5 10 15 20])
    plot(homogeneity, tv)
    for i = 2:length(tannot)-1
        line([0 1], [tannot(i) tannot(i)], 'Color', [234/256 170/256 0], 'LineWidth', 1)
    end
    hold on
    plot(homogeneity, tv, 'k')
    hold off
    axis([0 1 0 tv(end)])
    xlabel('homogeneity')
    set(gca, 'YTick', tannot(2:end-1, 1))
    set(gca, 'YTickLabels', char(annot(2:end-1, :)))
    set(gca, 'XTick', [])
    set(gca, 'YDir', 'reverse')
    set(gca, 'yaxislocation', 'right');
    
    subplot(4,5, [1:4 6:9 11:14 16:19])
    imagesc(tv, tv, applyNonlinearity_I(Dv))
    c=colormap('jet');
    colormap(flipud(c));
    xlabel('$t / \mathrm{s}$')
    ylabel('$t / \mathrm{s}$')

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [tv, Dv, homogeneity, tannot, annot] = getData(cAudioPath, cName)

    cFeatureNames = char('SpectralPitchChroma', 'SpectralMfccs', 'TimeAcfCoeff');
    tannot = [
        0.000	0.365
        0.365	18.825
        18.825	35.648
        35.648	44.059
        44.059	60.883
        60.883	69.295
        69.295	86.118
        86.118	94.529
        94.529	119.765
        119.765	128.177
        128.177	144.999
        144.999	170.233
        170.233	178.641
        178.641	195.463
        195.463	212.286
        212.286	229.108
        229.108	246.695
        246.695	246.693];
    annot = [
        'silence'
        'intro  '
        'verse  '
        'breaka '
        'verse  '
        'bridge '
        'refrain'
        'breakb '
        'verse  '
        'bridge '
        'refrain'
        'instru.'
        'bridge '
        'refrain'
        'refrain'
        'refrain'
        'refrain'
        'silence'];

    iWindowLength = 65536; %65536
    iHopLength = 4096; %4096
    
    % read sample data
    [x, f_s] = audioread([cAudioPath '/' cName]);
    x = mean(x, 2); 
    x = x / max(abs(x));
 
    % extract features
    [v, tv] = ComputeFeature(deblank(cFeatureNames(1, :)), x, f_s, [], iWindowLength, iHopLength);

    % compute distance matrix
    Dv = zeros(length(tv));
    for i = 1:length(tv)
        Dv(i, :) = sqrt(sum((repmat(v(:, i), 1, length(tv))-v).^2));
    end

    Dv = Dv - min(min(Dv));
    Dv = Dv / max(max(Dv));

    % compute filter kernel
    iFilterSize = 64;
    g = computeFilter(iFilterSize);
    homogeneity = diag(filter2(g,Dv));

    homogeneity = homogeneity - min(homogeneity);
    homogeneity = homogeneity / max(homogeneity);
end

function [D] = applyNonlinearity_I(D)
    scale = 2;
    D = D - min(min(D));
    D = D / max(max(D))*scale;
    D = tanh(D-scale/8);
end


function [kernel] = computeFilter(iFilterSize)
    kernel = ones(iFilterSize, iFilterSize) * 1/iFilterSize;
end