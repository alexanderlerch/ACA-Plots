function plotWaveformWithoutBg ()

    % generate new figure
    hFigureHandle = generateFigure(5, 2.5);

    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];


    % file path
    cName = 'classic_excerpt.wav';

    % read audio data
    [t, x] = getData ([cAudioPath, '/',cName]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % plot data
    plot(t, x, 'Color', getAcaColor('lightgray'))


    hold on;
    iNumSteps = 64;
    for i = 1:iNumSteps
        thresh = i/iNumSteps;
        if (thresh >= max(abs(x)))
            break;
        end
        xenv = NaN*ones(size(x));
        xenv(abs(x) > thresh) = x(abs(x) > thresh);
        plot(t, xenv, 'Color', getAcaColor('lightgray')*(1-thresh))
    end
    hold off;

    axis([t(1) t(end) -1 1])
    set(gca, 'XTick', [])
    set(gca, 'YTick', [])
    set(findobj(gcf, 'type', 'axes'), 'Visible', 'off')
    set(gcf, 'color', 'none');

    % write output file
    printFigure(hFigureHandle, cOutputPath)

end

function [t, x] = getData (cInputFilePath)
    [x, f_s] = audioread(cInputFilePath);
    t = linspace(0, length(x)/f_s, length(x));
end

