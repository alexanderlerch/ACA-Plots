function plotTuningFreqs()

    % generate new figure
    hFigureHandle   = generateFigure(13.12,4);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % read sample data
    [f,p] = getData();

    %plot data
    bar(f,p,'k'), grid on
    axis([427 453 0 .25])
    xlabel('$f_\mathrm{A4} / \mathrm{Hz}$');
    ylabel('RFD');

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f,p] = getData()
    R       = load('TuningFreqRawData.txt');
    [p, f]  = hist(R,420:460);
    p       = p/sum(p);
end