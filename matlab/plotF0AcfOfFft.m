function plotF0AcfOfFft()

    hFigureHandle = generateFigure(13.12,8);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    [f,X,Rxx,f0] = getData ([cAudioPath,cName]);

    iPlotLength = round(length(f)/4);    
    subplot(211)
    plot(f(1:iPlotLength),X(1:iPlotLength))
    xlabel('$f / \mathrm{kHz}$')
    ylabel('$|X(k)|/\mathrm{dB}$')
    axis([f(1) f(iPlotLength) -100 0])
    
    subplot(212)
    plot(f(1:iPlotLength),Rxx(1:iPlotLength))
    xlabel('$\eta_f/ \mathrm{kHz}$')
    ylabel('$r_\mathrm{XX}(\eta_f)$')
    axis([f(1) f(iPlotLength) 0 1])
    hold on;
    line(f0*ones(1,2), [0 1],'LineWidth', 2.5,'Color',[234/256 170/256 0])
    %plot(eta,rc,'k'),
    hold off;
    
    xtick = get(gca,'XTick');
    xtick = sort([xtick f0]);
    set(gca,'XTick', xtick);
    xticklabel = get(gca,'XTickLabel');
    xticklabel(xtick == f0) = {'$f_0$'};
    set(gca,'XTickLabel', xticklabel)


    printFigure(hFigureHandle, cOutputFilePath)
end

function [f,X,Rxx, f0] = getData (cInputFilePath)

    % read sample data
    iStart  = 66000;
    iLength = 4096;
    [x,f_s] = audioread(cInputFilePath, [iStart iStart+iLength-1]);
    x       = x/max(abs(x));

    f_min   = 120;
    k_min   = round(f_min/f_s*iLength);
    
    X(1,:)  = (abs(fft(hann(iLength).*x))*2/iLength).^2;
    X(1) = max(X); % make it easier to detect 'periodicity'

    Rxx     = cconv(X,X,iLength);
    Rxx     = Rxx(1:iLength/2+1)/max(Rxx);

    X       = 10*log10(X(1:iLength/2+1));

    f       = (0:iLength/2)/iLength*f_s/1000;

    [dummy, k] = max(Rxx(k_min:end)); 
    f0 = f(k+k_min-1);
end