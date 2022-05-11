function plotDataSplit()

    % generate new figure
    hFigureHandle = generateFigure(7, 4.5);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % retrieve plotdata
    [x,labels] = getData();

    % plot
    p = pie(x, [0 1 1], labels);
    colormap([getAcaColor('lightgray')
             getAcaColor('gt')
             getAcaColor('main')]);

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [x, labels] = getData ()

    x = [.75 .1 .15];
    labels = {'train', 'validation', 'test'};
end

