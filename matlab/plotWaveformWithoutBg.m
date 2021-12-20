function plotWaveformWithoutBg ()
    hFigureHandle = generateFigure(5,2.5);

    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];


    % file path
    cName           = 'classic_excerpt.wav';

    [t,x] = getData ([cAudioPath,'/',cName]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % plot data
    plot(t,x, 'Color', [.8 .8 .8])
    % set the axes to tight
    axis([t(1) t(end) -1 1])
    set(gca, 'XTick',[])
    set(gca, 'YTick',[])
    set(findobj(gcf, 'type','axes'), 'Visible','off')
    set(gcf, 'color', 'none');

    % write output file
    printFigure(hFigureHandle, cOutputPath)

end
% example function for data generation, substitute this with your code
function [t,x] = getData (cInputFilePath)

    [x, fs] = audioread(cInputFilePath);
    t       = linspace(0,length(x)/fs,length(x));
end

