function plotStructure ()

    % generate new figure
    hFigureHandle = generateFigure(13.12,5);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    [segments, fill, labels] = getData();


    h = barh(segments,fill,0.99,'stacked','k');
    set(h([1 3 5 7]),'Visible','off')

    set(gca,'YTick', segments)
    set(gca,'YTickLabels', deblank(char(labels)))
    set(gca, 'YDir','reverse')
    axis([ 0 max(sum(fill,2)) segments(1)-.5 segments(end)+.5])
    xlabel('$t$ / s')
    
    printFigure(hFigureHandle, cOutputPath)
end

function [segments, fill, labels] = getData()

    %from HarmonixSet 0001_12step.txt
%     0.0 intro
%     8.495568 verse
%     25.486704 chorus
%     42.475328 verse
%     59.47014 chorus
%     78.594744 verse
%     95.585708 chorus
%     112.578716 chorus
%     129.565932 outro
%     138.062064 end 
    segments = 0:3;
    labels = [
        'intro '
        'verse '
        'chorus'
        'outro '];
     tannot = [
        0.0 0 
        8.495568 1
        25.486704 2
        42.475328 1
        59.47014 2
        78.594744 1
        95.585708 2
        112.578716 2
        129.565932 3
        138.062064 -1];
    dt = diff(tannot(:,1));
   fill = [ 0, dt(1), tannot(end,1)-dt(1), 0, 0, 0, 0
            tannot(2,1), dt(2), dt(3), dt(4), dt(5), dt(6), (tannot(end,1)-tannot(7,1))
            tannot(3,1), dt(3), dt(4), dt(5), dt(6), dt(7)+dt(8), (tannot(end,1)-tannot(9,1))
            tannot(9,1), (tannot(end,1)-tannot(9,1)), 0, 0, 0, 0, 0];



end

