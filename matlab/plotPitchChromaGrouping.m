function plotPitchChromaGrouping()

    % generate new figure
    hFigureHandle = generateFigure(13.12,4);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';
 
    % read audio and generate plot data
    [px,X,pw,H,ptick] = getData ([cAudioPath, cName]);

    % plot
    [AX,h1,h2] = plotyy(px,X,pw,H);
    axis(AX(1),[ptick(1) ptick(end) 0.01 1.02])
    axis(AX(2),[ptick(1) ptick(end) 0.01 1.02])

    set(AX(2),'YTick',[]);
    set(AX(1),'XTick',ptick)
    set(get(AX(1),'Ylabel'),'String','$|X(k,n)|$');
    set(get(AX(2),'Ylabel'),'String','$w_\mathrm{E}$');
    xlabel('MIDI Pitch')
    
    % fix label that is weirdly outside of plot
    p = get(gca,'Position');
    set(gca,'Position',[p(1) p(2)+0.15 p(3) p(4)-.15]);
    
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [px,X,pw,W,ptick] = getData(cFilePath)
    fA4     = 440;
    iStart  = 16384;
    iLength = 4096;
    aiIdx   = [iStart iStart+iLength-1];
    
    % read audio
    [x,fs]  = audioread(cFilePath, aiIdx);
    x       = x/max(abs(x));
    
    % frequency domain
    X       = (abs(fft(hann(length(x)).*x)));
    X       = X(1:length(x)/2+1);
    px       = 69+12*log2(linspace(0, fs/2, length(x)/2+1)/fA4);
    X       = X/(1.1*max(X)); % factor for nicer plotting

    % midi pitch
    w = [61.5 62.5
        73.5 74.5
        85.5 86.5
        97.5 98.5] + 2;

    % labels
    tickbase = [60 62  65 67 69 ];
    ptick   = [];
    for (i = 1:size(w,1))
        ptick = [ptick tickbase+(i-1)*12] ;
    end

    pw = 60:0.1:round(ptick(end));
    W  = zeros(size(pw));

    % filter bank
    for (i = 1:size(w,1))
        W ((w(i,1)-pw(1))*10:(w(i,2)-pw(1))*10) = 1;
    end
end