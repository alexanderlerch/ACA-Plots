function plotSsmRotated ()

    % check for dependency
    if(exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 6);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName = 'bad.mp3';
    cXLabel = '$lag / \mathrm{s}$';


    % read audio and get plot data
    [tv, Dv, tannot, annot, partidx] = getData(cAudioPath, cName);

    % plot     
    subplot(121)
    imagesc(tv, tv, nonlinearity(Dv))
    c=colormap('jet');
    colormap(flipud(c));
    ylabel('$t / \mathrm{s}$')
    xlabel(cXLabel)

    ax=subplot(122);
    color = get(hFigureHandle, 'defaultAxesColorOrder');
    imagesc(tv, tv, nonlinearity(Dv))
    c=colormap(ax, 'gray');
    colormap(ax, flipud(c));
    hold on;
    for i = 2:length(partidx)
        plot([1 1], [tannot(i, 1) tannot(i, 2)], 'color',color(partidx(i), :), 'linewidth', 3);
        for k = 2:length(partidx)
            if (partidx(i) ~= partidx(k) || i>=k)
                continue;
            end
            plot([tannot(k, 1)-tannot(i, 1) tannot(k, 1)-tannot(i, 1)], [tannot(i, 1) tannot(i, 2)], 'color', color(partidx(i), :), 'linewidth', 3);
        end
    end
    hold off;
    xlabel(cXLabel)
    if tannot(2, 1) < tv(1)
        tannot(2, 1) = tv(1);
    end
    set(gca, 'YTick', tannot(2:end-1, 1))
    set(gca, 'YTickLabels', char(annot(2:end-1, :)))

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [tv, Dv, tannot, annot, partidx] = getData(cAudioPath, cName)

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
        'break  '
        'verse  '
        'bridge '
        'refrain'
        'break  '
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
    partidx = [
        0
        1
        2
        3
        2
        4
        5
        3
        2
        4
        5
        6
        4
        5
        5
        5
        5];

    iWindowLength = 65536; 
    iHopLength = 4096; 
    
    % read sample data
    [x, f_s] = audioread([cAudioPath '/' cName]);
    x = mean(x, 2); 
    x = x / max(abs(x));
 
    [v, tv] = ComputeFeature(deblank(cFeatureNames(1, :)), x, f_s, [], iWindowLength, iHopLength);

    Dv = zeros(length(tv));
    for i = 1:length(tv)
        Dv(i, :) = sqrt(sum((repmat(v(:, i), 1, length(tv))-v).^2));
    end

    Dv = Dv - min(min(Dv));
    Dv = Dv / max(max(Dv));
    
    for i = 1:size(Dv, 1)
        for k = 1:size(Dv, 1)-i+1
            Dv(i, k) = Dv(i+k-1, i);
        end
        Dv(i, size(Dv, 2)-i+1:size(Dv, 2)) = 1;
    end    
    Dv(Dv > .7) = 1;
end

function [D] = nonlinearity(D)
    scale = 2;
    D = D - min(min(D));
    D = D / max(max(D)) * scale;
    D = tanh(D-scale/8);
end
