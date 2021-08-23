function plotCheckerBoard ()


    % generate new figure
    hFigureHandle = generateFigure(7,4);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    [kernel] = computeFilter(32);

    meshc(kernel)
    set(gca,'XTickLabels',[],'YTickLabels',[],'ZTickLabels',[])
    view(-116,45)

    printFigure(hFigureHandle, cOutputPath)
end

function [kernel] = computeFilter(iFilterSize)
    w = kron( [-1 1; 1 -1], ones(iFilterSize/2,iFilterSize/2) );
    kernel = w.*(gausswin(iFilterSize) *gausswin(iFilterSize)');
end