function plotPitchErrorTimeDomain()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 4);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % read sample data
    [f, e_p, cLegend] = getData();
    
    % plot
    hold on
    plot(f, e_p(1, :), 'Color', getAcaColor('black'), 'LineWidth', .5)
    plot(f, e_p(2, :), 'Color', getAcaColor('main'), 'LineWidth', .5)
    set(gca, 'XScale', 'log')
    box on
    hold off
    axis([f(1) f(end) -90 90])
    xlabel('$f_0$/Hz');
    ylabel('$1200\cdot\log_2\left(\frac{\hat{f_0}}{f_0}\right)$ / Cent');
    lh = legend(cLegend);
    set(lh, 'Location', 'NorthWest', 'Interpreter', 'latex')

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f, e_p, cLegend] = getData()

    f_s = [44100,96000];
    f = linspace(100, 5000, 2^16);
    cLegend = {};
    
    for i=1:length(f_s)
        TinSamples(i, :) = f_s(i) ./ f;
        TqInSamples(i, :) = round(TinSamples(i, :));
        e_p(i, :) = 1200 * log2(TinSamples(i, :) ./ TqInSamples(i, :));
        cLegend{i} = ['$f_\mathrm{S} = ' num2str(f_s(i)/1000) '$ kHz'];
    end
    cLegend = char(cLegend);
end

