function plotTextureWindow()

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
    cFile = 'sax_example.wav';

    % feature specification
    cFeatureNames = char('SpectralCentroid');
    
    % read audio and get plot data
    [t, x, tv, v, tv2, v2] = getData ([cAudioPath, '/', cFile], cFeatureNames);

    % plot
    subplot(311)
    plot(t, x)
    ylabel('$x(t)$')
    axis([t(1) tv2(end) -1 1]);
    
    subplot(3, 1, 2:3)
    plot(tv, v, 'Color', getAcaColor('darkgray'), 'LineWidth', 0.5)
    hold on;
    curve1 = v2(1, :) + v2(2, :);
    curve2 = v2(1, :) - v2(2, :);
    x2 = [tv2, fliplr(tv2)];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween, getAcaColor('main'), 'EdgeColor', getAcaColor('main', true), 'FaceAlpha', .5);
    plot(tv2, v2(1, :), 'k', 'LineWidth', 2)
    hold off;
    xlabel('$t$')
    legend('$v_\mathrm{SC}$', '$\sigma_v$', '$\mu_v$', 'location', 'northwest');
    axis([0 tv2(end) 0 8000]);
    
    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [t, x, tv, v, tv2, v2] = getData (cInputFilePath, cFeatureNames)

    iTextureWindowSize = 20;
    iTextureWindowHop = floor(iTextureWindowSize/4);
 
    % read audio
    [x, f_s] = audioread(cInputFilePath);
    t = linspace(0,length(x)/f_s,length(x));
    x = x / max(abs(x));

    % extract feature
    [v, tv] = ComputeFeature (deblank(cFeatureNames(1, :)), x, f_s);
    
    % feature aggregation
    v_pad = [zeros(1, iTextureWindowHop) v zeros(1, iTextureWindowSize)];
    for n = 1:floor(length(v)/iTextureWindowHop)
        v2(1, n) = mean(v_pad(1, (n-1)*iTextureWindowHop+1:(n-1)*iTextureWindowHop+iTextureWindowSize));
        v2(2, n) = std(v_pad(1, (n-1)*iTextureWindowHop+1:(n-1)*iTextureWindowHop+iTextureWindowSize));
    end
    tv2 = tv(1:iTextureWindowHop:end);
    tv2 = tv2(1:size(v2, 2));
end
