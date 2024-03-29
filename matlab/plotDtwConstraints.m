function plotDtwConstraints ()

    % check for dependency
    if(exist('ToolSimpleDtw') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 4);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName1 = 'sq1.wav';
    cName2 = 'sq2.wav';

    cXlabel = '$n_\mathrm{A}$';
    cYlabel = '$n_\mathrm{B}$';

    % read audio and generate plot data
    [seq1, seq2, D, p, C] = getData(cAudioPath, cName1, cName2);

    % plot
    subplot(131)
    imagesc(0:size(D, 2)-.5, 0:size(D, 1)-.5, D);
    axis('tight')
    xlabel(cXlabel)
    ylabel(cYlabel)
    zlabel('distance')

    m = size(D, 2) / size(D, 1);
    T = 35;
    D1 = D;
    for i = 1:size(D, 1)
        for j = T:size(D, 2)
            if (j >= round(m*i)+T)
                D1(i, j) = max(max(D));
            end
        end
    end
    for i = T:size(D, 1)
        for j = 1:size(D, 2)
            if (j <= round(m*i)-T)
                D1(i, j) = max(max(D));
            end
        end
    end
    
    subplot(132)
    imagesc(0:size(D, 2)-.5, 0:size(D, 1)-.5, D1);
    xlabel(cXlabel)
    ylabel(cYlabel)
    title('max time deviation')
    

    m = 3.5;
    T = 1;
    D2 = D;
    for i = 1:size(D, 1)
        for j = T:size(D, 2)
            if (j >= round(m*i)+T || j >= round(1/m*i+size(D, 2)-size(D, 1)/m+T))
                D2(i, j) = max(max(D));
            end
        end
    end
    for i = T:size(D, 1)
        for j = 1:size(D, 2)
            if (j <= round(1/m*i)-T || j < round(m*i+size(D, 2)-m*size(D, 1)-T))
                D2(i, j) = max(max(D));
            end
        end
    end
    
    subplot(133)
    imagesc(0:size(D, 2)-.5, 0:size(D, 1)-.5, D2);
    xlabel(cXlabel)
    ylabel(cYlabel)
    title('max tempo deviation')
    colormap(getColorMap());

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [seq1, seq2, D, p, C] = getData(cAudioPath, cName1, cName2)
    % read data
    [seq1] = audioread([cAudioPath '/' cName1]);
    [seq2] = audioread([cAudioPath '/' cName2]);
    N = length(seq2);
    M = length(seq1);
    
    % compute distance matrix
    D = (repmat(seq1(:), 1, N)-repmat(seq2(:)', M, 1))'.^2;

    % compute DTW
    [p, C] = ToolSimpleDtw(D);    
end

function c = getColorMap()
    c = ones(256, 3);
    c(1,:) = [ 0.242200000000000	0.150400000000000	0.660300000000000];
    for i = 2:size(c, 1)
        fFrac = (i-1)/size(c,1);
        c(i,:) = (1-fFrac) * c(1,:) + fFrac * c(end,:);
    end
end