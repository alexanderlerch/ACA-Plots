function plotWaveform  ()

    % generate new figure
    hFigureHandle   = generateFigure(13.12,4);

    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath     = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath      = [cPath '/../audio'];

    % file paths
    cName1  = 'speech_excerpt.wav';
    cName2  = 'classic_excerpt.wav';
    cName3  = 'pop_excerpt.wav';

    % read audio
    [t1,x1] = getData ([cAudioPath,'/',cName1]);
    [t2,x2] = getData ([cAudioPath,'/',cName2]);
    [t3,x3] = getData ([cAudioPath,'/',cName3]);

    % set the strings of the axis labels
    cXLabel  = '$t / \mathrm{s}$';
    cYLabel1 = '$x_\mathrm{speech}(t)$';
    cYLabel2 = '$x_\mathrm{chamber}(t)$';
    cYLabel3 = '$x_\mathrm{pop}(t)$';

    % plot data
    subplot(131)
    plot(t1,x1, 'k-')
    axis([t1(1) t1(end) -1 1])
    grid on
    set(gca, 'YTickLabel',[])
    xlabel(cXLabel);
    ylabel(cYLabel1);

    subplot(132)
    plot(t2,x2, 'k-')
    axis([t1(1) t1(end) -1 1])
    grid on
    set(gca, 'YTickLabel',[])
    xlabel(cXLabel);
    ylabel(cYLabel2);

    subplot(133)
    plot(t3,x3, 'k-')
    axis([t1(1) t1(end) -1 1])
    grid on
    set(gca, 'YTickLabel',[])
    xlabel(cXLabel);
    ylabel(cYLabel3);

    % write output file
    printFigure(hFigureHandle, cOutputPath)

end

function [t,x] = getData (cInputFilePath)
    [x, fs] = audioread(cInputFilePath);
    t       = linspace(0,length(x)/fs,length(x));
end

