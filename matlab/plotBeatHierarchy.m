function plotBeatHierarchy()

    % generate new figuredarkgray
    hFigureHandle = generateFigure(13.12, 6);
    
    % set output path relative to script location and to script name
    [cPath, cAudioName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cAudioName, 'plot', '')];

    % generate plot data
    [b44, b22, b34, b68] = getData ();

    % label string
    cXLabel = 'Tatum ticks';
    cYLabel = char('subbeat', 'beat', 'downbeat');

    % plot
    subplot(221)
    hold on;
    line([find(b44(1, :)==1); find(b44(1, :)==1)], [.66 1], 'Color', getAcaColor('darkgray'), 'LineWidth', 4)
    line([find(b44(2, :)==1); find(b44(2, :)==1)], [.33 .66], 'Color', getAcaColor('mediumgray'), 'LineWidth', 3)
    line([find(b44(3, :)==1); find(b44(3, :)==1)], [0 .33], 'Color', getAcaColor('lightgray', true), 'LineWidth', 2)
    hold off;
    axis([1 16 0 1])
    set(gca, 'YTick', [.166 .5 .834])
    set(gca, 'YTickLabels', cYLabel)
    title('4/4')

    subplot(222)
    hold on;
    line([find(b22(1, :)==1); find(b22(1, :)==1)], [.66 1], 'Color', getAcaColor('darkgray'), 'LineWidth', 4)
    line([find(b22(2, :)==1); find(b22(2, :)==1)], [.33 .66], 'Color', getAcaColor('mediumgray'), 'LineWidth', 3)
    line([find(b22(3, :)==1); find(b22(3, :)==1)], [0 .33], 'Color', getAcaColor('lightgray', true), 'LineWidth', 2)
    hold off;
    axis([1 16 0 1])
    set(gca, 'YTick', [.166 .5 .834])
    set(gca, 'YTickLabels', cYLabel)
    title('2/2')

    subplot(223)
    hold on;
    line([find(b34(1, :)==1); find(b34(1, :)==1)], [.66 1], 'Color', getAcaColor('darkgray'), 'LineWidth', 4)
    line([find(b34(2, :)==1); find(b34(2, :)==1)], [.33 .66], 'Color', getAcaColor('mediumgray'), 'LineWidth', 3)
    line([find(b34(3, :)==1); find(b34(3, :)==1)], [0 .33], 'Color', getAcaColor('lightgray', true), 'LineWidth', 2)
    hold off;
    xlabel(cXLabel);
    axis([1 12 0 1])
    set(gca, 'YTick', [.166 .5 .834])
    set(gca, 'YTickLabels', cYLabel)
    title('3/4')

    subplot(224)
    hold on;
    line([find(b68(1, :)==1); find(b68(1, :)==1)], [.66 1], 'Color', getAcaColor('darkgray'), 'LineWidth', 4)
    line([find(b68(2, :)==1); find(b68(2, :)==1)], [.33 .66], 'Color', getAcaColor('mediumgray'), 'LineWidth', 3)
    line([find(b68(3, :)==1); find(b68(3, :)==1)], [0 .33], 'Color', getAcaColor('lightgray', true), 'LineWidth', 2)
    hold off;
    xlabel(cXLabel);
    axis([1 12 0 1])
    set(gca, 'YTick', [.166 .5 .834])
    set(gca, 'YTickLabels', cYLabel)
    title('6/8')

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function     [b44, b22, b34, b68] = getData ()

    b44 = zeros(3, 16);
    b22 = zeros(3, 16);
    b34 = zeros(3, 12);
    b68 = zeros(3, 12);

    % subbeat
    b44(3, :) = 1;
    b22(3, :) = 1;
    b34(3, :) = 1;
    b68(3, :) = 1;
    
    % beat
    b44(2, [1 3 5 7 9 11 13 15]) = 1;
    b22(2, [1 5 9 13 ]) = 1;
    b34(2, [1 3 5 7 9 11 ]) = 1;
    b68(2, [1 4 7 10 ]) = 1;
    
    % downbeat
    b44(1, [1 9]) = 1;
    b22(1, [1 9]) = 1;
    b34(1, [1 7]) = 1;
    b68(1, [1 7]) = 1;
end
    
