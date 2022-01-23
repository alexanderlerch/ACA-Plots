function plotPitchErrorFreqDomain()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 4);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    % read sample data
    [f, e_p, cLegend] = getData();
    
    % plot
    plot(f, e_p, 'LineWidth', .5);
    axis([f(1) 2000 -1000 1000])
    xlabel('$f_0$/Hz');
    ylabel('$1200\cdot\log_2\left(\frac{\hat{f_0}}{f_0}\right)$ / Cent');
    lh = legend(cLegend);
    set(lh, 'Location', 'NorthEast', 'Interpreter', 'latex')

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f, e_p, cLegend] = getData()

    f_s = [44100, 96000];
    iLength = 2048;
    f = linspace(20, 3000, 2^16);
    cLegend = {};
    
    for i=1:length(f_s)
        fq(i, :) = round(f/f_s(i)*iLength ) * f_s(i) / iLength;
        e_p(i, :) = 1200 * log2(f./fq(i, :));
        cLegend{i} = ['$f_\mathrm{S} = ' num2str(f_s(i)/1000) '$ kHz'];
    end
    cLegend = char(cLegend);
end

