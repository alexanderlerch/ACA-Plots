function plotSequenceAlignment ()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(10,5);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName1 = 'sq1.wav';
    cName2 = 'sq2.wav';

    [seq1, seq2, D, p, C] = getData(cAudioPath, cName1, cName2);

    seq1 = seq1-.4;
    seq2 = seq2+.4;
    for (i = 1:3:length(p))
        line([p(i,2) p(i,1)], [ seq1(p(i,2)) seq2(p(i,1))], 'LineWidth', .5, 'Color',[.5 .5 .5]);
    end
    hold on,plot(seq1)
    plot(seq2);hold off;
    axis([0 max(length(seq1),length(seq2)) -.8 .8]);
    set(gca,'YTick',[-.4 .4],'XTick',[])
    set(gca, 'YTickLabels',{'Seq.\ A','Seq.\ B'}); 
    grid off; 
    set(gca,'visible','off');
    

    printFigure(hFigureHandle, cOutputPath)
end

function [seq1, seq2, D, p, C] = getData(cAudioPath, cName1, cName2)
    [seq1]      = audioread([cAudioPath '/' cName1]);
    [seq2]      = audioread([cAudioPath '/' cName2]);
    N           = length(seq2);
    M           = length(seq1);

    D           = (repmat(seq1(:),1,N)-repmat(seq2(:)',M,1))'.^2;

    [p, C]      = ToolSimpleDtw(D);    
end