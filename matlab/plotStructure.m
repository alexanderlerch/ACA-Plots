function plotStructure ()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,7);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'structure_example_1.mp3';

    [segments, fill, labels, t, x,tvrms,vrms] = getData([cAudioPath,'/',cName]);

    subplot(211)
    h = barh(segments,fill,0.99,'stacked','k');
    set(h([1 3 5 7]),'Visible','off')

    set(gca,'YTick', segments)
    set(gca,'YTickLabels', deblank(char(labels)))
    set(gca, 'YDir','reverse')
    axis([t(1) t(end) segments(1)-.5 segments(end)+.5])
    
    subplot(212)
    plot(t,x,'LineWidth',.5,'Color', .6*ones(1,3))
    hold on,
    plot(tvrms,vrms,'k')
    plot(tvrms,-vrms,'k')
    hold off;
    axis([t(1) t(end) -1.1 1.1 ])
    xlabel('$t$ / s')
    
    printFigure(hFigureHandle, cOutputPath)
end

function [segments, fill, labels,t,x,tvrms,vrms] = getData(cInputFilePath)

    %from HarmonixSet 0916_sowhat.txt
% 0.08823525 intro
% 11.51679525 verse
% 34.37391525 chorus
% 68.65959525 verse
% 91.51671525 chorus
% 125.80239525 bridge
% 144.84999525 chorus
% 175.32615525 outro
% 212.94516525 end
    labels = [
        'intro '
        'verse '
        'chorus'
        'bridge'
        'outro '];
segments = 0:size(labels,1)-1;
     tannot = [
        0.08823525 0
        11.51679525 1
        34.37391525 2
        68.65959525 1
        91.51671525 2
        125.80239525 3
        144.84999525 2
        175.32615525 4
        212.94516525 -1];
    
    dt = diff(tannot(:,1));
   fill = [ tannot(1,1), dt(1),                             tannot(end,1)-dt(1), 0, 0, 0, 0
            tannot(2,1), dt(2), dt(3), dt(4),               tannot(end,1)-dt(4), 0, 0
            tannot(3,1), dt(3), dt(4), dt(5), dt(6), dt(7), tannot(end,1)-dt(7)
            tannot(6,1), dt(6),                             tannot(end,1)-dt(6), 0, 0, 0, 0
            tannot(8,1), dt(8),                             tannot(end,1)-dt(8), 0, 0, 0, 0];

    
    % read audio
    [x, fs] = audioread(cInputFilePath);
    
    x = mean(x,2);
    x = x/max(x);
    t = linspace(0,length(x)/fs,length(x));
    [vrms, tvrms] = ComputeFeature (deblank('TimeRms'), x, fs, [], 65536, 4096);
    vrms = 10.^(vrms(1,:)*.05);
    vrms = vrms/max(vrms);



end

