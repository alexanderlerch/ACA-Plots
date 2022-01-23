function plotSsm ()

    % check dependency
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
    [tv, Dv, tvrms, vrms, t, x, tannot, annot] = getData(cAudioPath, cName);

    %plot
    subplot(4, 5, [5 10 15 20])
    plot(x, t, 'LineWidth', .1, 'Color', [.6 .6 .6])
    hold on
    plot(vrms, tvrms, 'Color', .4*[1 1 1])
    plot(-vrms, tvrms, 'Color', .4*[1 1 1])
    hold off
    for i=2:length(tannot)-1
        line([-1.1 1], [tannot(i) tannot(i)], 'Color', [0 0 0], 'LineWidth', 1)
    end
    axis([ -1 1 t(1) t(end)])
    set(gca, 'YTick', tannot(2:end-1, 1))
    set(gca, 'YTickLabels', char(annot(2:end-1, :)))
    set(gca, 'XTick', [])
    set(gca, 'YDir', 'reverse')
    set(gca, 'yaxislocation', 'right');
    
    subplot(4, 5, [1:4 6:9 11:14 16:19])
    imagesc(tv, tv, Dv)
    imagesc(tv, tv, applyNonlinearity_I(Dv))
    c=colormap('jet');
    colormap(flipud(c));
    xlabel('$t / \mathrm{s}$')
    ylabel('$t / \mathrm{s}$')

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [tv, Dv, tvrms, vrms, t, x, tannot, annot] = getData(cAudioPath, cName)

    cFeatureNames = char('SpectralPitchChroma', 'SpectralMfccs', 'TimeAcfCoeff');%char('TimeAcfCoeff');

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

    iWindowLength = 65536; 
    iHopLength = 4096; 
    
    % read sample data
    [x, f_s] = audioread([cAudioPath '/' cName]);
    x = mean(x, 2); 
    x = x / max(abs(x));
    t = (0:(length(x)-1)) / f_s;
 
    % extract features
    [v, tv] = ComputeFeature(deblank(cFeatureNames(1, :)), x, f_s, [], iWindowLength, iHopLength);
    [vrms, tvrms] = ComputeFeature(deblank(cFeatureNames(2, :)), x, f_s, [], iWindowLength, iHopLength);
    vrms = 10.^(vrms(1, :)*.05);
    vrms = vrms / max(vrms);

    % distance matrix
    Dv = zeros(length(tv));
    for i=1:length(tv)
        Dv(i, :) = sqrt(sum((repmat(v(:, i), 1, length(tv))-v).^2));
    end
end

function [D] = applyNonlinearity_I(D)
    scale = 2;
    D = D - min(min(D));
    D = D / max(max(D)) * scale;
    D = tanh(D-scale/8);
end
