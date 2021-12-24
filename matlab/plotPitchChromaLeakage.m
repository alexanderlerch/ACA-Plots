function plotPitchChromaLeakage()

    % generate new figure
    hFigureHandle = generateFigure(13.12,6);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
  
    % get plot data
    [x,y,pc] = getData ();

    % label strings
    cXLabel1 = '$f / \mathrm{Hz}$';
    cXLabel2 = 'pitch class';
    cYLabel1 = '$|X(k)|$';
    cYLabel2 = '$v_\mathrm{PC}$';

    % plot
    subplot(211),
    stem(x,y, 'k','fill')
    grid on
    axis([200 x(end) 0 1])
    ylabel(cYLabel1);
    xlabel(cXLabel1);
    
    subplot(212)
    bar(pc,'k')
    xlabel(cXLabel2);
    ylabel(cYLabel2);
    axis([.5 12.5 0 1])
    grid on
    set(gca,'XTick',1:12)
    set(gca,'XTickLabel',{'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'})
    set(gca,'YTick',0:.5:1)
    
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f,A,pc] = getData()
    f_A4            = 440;
    f_F             = 220;
    numHarmonics    = 10;

    f = f_F*(1:numHarmonics);
    A = 1./(1:numHarmonics);

    pc = zeros(1,12);

    % create pitch chroma
    for (i = 1:numHarmonics)
        idx = mod(round(69 + 12*log2(f(i)/f_A4)), 12) + 1;
        pc(idx) = pc(idx) + A(i);
    end
    pc = pc/sum(pc);
end

