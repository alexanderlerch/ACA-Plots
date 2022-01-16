function plotNovelty ()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,7);
    
    iStart  = 800;
    iLength = 65536;
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];

    % file path
    cName = 'sax_example.wav';

    % label strings
    cYLabel = 'Envelope';
    cLegend = 'Threshold';

    % read audio and generate plot data 
    [tx,x,tv,v,td,d,tg,g,onsetidx] = getData ([cAudioPath, cName]);

    % plot
    subplot(211),
    hold on;
    plot(tx,abs(x),'Color',.8*[1 1 1]);
    plot(tv,v,'Color',.3*[1 1 1]);
    hold off;
    set(gca,'YTickLabel',[])
    ylabel(cYLabel)
    axis([tx(1) tx(end) 0 1.01])
    box on;
    
    subplot(212),
    plot(td,d)
    hold on;
    plot(tg,g(1,:))
    stem(td(onsetidx),d(onsetidx),'fill','b');
    hold off;
    xlabel('$t / \mathrm{s}$')
    legend('Novelty',cLegend,'Onsets')
    axis([td(1) td(end) 0 max(d)*1.1])
    set(gca,'YTickLabel',[])
    ylabel('$d(n)$')
    
    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [tx,x,tv,v,td,d,tg,G_T,iOnsetIdx] = getData (cInputFilePath)

    % init
    iBlockLength= 4096;
    iHopLength  = 512;
    iStart      = 1;
    iLength     = 280000;

    % read audio
    [x, fs] = audioread(cInputFilePath, [iStart+1, iStart+iLength]);
    tx      = linspace(0,length(x)/fs,length(x));
    
    % pre-processing: down-mixing
    x = ToolDownmix(x);

    % pre-processing: normalization
    x = ToolNormalizeAudio(x);

    % compute novelty
    [d, td, G_T, iOnsetIdx] = ComputeNoveltyFunction ('Flux', x, fs, [], iBlockLength, 12);

    % compute envelope for visualization
    [v, tv] = ComputeFeature ('TimePeakEnvelope', x, fs, hann(iBlockLength,'periodic'), iBlockLength, iHopLength);
    v       = 10.^(v(1,:)*.05);
    
    tg      = td;
    
end

