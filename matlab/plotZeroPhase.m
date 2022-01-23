function plotZeroPhase()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 7);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % get data to plot
    [x, ytmp, y] = getData();

    % set labels
    cXLabel = '$i$';
    cYLabel1 = '$x(i)$       ';
    cYLabel2 = '$y_\mathrm{tmp}(i)$ ';
    cYLabel3 = '$y(i)$       ';


    % plot data
    subplot(311)
    plot(x)
    ylabel(cYLabel1)
    axis([0 length(x)-1 0 1.1]), grid on

    subplot(312)
    plot(ytmp)
    ylabel(cYLabel2)
    axis([0 length(x)-1 0 1.1]), grid on

    subplot(313)
    plot(y)
    ylabel(cYLabel3)
    axis([0 length(x)-1 0 1.1]), grid on

    xlabel(cXLabel);

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function[x, ytmp, y] = getData()
    
    % configuration
    alpha = .97;
    x = zeros(1500, 1);
    x(501:1000) = 1;

    % filtering
    ytmp = filter(1-alpha, [1 -alpha], x);
    y = filter(1-alpha, [1 -alpha], flipud(ytmp));
end
