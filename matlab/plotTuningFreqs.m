function plotTuningFreqs()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 3);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % read sample data
    [R] = getData();

    %plot data
    histogram(R, (427:454)-.5, 'Normalization', 'probability', 'EdgeColor', [.4 .4 .4], 'FaceColor', [.6 .6 .6])
    %bar(f, p, 'k'), 
    % grid on
    axis([427 453 0 .25])
    xlabel('$f_\mathrm{A4} / \mathrm{Hz}$');
    ylabel('$RFD(f_\mathrm{A4})$');

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [R] = getData()
    R = load('TuningFreqRawData.txt');
end