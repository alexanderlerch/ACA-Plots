function plotChordDetection  ()
    
    % generate new figure
    hFigureHandle = generateFigure(13.12,8);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'chord_analysis.mp3';

    % read audio and generate plot data
    [t,P_E, P_T, p, chord_labels] = getData ([cAudioPath,'/',cName]);
    
    % set the strings of the axis labels
    cXLabel = '$t / \mathrm{s}$';
    cYLabel = 'Chord';
    
    YTick = [1  5  8  13  17  20  24]-1;

    % plot 
    subplot(221), 
    imagesc(t,0:23,P_E)
    ylabel(cYLabel)
    xlabel(cXLabel)
    set(gca,'YTick',YTick)
    set(gca,'YTickLabel',deblank(chord_labels(YTick+1,:)));

    subplot(222), 
    imagesc(0:23,0:23,P_T)
    set(gca,'XTickLabel',[0 5 10 15 20 25])
    ylabel(cYLabel)
    xlabel(cYLabel)
    set(gca,'YTick',YTick)
    set(gca,'YTickLabel',deblank(chord_labels(YTick+1,:)));
    set(gca,'XTick',YTick)
    set(gca,'XTickLabel',deblank(chord_labels(YTick+1,:)));

    ax=subplot(223); 
    imagesc(t,0:23,P_E)
    c=colormap(ax,'gray');
    colormap(ax,flipud(c));
    hold on; plot(t,p(1,:),'Color',[234/256 170/256 0],'LineWidth', 2); hold off
    ylabel(cYLabel)
    xlabel(cXLabel)
    set(gca,'YTick',YTick)
    set(gca,'YTickLabel',deblank(chord_labels(YTick+1,:)));

    ax =subplot(224); 
    imagesc(t,0:23,P_E)
    c=colormap(ax,'gray');
    colormap(ax,flipud(c));
    hold on; plot(t,p(2,:),'Color',[234/256 170/256 0],'LineWidth', 2); hold off
    ylabel(cYLabel)
    xlabel(cXLabel)
    set(gca,'YTick',YTick)
    set(gca,'YTickLabel',deblank(chord_labels(YTick+1,:)));
    
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

% example function for data generation, substitute this with your code
function [t,P_E, P_T, p, chord_labels] = getData (cInputFilePath)

    % initialize chord transition probs
    P_T = getChordTransProb_I();
    chord_labels  = char ('C Maj','C# Maj','D Maj','D# Maj','E Maj','F Maj',...
        'F# Maj','G Maj','G# Maj','A Maj','A# Maj','B Maj', 'c min',...
        'c# min','d min','d# min','e min','f min','f# min','g min',...
        'g# min','a min','a# min','b min');
    
    % read audio
    [afAudioData, f_s] = audioread(cInputFilePath, [1 20*44100]);
    
    % compute instantaneous chord probabilities
    [~, p, t, P_E] = ComputeChords (afAudioData, f_s);

end

function [P_T] = getChordTransProb_I()
    
    circ = [0 -5 2 -3 4 -1 6 1 -4 3 -2 5,...
            -3 4 -1 6 1 -4 3 -2 5 0 -5 2];
        
    % set the circle radius and distance
    R = 1;
    d = .5;
    
    x = R*cos(2*pi*circ/12);
    y = R*sin(2*pi*circ/12);
    z = [d*ones(1,12),...
        zeros(1,12)];
    
    for (m = 1:size(x,2))
        for (n = 1:size(x,2))
            P_T(m,n) = sqrt((x(m)-x(n))^2 + (y(m)-y(n))^2 + (z(m)-z(n))^2);
        end
    end
 
    P_T = .1+P_T;
    P_T = 1 - P_T/max(max(P_T));
    P_T = P_T ./ sum(P_T,1);
end
