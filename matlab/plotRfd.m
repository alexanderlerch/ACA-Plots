function plotRfd()

    hFigureHandle = generateFigure(13.12,4);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % read sample data
    load handel.mat

    rdf     = histogram(y,128,'Normalization','probability','EdgeColor',[.4 .4 .4],'FaceColor',[.6 .6 .6]);

    b = .16;
    y2  = 1/(2*b)*exp(-abs(rdf.BinLimits(1):rdf.BinWidth:rdf.BinLimits(2))./b);
    y2  = y2/sum(y2); % only approx.
    
    sigma = .15;
    %sigma = 0.038499222027882;
    y3 = 1/(sigma*sqrt(2*pi))/75*exp(-((rdf.BinLimits(1):rdf.BinWidth:rdf.BinLimits(2)).^2)/(2*sigma.^2));
    hold on;
    plot(rdf.BinLimits(1):rdf.BinWidth:rdf.BinLimits(2),y2)
    plot(rdf.BinLimits(1):rdf.BinWidth:rdf.BinLimits(2),y3)
    hold off;
    axis([-.8 .8 0 .05])
    legend('measured RFD', 'Laplace', 'Gaussian');
    xlabel('$x$')
    ylabel('rel. num. of occurences')
    
    printFigure(hFigureHandle, cOutputFilePath)
end