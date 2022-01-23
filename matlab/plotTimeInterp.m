function plotTimeInterp()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 4);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    % read audio and generate data
    [tx, x, txi, xi, range] = getData([cAudioPath,cName]);

    % plot data
    plot(tx, x, txi, xi);
    axis([tx(range(1, 1)) tx(range(1, 2)) -.35 -.18])    
    xlabel('samples')
    ylabel('$x(i)$')
    
    legend('original', 'interpol')
    
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [tx, x, txi, xi,range] = getData(cAudioPath)
    
    iStart = 66000;
    iLength = 4096;
    resamplef = 8;
 
    % read sample data
    [x, f_s] = audioread(cAudioPath, [iStart iStart+iLength-1]);
    x = x / max(abs(x));
    
    % interpolation
    tx = 1:length(x);
    txi = 1:1/resamplef:length(x);
    xi = interp1(tx, x, txi, 'spline');

    range = [2695 2703; 4222 4234];
end