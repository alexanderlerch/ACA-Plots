function plotKeyProfileKrumhansl()

    % generate new figure
    hFigureHandle = generateFigure(13.12,5);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate data
    [kp] = getData();

    % plot
    plot(kp,'-o','MarkerFaceColor','k')
    set(gca,'XTick',1:12)
    set(gca,'XTickLabel',{'C', 'C#', 'D', 'D#', 'E','F', 'F#', 'G', 'G#', 'A', 'A#','B','C'})
    axis([1 12 0.05 .16])
    ylabel('Key Profile (CMaj)')
    xlabel('Pitch Class')
   
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end


function [kp] = getData()

    kp =[
        6.35    2.23    3.48    2.33    4.38    4.09    2.52    5.19    2.39    3.66    2.29    2.88]; % krumhansl

    kp = kp/sum(kp);
end