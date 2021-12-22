function plotDtwPath ()

    % check for dependency
    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,11);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName1 = 'sq1.wav';
    cName2 = 'sq2.wav';

    % read audio and generate plot data
    [seq1, seq2, D, p, C] = getData(cAudioPath, cName1, cName2);

    % plot
    subplot(5,5,22:25)
    plot(0:length(seq1)-1, seq1);
    xlabel('$n_\mathrm{A}$')
    ylabel('Seq.~A')
    axis ([0 length(seq1)-1 min(min(seq1),min(seq2)) max(max(seq1),max(seq2))]); 
    set(gca,'YTickLabels',[]);

    subplot(5,5,[1 6 11 16])
    plot(seq2, 0:length(seq2)-1);
    ylabel('$n_\mathrm{B}$')
    xlabel('Seq.~B')
    axis ([min(min(seq1),min(seq2)) max(max(seq1),max(seq2)) 0 length(seq2)-1]); grid on
    set(gca, 'YDir','reverse')
    set(gca,'XTickLabels',[]);

    subplot(5,5,[2:5 7:10 12:15 17:20])
    imagesc(0:size(D,2)-.5,0:size(D,1)-.5,D);
    colormap copper;
    box on;
    hold on; plot(p(:,2)-1,p(:,1)-1,'Color',[234/256 170/256 0]); hold off
    
    set(gca,'YTickLabels',[]);
    set(gca,'XTickLabels',[]);

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [seq1, seq2, D, p, C] = getData(cAudioPath, cName1, cName2)

% read audio
    [seq1]      = audioread([cAudioPath '/' cName1]);
    [seq2]      = audioread([cAudioPath '/' cName2]);
    N           = length(seq2);
    M           = length(seq1);

    % compute distance
    D           = (repmat(seq1(:),1,N)-repmat(seq2(:)',M,1))'.^2;

    % compute path
    [p, C]      = ToolSimpleDtw(D);    
end