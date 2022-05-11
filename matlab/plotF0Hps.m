function plotF0Hps()
    
    % check for dependency
    if(exist('ComputePitch') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 6);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    % read audio and generate plot data
    [f, X, P, f0] = getData([cAudioPath,cName]);
 
    % plot
    subplot(211)
   	%semilogx(f, X', 'LineWidth', .5);
    hold on
    plot(f, X(1,:), 'Color', getAcaColor('black'), 'LineWidth', .5)
    plot(f, X(2,:), 'Color', getAcaColor('main'), 'LineWidth', .5)
    plot(f, X(3,:), 'Color', getAcaColor('gt'), 'LineWidth', .5)
    plot(f, X(4,:), 'Color', getAcaColor('lightgray'), 'LineWidth', .5)
    set(gca, 'XScale', 'log')
    box on
    hold off
    axis([.1 f(end) -100 0])
    set(gca, 'XTickLabel', [])
    legend('j=1', 'j=2', 'j=3', 'j=4')
    ylabel('$|X(j\cdot k)|/\mathrm{dB}$')
   
    subplot(212)
    
    hold on;
    line(f0*ones(1, 2), [-210 -90], 'LineWidth', 2.5, 'Color', getAcaColor('main'))
    plot(f, P, 'Color', getAcaColor('black'), 'LineWidth', .5)
    set(gca, 'XScale', 'log')
    box on;
    hold off;
    axis([.1 f(end) -210 -90])
    xtick = get(gca, 'XTick');
    xtick = sort([xtick f0]);
    set(gca, 'XTick', xtick);
    xticklabel = get(gca, 'XTickLabel');
    xticklabel(xtick == f0) = {'$\hat{f}_0$'};
    set(gca, 'XTickLabel', xticklabel)
    xlabel('$f / \mathrm{kHz}$')
    ylabel('$|X_\mathrm{HPS}(k)|/\mathrm{dB}$')

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f, X, P, f0] = getData(cInputFilePath)

    iOrder = 4;
    
    iStart = 66000;
    iLength = 4096;
    
    % read audio
    [x, f_s] = audioread(cInputFilePath, [iStart iStart+iLength-1]);
    t = linspace(0, length(x)/f_s, length(x));
    x = x / max(abs(x));

    f = (0:iLength/2) / iLength * f_s / 1000;

    % compute FFT
    X(1, :) = abs(fft(hann(iLength).*x)) * 2 / iLength;
    X = X(1, 1:end/2+1).^2;

    % HPS
    P = X(1, :);
    for r = 2:iOrder
        X(r, :) = [X(1, 1:r:end) zeros(1, iLength/2+1-length(X(1, 1:r:end)))];
        P = P.*X(r, :);
    end
    X = 10*log10(X);
    P = 10*log10(P);
    
    [dummy, k] = max(P); 
    f0 = f(k);
end