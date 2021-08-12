function animateStft()

    hFigureHandle = generateFigure(13.12,7);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/animation/' strrep(cName, 'animate', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'sax_example.wav';
    
    iStart = 59601;
    iLength = 6*2048;

    cXLabel1='$t / \mathrm{s}$';
    cXLabel2='$n$';
    cYLabel1='$x(i)$';
    cYLabel2= '$f / \mathrm{Hz}$';
    cZLabel = '$|X(k,n)|$'; 
    
    % get data
    [tx,x,t,f,X,w] = getData([cPath '/../audio/sax_example.wav'], [iStart iStart+iLength-1]);

     for (n=1:length(t))
        subplot(211),
        plot(tx,x,'Color', .7*ones(1,3))
        grid on
        axis([tx(1) tx(end) -1.1 1.1])
        ylabel(cYLabel1)
        xlabel(cXLabel1);
        
        hold on; 
        plot(tx,w(n,:)'.*x,'Color', 'black');
        hold off;
        hold on; 
        plot(tx,w(n,:),'Color', [234, 170, 0]/256);
        hold off;
        
        subplot(212)
        waterfall(f,t,[X(:,1:n) ones(size(X,1),length(t)-n)*min(min(X))]')
        view(75,-20);
        ylabel(cXLabel2);
        xlabel(cYLabel2);
        zlabel(cZLabel)
        axis([f(1) f(end) t(1) t(end) -60 -10])
        set(gca,'XTickLabel',[],'YTickLabel',[],'ZTickLabel',[])
        set(gca,'Ytick',t)

        printFigure(hFigureHandle, [cOutputPath '-' num2str(n,'%.3d')]); 
    end
end

function [tx,x,t,f,X,w] = getData(cFilePath, indices)

    iFFTLength = 4096;
    iHopLength = 2048;

    [x, fs] = audioread(cFilePath, indices);
    x       = x./max(abs(x));
    tx      = linspace(0,length(x)/fs,length(x));

    [X,f,t] = spectrogram(x,hanning(iFFTLength),iHopLength,iFFTLength,fs);
    X       = abs(X);
    X       = 20*log10(abs(X(1:iFFTLength*.25,:))*2/iFFTLength);
    f       = f(1:iFFTLength*.25,:);

    w       = zeros(size(X,2), length(x));
    for (n=1:length(t))
        w(n,(n-1)*iHopLength+1:(n-1)*iHopLength+iFFTLength) = hanning(iFFTLength);
    end
end