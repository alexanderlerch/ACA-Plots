function plotDtwCost ()

    % check for dependency
    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,4);
    
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

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [seq1, seq2, D, p, C] = getData(cAudioPath, cName1, cName2)

    % read data
    [seq1]      = audioread([cAudioPath '/' cName1]);
    [seq2]      = audioread([cAudioPath '/' cName2]);
    N           = length(seq2);
    M           = length(seq1);

    % compute distance matrix
    D           = (repmat(seq1(:),1,N)-repmat(seq2(:)',M,1))'.^2;

    % compute path and cost
    [p, C]      = ToolSimpleDtw(D);    
end