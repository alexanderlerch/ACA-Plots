function plotSampling01()

    hFigureHandle = generateFigure(13.12,8);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    downsampleFactor = 25;
    
    [t,x,ts,xs] = getData ([cAudioPath,cName], downsampleFactor);
    
    subplot(211)
    plot(t,x)
    ylabel('$x(t)$')
    xlabel('$t \ \mathrm{s}$')
    axis([t(1) t(end) -1.1 1.1])
    
    subplot(212)
    colorGtGold = [234, 170, 0]/256;
%    axis([ts(1) t(end) -1.1 1.1])

    hold on;
    %plot(linspace(ts(1), length(xt)/downsampleFactor+1, length(xt)), xt,'LineStyle','--');
    plot(linspace(ts(1), length(x)/downsampleFactor+1, length(x)),x,'Color',.6*ones(1,3));
    stem(ts,xs,'k-','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',2.5);
    %stem(ts,xs,'k-','MarkerEdgeColor','k','MarkerFaceColor',[0 0 0],'MarkerSize',5);
    xlabel('samples')
    ylabel('$x(i)$')
     axis([ts(1) length(x)/downsampleFactor+1 -1.1 1.1])
     box on;
    hold off;

    printFigure(hFigureHandle, cOutputPath)
end


function [t,x,ts,xs] = getData (cInputFilePath,downsampleFactor)

    if nargin < 2
        downsampleFactor = 25;
    end

    iStart  = 66000;
    iLength = 1024;

    % read sample data
    [x,fs]  = audioread(cInputFilePath, [iStart iStart+iLength-1]);
    x       = x/max(abs(x));
    t       = linspace(0,(iLength-1)/fs,iLength);

    % pretend sampling the data
    
    xs      = x(1:downsampleFactor:end);
    ts      = 1:length(xs);

end