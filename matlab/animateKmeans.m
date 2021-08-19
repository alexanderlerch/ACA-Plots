function animateKmeans()

    hFigureHandle = generateFigure(13.12,7);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/animation/' strrep(cName, 'animate', '')];

    %hFigureHandle   = generateFigure(7,6);

    % class 1 data
    v              =  [.1 .5
                        .05 .6
                        .12 .8
                        .35 .3
                        .45 .25
                        .6 .7
                        .61 .9
                        .75 .85
                        .9 .75
                        .55 .35
                        .52 .2]';
    numClusters = 3;
	iFigIdx     = 0;
    iMarkerSize = 8;
    scatter(v(1,:),v(2,:), iMarkerSize*2,[0 0 0],'filled','o');
    axis([0 1 0 1]);
    set(gca,'XTickLabel',[],'YTickLabel',[]);
    set(gca,'visible','off');
    plotcolor = [.8 0 0];
    printFigure(hFigureHandle, [cOutputPath '-' num2str(iFigIdx,'%.2d')]);iFigIdx = iFigIdx+1;
    [clusterIdx,state] = ToolSimpleKmeans(v, numClusters, 1);
    printFigure(hFigureHandle, [cOutputPath '-' num2str(iFigIdx,'%.2d')]);iFigIdx = iFigIdx+1;
    for (i = 1:3)
        scatter(v(1,:),v(2,:), iMarkerSize*2,[0 0 0],'filled','o');
        axis([0 1 0 1]);set(gca,'visible','off');
        set(gca,'XTickLabel',[],'YTickLabel',[]);
        hold on;
        for k=1:numClusters
            scatter(state.m(1,k),state.m(2,k), iMarkerSize*8,circshift(plotcolor,[0 k-1]),'filled','s');
            scatter(v(1,clusterIdx==k),v(2,clusterIdx==k), iMarkerSize*2,circshift(plotcolor,[0 k-1]),'filled','o');
        end
        hold off;
        [clusterIdx,state] = ToolSimpleKmeans(v, numClusters, 1,state);
        printFigure(hFigureHandle, [cOutputPath '-' num2str(iFigIdx,'%.2d')]);iFigIdx = iFigIdx+1;
    end    
end