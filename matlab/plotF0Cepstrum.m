function plotF0Cepstrum()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 6);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    % read audio and generate plot data
    [f, X, q, C, T0] = getData([cAudioPath,cName]);

    % plot
    subplot(211)
    plot(f, X)
    xlabel('$f/\mathrm{kHz}$')
    ylabel('$|X(k)| /\mathrm{dB}$')
    axis([f(1) f(round(end/4)) -100 0])
    
    subplot(212)
    line(T0*ones(1, 2), [-.5 1.5], 'LineWidth', 2.5, 'Color', getAcaColor('main'))
    xlabel('Quefrency / samples')
    ylabel('$\hat{c}_x(i)$')
    axis([q(1) q(end/2) -.5 1.5])
    hold on;
    plot(q, C, 'LineWidth', .5)
    hold off;
    box on;
    xtick = get(gca, 'XTick');
    xtick = sort([xtick(xtick~=100) T0]);
    set(gca, 'XTick', xtick);
    xticklabel = get(gca, 'XTickLabel');
    xticklabel(xtick == T0) = {'$\hat{T}_0$'};
    set(gca, 'XTickLabel', xticklabel)

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f, X, q, C, T_0] = getData (cInputFilePath)

    iStart = 66000;
    iLength = 4096;

    % read audio
    [x, f_s] = audioread(cInputFilePath, [iStart iStart+iLength-1]);
    x = x / max(abs(x));

    f_min = 120;
    k_min = round(f_min/f_s*iLength);
    
    % compute fft
    X(1, :) = 10*log10((abs(fft(hann(iLength).*x))*2/iLength).^2);
    X(1) = max(X); % make it easier to detect 'periodicity'

    C = real(ifft(X));
    C = C(1:end/2);
    q = (0:length(C)-1);

    f = (0:iLength/2) / iLength * f_s / 1000;
    X = X(1:length(f));

    f_min = 120;
    f_max = 2000;    
    
    [dummy, T_0] = max(abs(C(round(f_s/f_max):round(f_s/f_min))));
    T_0 = (T_0 + round(f_s/f_max) - 2);
end