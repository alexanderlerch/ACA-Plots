function plotStandardDeviation ()

    % check for dependency
    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    
    % generate new figure
    hFigureHandle = generateFigure(13.12,8);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'sax_example.wav';
    cFeatureName = char('SpectralCentroid');

    % read audio and get plot data
    [tv,v,mu_v,sigma_v] = getData ([cAudioPath,'/',cName], cFeatureName);

    % set the strings of the axis labels
    cXLabel = '$t / \mathrm{s}$';
    cYLabel1 = '$v(n)$';
    cYLabel2 = '$RFD(v)$';

    %plot
    subplot(211), 
    plot(tv,v),
    axis([tv(1) tv(end) 0 max(v)])
    xlabel(cXLabel)
    ylabel(cYLabel1)

    subplot(212)
    histogram(v,100,'Normalization','probability')
    h = findobj(gca,'Type','patch');
    hold on;
    annotation(hFigureHandle,'doublearrow',[0.27 0.37],[0.35 0.35],'Color',[234/256 170/256 0]);
    hold off;
    text(2250, 0.052, sprintf('$\\sqrt{\\sigma_v^2} =%2.1f$',sigma_v));
    xlabel('$v$')
    ylabel(cYLabel2)
    
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [tv,v, mu_v, sigma_v] = getData (cInputFilePath, cFeatureName)

    iFFTLength = 4096;
    
    % read audio
    [x, fs] = audioread(cInputFilePath);
    t       = linspace(0,length(x)/fs,length(x));
    x       = x/max(abs(x));

    % extract feature
    [v, tv] = ComputeFeature (cFeatureName, x, fs);

    % avg pitch chroma
    mu_v = mean(v);
    sigma_v = std(v);
end
