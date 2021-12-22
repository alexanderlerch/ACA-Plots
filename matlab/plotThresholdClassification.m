function plotThresholdClassification()

    % check for dependency
    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    
    % generate new figure
    hFigureHandle = generateFigure(13.12,7);
    
    % set output path relative to script location and to script name
    [cPath, cAudioName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cAudioName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cAudioName = 'MusicDelta_Britpop_Drum.wav';

    % read audio and get data to plot
    [x,t,v,tv,isOnset,G] = getData ([cAudioPath,cAudioName]);

    % specify labels
    cXLabel = '$t$ / s';
    cYLabel = '$v_\mathrm{peak}(n)$';

    % plot data
    subplot(2,1,1)
    hold on;
    plot(t,x,'Color',.8*[1 1 1]);
    plot(t,G*ones(1,length(t)));
    plot(tv,v,'k');
    hold off;
    axis([t(1) t(end) -1 1])
    xlabel(cXLabel)
    ylabel(cYLabel)
    
    % add G to YTicks
    ytick = [-1 -.5 0 1];
    ytick = sort([ytick G]);
    set(gca, 'YTick', ytick);
    yticklabel = get(gca,'YTickLabel');
    yticklabel(ytick == G) = {'$G$'};
    set(gca,'YTickLabel', yticklabel)

    subplot(212)
    stem(tv,isOnset,'fill','.k')
    xlabel('$n$');
    axis([t(1) t(end) -0.1 1.1])
    set(gca, 'YTick', [0 1])
    set(gca,'YTickLabels',{'no onset','onset'})

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [x,t,v,tv,isOnset,G] = getData (cAudio)

    iStart = 337806;
    iStop = 433375;
    
    [x, f_s] = audioread(cAudio, [iStart iStop]);

    %pre-proc
    x = mean(x,2);
    x = x/max(abs(x));
    t = (0:length(x)-1)/f_s;
 
    % extract envelope
    [v, tv] = ComputeFeature ('TimePeakEnvelope', x, f_s, [], 1024, 512);
    v       = 10.^(v(1,:)*.05);

    % thresholding
    G = .5;
    isOnset = zeros(size(v));
    isOnset(v>G) = 1;

end
    
