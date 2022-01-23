function plotFeatureExtraction ()

    % check for dependency
    if(exist('ComputeSpectrogram') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 8);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'sax_example.wav';

    % generate plot data
    [t, x, tw, f, X] = getData ([cAudioPath, '/', cName]);

    % set the strings of the axis labels
    cXLabel = '$t$';
    cYLabel1 = '$x(t)$';
    cYLabel2 = '$f$';
    cYLabel3 = '$|X(k,n)|$';

    % plot 
    subplot(311), 
    plot(t, x)
    %ylabel(cYLabel1)
    axis([t(1) t(end) -max(abs(x)) max(abs(x))])
    set(gca, 'YTickLabel', {})
    set(gca, 'XTickLabel', {})
    set(gca, 'XTick', [0 5 10 15 20 25])

    subplot(312), 
    imagesc(t, f/1000, X)
    axis xy;
    set(gca, 'YTickLabel', {})
    set(gca, 'XTickLabel', {})

    subplot(3, 5, 12), 
    plot(f, X(:, 173), 'Linewidth', 0.3)
    axis([f(1) f(end) -6+min(X(:, 173)) 6+max(X(:, 173))])
    set(gca, 'YTickLabel', {})
    set(gca, 'XTickLabel', {})
    xlabel(cYLabel2)
    ylabel(cYLabel3)

	annotation(hFigureHandle, 'rectangle', [0.35 0.4 0.005 0.54]);
	annotation(hFigureHandle, 'line', [0.352  0.352], [0.4 0.329]);
	annotation(hFigureHandle, 'arrow', [0.42  0.5], [0.23 0.23]);
	annotation(hFigureHandle, 'textbox', [0.44 0.17 0.017 0.04],...
        'String', {'$f(\cdot)$'},...
        'Interpreter', 'latex',...
        'HorizontalAlignment', 'center',...
        'FontSize', 8,...
        'EdgeColor', 'none');
	annotation(hFigureHandle, 'textbox', [0.52 0.22 0.017 0.04],...
        'String', {'$v(n)$'},...
        'Interpreter', 'latex',...
        'HorizontalAlignment', 'center',...
        'FontSize', 8,...
        'EdgeColor', 'none');
	annotation(hFigureHandle, 'textbox', [0.365 0.38 0.017 0.04],...
        'String', {'$n$'},...
        'Interpreter', 'latex',...
        'HorizontalAlignment', 'center',...
        'FontSize', 8,...
        'EdgeColor', 'none');
     
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [t, x,tw,f,X] = getData (cInputFilePath)

    iFFTLength = 4096;
    
    % read audio data
    [x, f_s] = audioread(cInputFilePath);
    t = linspace(0,length(x)/f_s, length(x));

    % compute spectrogram
    [X,f,tw] = ComputeSpectrogram(x, f_s, [], iFFTLength, iFFTLength/2);

    X = 10 * log10(abs((X(1:iFFTLength/16, :))));
    f = f(1:iFFTLength/16);
end
