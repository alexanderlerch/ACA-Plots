function plotDataSplit()

    % generate new figure
    hFigureHandle = generateFigure(7,4.5);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % retrieve plotdata
    [x,labels] = getData ();

    % plot
    p = pie(x, [0 1 1], labels);
    colormap([0.6                      0.6                      0.6
             0                         0                         1
             234/256                    170/256                 0]);

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [x, labels] = getData ()

    x = [.75 .1 .15];
    labels = {'Train','Validation','Test'};
end

