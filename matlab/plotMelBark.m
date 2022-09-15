function plotMelBark()

    % check for dependency
    if(exist('ToolFreq2Mel') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 4);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    cXLabel = '$f\; [\mathrm{kHz}]$';
    % generate plot data
    [f, fMel, fBark, cLegendMel, cLegendBark] = getData();

    % plot
    subplot(121)
    hold on
    plot(f/1000, fMel(1, :), ':', 'Color', getAcaColor('main'))
    plot(f/1000, fMel(2, :), '-.', 'Color', getAcaColor('darkgray'))
    plot(f/1000, fMel(3, :), 'Color', getAcaColor('lightgray', true))
    set(gca, 'XScale', 'log')
    hold off
    legend (cLegendMel, 'Location', 'NorthWest');
    xlabel(cXLabel)
    ylabel('Mel')
    axis([f(1)/1000 f(end)/1000 0 4000])
    box on

    subplot(122)
    hold on
    plot(f/1000, fBark(1, :), ':', 'Color', getAcaColor('main'))
    plot(f/1000, fBark(2, :), '-.', 'Color', getAcaColor('darkgray'))
    plot(f/1000, fBark(3, :), 'Color', getAcaColor('lightgray', true))
    set(gca, 'XScale', 'log')
    hold off
    legend (cLegendBark, 'Location', 'NorthWest');
    xlabel(cXLabel)
    ylabel('Bark')
    axis([f(1)/1000 f(end)/1000 0 40])
    box on

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f, fMel, fBark, cLegendMel, cLegendBark] = getData()
    
    f = 50:16000;
    cLegendMel = char('Fant', 'Shaughnessy', 'Umesh');
    cLegendBark = char('Schroeder', 'Terhardt', 'Zwicker');

    for i = 1:size(cLegendMel, 1)
        fMel(i, :) = ToolFreq2Mel(f, deblank(cLegendMel(i, :)));
    end
    for i = 1:size(cLegendBark, 1)
        fBark(i, :) = ToolFreq2Bark(f, deblank(cLegendBark(i, :)));
    end
end