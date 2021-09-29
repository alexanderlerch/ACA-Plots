function plotOverfitting()

    hFigureHandle = generateFigure(13.12,4);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % retrieve plotdata
    iNumObs = 10;
    [x,y,t,m1,m2] = getData (iNumObs);

    %plot
    colorGtGold = [234, 170, 0]/256;
    
    hold on;
    plot(t,m1,'Color',[.6 .6 .6])
    plot(t,m2,'Color',colorGtGold)
    plot(x,y,'o','MarkerSize',2,'MarkerEdgeColor','k','MarkerFaceColor','k');
    hold off;
    
    xlabel('$x$');
    ylabel('$y$');
    %set(gca,'XTickLabel',[])
    %set(gca,'YTickLabel',[])
    axis([0 1 .4 1.1])
    box on;
    
    printFigure(hFigureHandle, cOutputFilePath)
end

function [x,y,t,m1,m2] = getData (iNumObs)

    rng(10);
    fScale = .1;
    iNumSamples = 10000;
    
    % y = .5x + .5 (plus noise)
    x = linspace(0,1,iNumObs);
    y = .5*x + (rand(1, iNumObs)-.5)*fScale +.5;
    
    t = linspace(0,1,iNumSamples);
    m1 = .5*linspace(0,1,iNumSamples)+.5;
    m2 = interp1(x,y,t,'spline');

end

