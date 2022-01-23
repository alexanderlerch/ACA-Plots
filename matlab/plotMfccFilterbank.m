function plotMfccFilterbank ()
 
    if(exist('ToolMfccFb') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 3);
 
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    [f, H] = getData();

    % set the strings of the axis labels
    cXLabel = '$f$';
    cYLabel = '$H_\mathrm{MFCC}(f)$';

    % plot
    semilogx(f, H)
    set(gca, 'XTick', [])
    set(gca, 'YTickLabels', [])
    xlabel(cXLabel)
    ylabel(cYLabel)
    axis([133 7000 0.001 0.016])
    
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f,H] = getData ()
    f_s = 16000;
    iLength = 16384;
    H = ToolMfccFb(iLength, f_s)';
    
    f = linspace(0, f_s/2, iLength);
end
