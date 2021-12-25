function plotCheckerBoard ()

    % generate new figure
    hFigureHandle = generateFigure(7,4);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    [kernel] = computeFilter_I(32);

    meshc(kernel)
    set(gca,'XTickLabels',[],'YTickLabels',[],'ZTickLabels',[])
    set(findobj(gcf, 'type','axes'), 'Visible','off')
    view(-116,45)

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [kernel] = computeFilter_I(iFilterSize)
    w = kron( [-1 1; 1 -1], ones(iFilterSize/2,iFilterSize/2) );
    kernel = w.*(gausswin(iFilterSize) *gausswin(iFilterSize)');
end