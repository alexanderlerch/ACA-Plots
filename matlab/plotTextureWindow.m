function plotTextureWindow()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,8);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath     = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath      = [cPath '/../audio'];

    % file path
    cFile = 'sax_example.wav';

    cFeatureNames = char('SpectralCentroid');
    
    
    [t,x,tv,v,tv2,v2] = getData ([cAudioPath,'/',cFile], cFeatureNames);

    subplot(311)
    plot(t,x)
    xlabel('$t/\mathrm{s}$')
    ylabel('$x(t)$')
    axis([t(1) t(end) -1 1]);
    
    subplot(312)
    plot(v)
    xlabel('$n$')
    ylabel('$v(n)$')
    axis([0 length(v)-1 0 max(v)]);
    
    
    subplot(313)
    curve1 = v2(1,:) + v2(2,:);
    curve2 = v2(1,:) - v2(2,:);
    x2 = [0:length(v2)-1, fliplr(0:length(v2)-1)];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween, [234/256 170/256 0], 'EdgeColor', [234/256 170/256 0], 'FaceAlpha', .5);
    hold on;
    plot(tv2,v2(1,:),'k')
    hold off;
    xlabel('$n_\mathrm{W}$')
    legend('$\sigma_v(n_\mathrm{W})$','$\mu_v(n_\mathrm{W})$','location','northwest');
    axis([0 length(v2)-1 0 8000]);
    printFigure(hFigureHandle, cOutputPath)
end

function [t,x,tv,v,tv2,v2] = getData (cInputFilePath, cFeatureNames)

    iTextureWindowSize = 20;
    iTextureWindowHop  = floor(iTextureWindowSize/2);
    
    [x, fs] = audioread(cInputFilePath);
    t       = linspace(0,length(x)/fs,length(x));
    x       = x/max(abs(x));

    [v,tv] = ComputeFeature (deblank(cFeatureNames(1,:)), x, fs);
    v_pad  = [zeros(1,iTextureWindowHop) v zeros(1,iTextureWindowSize)];
    for n = 1:floor(length(v)/iTextureWindowHop)-1
        v2(1,n)  = mean(v_pad(1,(n-1)*iTextureWindowHop+1:(n-1)*iTextureWindowHop+iTextureWindowSize));
        v2(2,n)  = std(v_pad(1,(n-1)*iTextureWindowHop+1:(n-1)*iTextureWindowHop+iTextureWindowSize));
    end
    tv2 = 0:length(v2)-1;
end
