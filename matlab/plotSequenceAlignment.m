function plotSequenceAlignment ()

    % check dependency
    if(exist('ToolSimpleDtw') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(10, 4);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file names
    cName1 = 'sq1.wav';
    cName2 = 'sq2.wav';

    % read files and get plot data
    [seq1, seq2, D, p, C] = getData(cAudioPath, cName1, cName2);

    % plot
    seq1 = seq1-.4;
    seq2 = seq2+.4;
    for i = 1:3:length(p)
        line([p(i, 2) p(i, 1)], [ seq1(p(i, 2)) seq2(p(i, 1))], 'LineWidth', .5, 'Color', getAcaColor('mediumgray'));
    end
    hold on,
    plot(seq1)
    plot(seq2);
    hold off;
    axis([0 max(length(seq1),length(seq2)) -.8 .8]);
    set(gca, 'YTick', [-.4 .4], 'XTick', [])
    set(gca, 'YTickLabels', {'Seq.\ A', 'Seq.\ B'}); 
    grid off; 
    set(gca, 'visible', 'off');
    set(gcf, 'color', 'none');
    
    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [seq1, seq2, D, p, C] = getData(cAudioPath, cName1, cName2)

    % read sequences
    [seq1]	= audioread([cAudioPath '/' cName1]);
    [seq2] = audioread([cAudioPath '/' cName2]);
    N = length(seq2);
    M = length(seq1);

    % compute distances
    D = (repmat(seq1(:), 1, N)-repmat(seq2(:)', M, 1))'.^2;

    % compute path
    [p, C] = ToolSimpleDtw(D);    
end