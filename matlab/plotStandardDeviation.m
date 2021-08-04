function plotStandardDeviation ()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    
    hFigureHandle = generateFigure(13.12,8);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'sax_example.wav';
    cFeatureName = char('SpectralCentroid');


    [tv,v,mu_v,sigma_v] = getData ([cAudioPath,'/',cName], cFeatureName);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the strings of the axis labels
    cXLabel = '$t / \mathrm{s}$';
    cYLabel1 = '$v(n)$';
    cYLabel2 = '$RFD(v)$';

    subplot(211), 
    plot(tv,v),
    axis([tv(1) tv(end) 0 max(v)])
%     hold on;
%     line([tv(1) tv(end)],mu_v*ones(1,2),'LineWidth', 2.5,'Color',[234/256 170/256 0])
%     hold off;
%    text(1.7, 2700, sprintf('$\\mu_x =%2.1f$',mean(v)));
    xlabel(cXLabel)
    ylabel(cYLabel1)

    subplot(212)
    histogram(v,100,'Normalization','probability')
    h = findobj(gca,'Type','patch');
    %h.FaceColor = [0.5 0.5 0.5];
    %h.EdgeColor = 'w';
    hold on;
    annotation(hFigureHandle,'doublearrow',[0.27 0.37],[0.35 0.35],'Color',[234/256 170/256 0]);
    hold off;
    text(2250, 0.055, sprintf('$\\sqrt{\\sigma_v} =%2.1f$',sigma_v));
    %text(2250, 25, sprintf('$\\mu_v =%2.1f$',sigma_v));
    xlabel('$v$')
    ylabel(cYLabel2)
    
%     % plot data
%     subplot(2,10,1:9), imagesc(t,f/1000,X)
%     axis xy;
%     %xlabel(cXLabel)
%     ylabel(cYLabel1)
%     set(gca,'XTickLabel',[])
% 
%     subplot(2,10,11:19), imagesc(t,pclabel,pc)
%     axis xy;
%     set(gca,'YDir','normal','YTick',[0 2 4 6 8 10],'YTickLabel',{'C', 'D', 'E', 'F\#', 'G\#', 'A\#'})
%     xlabel(cXLabel)
%     ylabel(cYLabel2)
%     
%     subplot(2,10,20)
%     plot(pcm,pclabel)
%     set(gca,'YTickLabel',{})
%     set(gca,'XTickLabel',{})
%     axis([0 max(pcm) -.5 11.5])

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

% example function for data generation, substitute this with your code
function [tv,v, mu_v, sigma_v] = getData (cInputFilePath, cFeatureName)

    iFFTLength = 4096;
    [x, fs] = audioread(cInputFilePath);
    t       = linspace(0,length(x)/fs,length(x));
    x       = x/max(abs(x));

    [v, tv] = ComputeFeature (cFeatureName, x, fs);

    % avg pitch chroma
    mu_v = mean(v);
    sigma_v = std(v);

end
