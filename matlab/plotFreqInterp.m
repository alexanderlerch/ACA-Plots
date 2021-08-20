function plotFreqInterp()

   hFigureHandle = generateFigure(13.12,8);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    [f,X,fi,Xi,Xiz] = getData ([cAudioPath,cName]);
 
    cXLabel = '$f / \mathrm{Hz}$';

    range   = [1 15];
    subplot(211);
    plot(f,X,fi,Xiz);
    axis([f(range(1,1)) f(range(1,2)) 0 45])    
    xlabel(cXLabel)
    ylabel('$|X_\mathrm{ZP}(f)|$')
    legend('normal','zeropad')
    subplot(212);
    plot(f,X,fi,Xi);
    axis([f(range(1,1)) f(range(1,2)) 0 45])    
    
    xlabel(cXLabel)
    ylabel('$|X_\mathrm{IP}(f)|$')
    legend('normal','interpol')
    
    printFigure(hFigureHandle, cOutputPath)
end

function [f,X,fi,Xi,Xiz]  = getData(cAudioPath)
    iStart  = 66000;
    iLength = 4096;
  
    % read sample data
    [x, fs] = audioread(cAudioPath, [iStart iStart+iLength-1]);
    x       = x/max(abs(x));
    
    resamplef = 8;
    fftlength = 256;
    X       = abs(fft(x(1:256).*hann(fftlength)));
    Xiz     = abs(fft(x(1:256).*hann(fftlength),fftlength*resamplef));
    
    f       = linspace(0,fs,length(X));
    fi      = linspace(0,fs,length(Xiz));
    Xi      = interp1(f,X,fi,'spline');
end