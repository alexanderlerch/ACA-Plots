function plotTimeInterp()

    hFigureHandle = generateFigure(13.12,6);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    [tx,x,txi,xi,range] = getData ([cAudioPath,cName]);
    
    plot(tx,x,txi,xi);
    axis([tx(range(1,1)) tx(range(1,2)) -.35 -.18])    
%     subplot(222)
%     plot(txi,xi);
%     axis([tx(range(1,1)) tx(range(1,2)) -.6 -.15])    
%     subplot(223)
%     plot(tr,r);
%     axis([tr(range(2,1)) tr(range(2,2)) .94 .97])    
%     subplot(224)
%     plot(tri,ri);
%     axis([tr(range(2,1)) tr(range(2,2)) .94 .97])    
    
    xlabel('samples')
    ylabel('$x(i)$')
    
    printFigure(hFigureHandle, cOutputFilePath)
end

function [tx,x,txi,xi,range] = getData(cAudioPath)
    iStart  = 66000;
    iLength = 4096;
 
    % read sample data
    [x, fs] = audioread(cAudioPath, [iStart iStart+iLength-1]);
    x       = x/max(abs(x));
    
    resamplef = 8;
%     r       = xcorr(x,'coeff');
    
    tx      = 1:length(x);
    txi     = 1:1/resamplef:length(x);
%     tr      = 1:length(r);
%     tri     = 1:1/resamplef:length(r);
    xi      = interp1(tx,x,txi,'spline');
%     ri      = interp1(tr,r,tri,'spline');

    range   = [2695 2703; 4222 4234];
end