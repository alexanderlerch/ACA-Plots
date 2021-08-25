function plotDtwCost ()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,4);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName1 = 'sq1.wav';
    cName2 = 'sq2.wav';

    [seq1, seq2, D, p, C] = getData(cAudioPath, cName1, cName2);

    subplot(131)
    waterfall(0:size(D,2)-.5,0:size(D,1)-.5,D);view(150,75)
    axis('tight')
    xlabel('$n_\mathrm{A}$')
    ylabel('$n_\mathrm{B}$')
    title('Distance')

    subplot(132)
    imagesc(0:size(D,2)-.5,0:size(D,1)-.5,D);
    axis('tight')
    xlabel('$n_\mathrm{A}$')
    ylabel('$n_\mathrm{B}$')
    title('Distance')

    subplot(133)
    imagesc(0:size(D,2)-.5,0:size(D,1)-.5,C);
    colormap jet;
    xlabel('$n_\mathrm{A}$')
    ylabel('$n_\mathrm{B}$')
    title('Cost')

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