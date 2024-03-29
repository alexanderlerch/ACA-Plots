function plotHarmonics()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 3);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % generate plot data
    harm = ones(1, 8);
    for (k = 1:length(harm))
        harm(k) = harm(k) * 1 / k^2;
    end
    
    %plot
    stem(20*log10(harm), 'filled', 'BaseValue',-40, 'MarkerFaceColor', getAcaColor('darkgray'), 'MarkerEdgeColor', getAcaColor('darkgray', true))
    
    hold on;
    stem(1, 20*log10(harm(1)), 'MarkerFaceColor', getAcaColor('main'), 'MarkerEdgeColor', getAcaColor('main', true))
    hold off
    xlabel('$f/f_0$')
    ylabel('magnitude$\; [dB]$')
    axis([1 8 -40 5])

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

