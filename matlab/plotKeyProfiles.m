function plotKeyProfiles  ()

    % generate new figure
    hFigureHandle = generateFigure(13.2, 8);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    [y, d, circ] = getData ();

    % set the strings of the axis labels
    cYLabel2 = 'pitch class';
    
    % plot 
    subplot(311),
    h = bar(0:11, abs(y)', 1, 'group');
    xlabel('pitch class index')
    ylabel('key profile')
    axis([-.5 11.5 0 1.1])
    h_legend = legend('o', 'd', '5', 'p', 't', 'Location', 'eastoutside');
    
    subplot(3, 7, [8:10, 15:17])
    plot(0:12, d)
    set(gca, 'XTick', 0:12)
    set(gca, 'XTickLabel', {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B', 'C'})
    axis([0 12 0 1.5])
    xlabel('key')
    ylabel('distance to C Maj.')

    subplot(3,7, [11:14, 18:21])
    scale = 1.9 / sqrt(2);
    [theta, idx] = sort(circ+12);
    idx = [idx idx(1)];
    theta = [theta theta(1)] /  12 * 2 * pi;
    d = d * scale;
    for i = 1:size(d, 1)
        h = polarplot (theta-pi/2, d(i,idx));
        hold on;
    end
    hold off; 
    ax = gca;
    ax.ThetaDir = 'clockwise';
    set(gca, 'TickLabelInterpreter', 'latex')
    set(gca, 'RTickLabel', [])
    set(gca, 'ThetaTickLabel', {'A', 'E', 'B', 'F\#', 'Db', 'Ab', 'Eb', 'Bb', 'F', 'C', 'G', 'D'})
%     myColorMap = [ 0       0       0
%                     234/256 170/256 0
%                     0       0       1
%                     1       0       0
%                     0       0.5     0
%                     0       0.75    0.75
%                     0.75    0       0.75
%                     0.75    0.75    0
%                     0.25    0.25    0.25];
    myColorMap = [  getAcaColor('black')
                    getAcaColor('main')
                    getAcaColor('gt')
                    getAcaColor('blue')
                    getAcaColor('lightgray')
                             1                         0                         0
                             0                       0.5                         0
                             0                      0.75                      0.75
                          0.75                         0                      0.75
                          0.75                      0.75                         0
                          0.25                      0.25                      0.25
                          .33                        .66                         1];
    set(gca, 'ColorOrder', myColorMap); 

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [kp,dist,circ] = getData ()

    circ = [0 -5 2 -3 4 -1 6 1 -4 3 -2 5];
    kp =[
        1       0       0       0       0       0       0       0       0       0       0       0 % diatonic
        1       0       1       0       1       1       0       1       0       1       0       1 % diatonic
        j*circ/12 % circle of fifths
        6.35    2.23    3.48    2.33    4.38    4.09    2.52    5.19    2.39    3.66    2.29    2.88 % krumhansl
        0.748   0.06    0.488   0.082   0.67    0.46    0.096   0.715	0.104	0.366	0.057	0.4]; % temperley
    kp(3, :) = exp(kp(3, :));

    % set the circle radius to 2
    R = 1;
    kp(3, :) = kp(3, :)*R;

    norm = sqrt(sum(kp.^2, 2));
    for i = 2:size(kp, 1)
        kp(i, :) = kp(i, :) / norm(i);
    end

    dist = zeros(size(kp, 1), size(kp, 1)+1);
    for k = 1:size(kp, 1)
        for i = 0:12
            dist(k, i+1) = sqrt((kp(k, :) - circshift(kp(k, :), [0 i])) * (kp(k, :) - circshift(kp(k, :), [0 i]))');
        end
    end
end
