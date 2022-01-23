function plotBeatGrid()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 6);
    
    % set output path relative to script location and to script name
    [cPath, cAudioName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cAudioName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cAudioName = 'MusicDelta_Britpop_Drum.wav';
    cAnnoBeatName = 'MusicDelta_Britpop_MIX.beats';
    cAnnoOnsetName = 'MusicDelta_Britpop_class.txt';

    % read audio and generate plot data
    [x, t, to, tb, tdb] = getData ([cAudioPath, cAudioName], [cAudioPath, cAnnoBeatName], [cAudioPath, cAnnoOnsetName]);

    % label string
    cXLabel = '$t / \mathrm{s}$';

    % plot 
    subplot(3, 1, 1)
    plot(t, x);
    axis([t(1)-.05 t(end) -1 1])
    ylabel('$x(t)$')
    set(gca, 'YTickLabels', {})
    set(gca, 'XTickLabels', {})

    subplot(3, 1, [2 3])
    hold on;
    line([to to], [.66 1], 'Color', [0.6 0.6 0.6], 'LineWidth', 2)
    line([tb tb], [.33 .66], 'Color', [0.3 0.3 0.3], 'LineWidth', 3)
    line([tdb tdb], [0 .33], 'Color', [0 0 0], 'LineWidth', 4)
    hold off;
    xlabel(cXLabel);
    box on;
    axis([t(1)-.05 t(end) 0 1])
    set(gca, 'YTick', [.166 .5 .834])
    set(gca, 'YTickLabels', {'Downbeat', 'Beat', 'Onset'})
    pos = get(gca, 'Position');
    set(gca, 'Position', [pos(1) pos(2)+.05 pos(3) pos(4)]);

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)

end

function [x, t, to, tb, tdb] = getData (cAudio, cBeat, cOnset)

    iStart = 337806;
    iStop = 433375;
    [x, f_s] = audioread(cAudio, [iStart iStop]);

    %pre-proc
    x = mean(x, 2);
    x = x / max(abs(x));
    t = (0:length(x)-1) / f_s;
 
    % read ground truth
    tb = load(cBeat);
    to = readmatrix(cOnset);

    %truncate ground truth
    t_start = iStart / f_s;
    t_stop = iStop / f_s;
    
    tb = tb(:, 1);
    iNewStart = min(find(tb >= t_start));
    iNewStop = max(find(tb < t_stop));
    tb = tb(iNewStart:iNewStop) - t_start;
    
    to = unique(floor(100*to(:, 1))/100);
    iNewStart = min(find(to >= t_start));
    iNewStop = max(find(to < t_stop));
    to = to(iNewStart:iNewStop) - t_start;
    dto = diff([-1;to]);
    i = find(dto >.01);
    to = to(i);
    to(9) = to(9)+.01;
    
    tdb = tb(1);
end
    
