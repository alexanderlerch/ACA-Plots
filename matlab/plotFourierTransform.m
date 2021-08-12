function plotFourierTransform()

    hFigureHandle = generateFigure(13.12,7);
    
    iStart  = 66000;
    iLength = 2048;
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'sax_example.wav';
    
    cXLabel = '$f / \mathrm{kHz}$';
    
    % get data
    [t,x,f,X] = getData([cPath '/../audio/sax_example.wav'], [iStart iStart+iLength-1]);
    
    subplot(221)
    plot(t,x)
    xlabel('$t / \mathrm{s}$');
    ylabel('$x(t)$');
    axis([t(1) t(end) -1 1]), grid on
    set(gca,'XTick',0:.01:t(end))
    set(gca,'XTicklabel','')
    
    subplot(222)
    plot(f,20*log10(abs(X(1:length(X)/2+1))),'LineWidth',.1)
    xlabel(cXLabel)
    ylabel('$|X(k,n)|$ [dB]')
    axis([f(1) f(end) -100 0])

    subplot(223)
    plot([-fliplr(f(2:end-1)) f], real(fftshift(X)),'LineWidth',.1)
    xlabel(cXLabel)
    ylabel('$\Re[X(k,n)]$')
    axis([-f(end-1) f(end) -.35 .35])
    
    subplot(224)
    plot([-fliplr(f(2:end-1)) f], imag(fftshift(X)),'LineWidth',.1)
    xlabel(cXLabel)
    ylabel('$\Im[X(k,n)]$')
    axis([-f(end-1) f(end) -.35 .35])
    
    printFigure(hFigureHandle, cOutputPath)
end

function [t,x,f,X]   = getData(cPath, iSamples)

    iLength = iSamples(2)-iSamples(1)+1;
    [x, fs] = audioread(cPath, iSamples);
    t       = linspace(0,(iLength-1)/fs,iLength);

    % normalize
    x       = x/max(abs(x));

    iFftLength  = length(x);
    
    f           = (0:(iFftLength/2))/iFftLength*fs/1000;
    X           = fft(hann(iFftLength).*x)*2/iFftLength;
end