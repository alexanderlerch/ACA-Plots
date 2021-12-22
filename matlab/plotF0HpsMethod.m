function plotF0HpsMethod()
    
    % generate new figure
    hFigureHandle = generateFigure(13.12,9);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    % read audio and generate plot data
    [f,X,P,f0] = getData ([cAudioPath,cName]);
 
    % plot
    subplot(411)
   	plot(f,(X(1,:)));
    axis([.1 f(end) -100 0])
    ylabel('$|X(k)|/\mathrm{dB}$')
 
    subplot(412)
   	plot(f,(X(2,:)));
    axis([.1 f(end) -100 0])
    ylabel('$|X(2k)|/\mathrm{dB}$')
 
    subplot(413)
   	plot(f,(X(3,:)));
    axis([.1 f(end) -100 0])
    ylabel('$|X(3k)|/\mathrm{dB}$')

    subplot(414)
   	plot(f,(P));
    axis([.1 f(end) -210 -90])
    ylabel('$|X_\mathrm{HPS}(k)|/\mathrm{dB}$')
    xlabel('$f / \mathrm{Hz}$')
    
    % create arrow
    annotation(hFigureHandle,'arrow',[0.26 0.2],[0.9 0.69],'Color',[234/256 170/256 0]);

    % create arrow
    annotation(hFigureHandle,'arrow',[0.515 0.33],[0.87 0.68],'Color',[234/256 170/256 0]);

    % create arrow
    annotation(hFigureHandle,'arrow',[0.39 0.27],[0.89 0.69],'Color',[234/256 170/256 0]);

    % create arrow
    annotation(hFigureHandle,'arrow',[0.26 0.17],[0.9 0.48],'Color',[234/256 170/256 0]);

    % create arrow
    annotation(hFigureHandle,'arrow',[0.39 0.22],[0.89 0.45],'Color',[234/256 170/256 0]);

    % create arrow
    annotation(hFigureHandle,'arrow',[0.515 0.26],[0.87 0.45],'Color',[234/256 170/256 0]);

    % create line
    annotation(hFigureHandle,'line',[0.26 0.26],...
        [0.9 0.111],'LineStyle',':');

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f,X,P,f0] = getData (cInputFilePath)

    f_max = 2000;
    iOrder = 4;
    
    iStart  = 66000;
    iLength = 4096;

    % read audio
    [x,f_s] = audioread(cInputFilePath, [iStart iStart+iLength-1]);
    t       = linspace(0,length(x)/f_s,length(x));
    x       = x/max(abs(x));

    f       = (0:iLength/2)/iLength*f_s;

    % fft
    X(1,:)  = abs(fft(hann(iLength).*x))*2/iLength;
    X       = X(1,1:end/2+1).^2;

    % hps
    P       = X(1,:);
    for (r = 2:iOrder)
        X(r,:)  = [X(1,1:r:end) zeros(1,iLength/2+1-length(X(1,1:r:end)))];
        P       = P.*X(r,:);
    end
    X   = 10*log10(X);
    P   = 10*log10(P);
    
    [dummy, k] = max(P); 
    f0 = f(k);
    
    % truncate to f_max
    f = f(f<f_max);
    X = X(:,1:length(f));
    P = P(:,1:length(f));
end