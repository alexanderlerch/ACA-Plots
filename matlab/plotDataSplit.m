function plotDataSplit()

    hFigureHandle = generateFigure(9,7);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % retrieve plotdata
    [x,labels] = getData ();

    % plot
    pie(x, [0 1 1], labels);
    colormap([0.5                      0.5                      0.5
             0                         0                         1
             234/256                    170/256                 0]);
                             
    printFigure(hFigureHandle, cOutputFilePath)
end

function [x, labels] = getData ()

    x = [.7 .15 .15];
    labels = {'Train','Validation','Test'};

end

