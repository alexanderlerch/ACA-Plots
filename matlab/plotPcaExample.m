function displayPcaExample()

    % check for dependency
    if (exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,6);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    % generate plot data
    [v,score,latent,cFeatureNames] = getData([cAudioPath,cName]);

    % plot
    subplot(2,2,1)
    plot(v'), 
    grid on, 
    xlabel('$n$')
    ylabel('$v(n)$')
    axis([1 size(v,2) min(min(v)) max(max(v))])
    
    score = score(:,1:2);
    subplot(222)
    plot(score), 
    grid on
    xlabel('$n$')
    ylabel('$pc(n)$')
    axis([1 size(v,2) min(min(score)) max(max(score))])
    
    subplot(212)
    plot(latent), 
    grid on
    hold on; 
    plot(ones(1,size(v,1)),'Color',[.6 .6 .6]); 
    hold off;
    xlabel('component')
    ylabel('eigenvalue');
    set(gca,'XTick', 1:length(latent))
    axis([1 length(latent) 0 max(latent)+.1 ])
    % fix label that is weirdly outside of plot
    p = get(gca,'Position');
    set(gca,'Position',[p(1) p(2)+0.05 p(3) p(4)-0.02]);
    
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [v,score, latent,cFeatureNames] = getData(cInputPath)

    cFeatureNames = char('SpectralCentroid',...
        'SpectralRolloff',...
        'SpectralSpread',...
        'TimeZeroCrossingRate',...
        'TimePeakEnvelope');

    iNumBlocks = 500;
    
    % read audio
    [x,fs] = audioread(cInputPath);
    x      = x/max(abs(x));

    % exract features
    [tmp, t] = ComputeFeature (deblank(cFeatureNames(1,:)), x, fs);
    v = tmp(:,1:iNumBlocks);
    for (i = 2:size(cFeatureNames,1))
        [tmp, t] = ComputeFeature (deblank(cFeatureNames(i,:)), x, fs);
        v = [v;tmp(1,1:iNumBlocks)];
    end
    
    %norm
    m = median(v,2);
    for (i = 1:size(v,1))
        v(i,:)  = v(i,:) - m(i);
        s       = sqrt(v(i,:)*v(i,:)'/length(v));
        v(i,:)  = v(i,:) / s;
    end
    
    % pca
    [coeff, score, latent] = ToolPca(v');
end