function plotFingerprint ()

    % check for dependency
    if(exist('ComputeFingerprint') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,6);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName1 = 'pop_excerpt.wav';
    cName2 = 'pop_excerpt_lq.mp3';

    % read audio and generate plot data
    [F_orig,F_mp3,F_diff] = getData(cAudioPath, cName1, cName2);

    % plot
    h = subplot(131);
    imagesc(0:31,0:255,F_orig)
    colormap(h,[1 1 1; 0 0 0]);
    xlabel('Bit')
    ylabel('$n$')
    set(gca,'YTick', 0:32:256)
    set(gca,'XTick', 0:8:32)
    axis([0 32 0 256])

    h = subplot(132);
    imagesc(0:31,0:255,F_mp3)
    colormap(h,[1 1 1; 0 0 0]);
    xlabel('Bit')
    set(gca,'YTick', 0:32:256)
    set(gca,'YTickLabels', [])
    set(gca,'XTick', 0:8:32)
    axis([0 32 0 256])

    h = subplot(133);
    imagesc(0:31,0:255,F_diff)
    colormap(h, [1 1 1; 1 0 0]);
    xlabel('Bit')
    ylabel('$n$')
    set(gca,'YTick', 0:32:256)
    set(gca, 'yaxislocation', 'right');
    set(gca,'XTick', 0:8:32)
    axis([0 32 0 256])

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [F_orig, F_mp3, F_diff] = getData(cAudioPath, cName1, cName2)
    
    % read audio data and compute fingerprint
    [x,fs]  = audioread([cAudioPath '/' cName1]);
    [F_orig, tf] = ComputeFingerprint( x, fs );
    F_orig = F_orig(:,1:256)';
    
    % read audio data and compute fingerprint
    [x,fs]  = audioread([cAudioPath '/' cName2]);
    [F_mp3, tf] = ComputeFingerprint( x, fs );
    F_mp3 = F_mp3(:,1:256)';

    F_diff = abs(F_orig - F_mp3);
end

