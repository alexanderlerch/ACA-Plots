function plotF0Zcr ()
    
    % generate new figure
    hFigureHandle = generateFigure(13.12, 6);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    % read audio and generate plot data
    [t, x, T_0, hist_x, diff_i, z_loc] = getData ([cAudioPath, cName]);

    % set the strings of the axis labels 
    cXLabel1 = '$t\; [\mathrm{s}]$';
    cXLabel2 = '$\Delta t_\mathrm{ZC}\; [\mathrm{ms}]$';
    cYLabel1 = '$x(t)$';
    cYLabel2 = '\# of occurences';

    % plot
    subplot(211), 
    plot(t, x, 'LineWidth', .5),
    hold on;
    stem(t(z_loc), zeros(1, length(z_loc)), 'MarkerFaceColor', getAcaColor('main'), 'MarkerEdgeColor', getAcaColor('main', true), 'MarkerSize', 2);
    hold off;
    axis([t(1) t(end) -1 1])
    xlabel(cXLabel1)
    ylabel(cYLabel1)

    subplot(212)
    h = histogram(diff_i, hist_x, 'EdgeColor', getAcaColor('darkgray', true), 'FaceColor', getAcaColor('darkgray'));
    hold on;
    h1 = line(T_0/2 * ones(1, 2), [0 23], 'LineWidth', 2.5, 'Color', getAcaColor('main'));
    hold off;
    axis([hist_x(1) hist_x(end) 0 23]);
    box on;

    xtick = get(gca, 'XTick');
    xtick = sort([xtick T_0/2]);
    set(gca, 'XTick', xtick);
    xticklabel = get(gca, 'XTickLabel');
    xticklabel(xtick == T_0/2) = {'$\frac{\hat{T}_0}{2}$'};
    xticklabel(xtick == xtick(4)) = {'~'};
    set(gca, 'XTickLabel', xticklabel)
    xlabel(cXLabel2)
    ylabel(cYLabel2)

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [t, x, T_0, hist_i, i_tmp, z_loc] = getData(cInputFilePath)

    iStart = 66000;
    iLength = 4096;
    
    % read audio
    [x, f_s] = audioread(cInputFilePath, [iStart iStart+iLength-1]);
    t = linspace(0, length(x)/f_s, length(x));
    x = x / max(abs(x));

    z_loc = find(x(1:end-1)  .*  x(2:end)  < 0);
    i_tmp = diff(z_loc);
    %  average distance of zero crossings indicates half period
    T_0 = 2 * mean(i_tmp); 
    hist_i = 51:83;

    % convert to time
    i_tmp = i_tmp / f_s;
    hist_i = hist_i / f_s;
    T_0 = T_0 / f_s;
 
    % convert to Hz
    %f_0 = f_s ./ T_0;
end
