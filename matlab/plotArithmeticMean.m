function plotArithmeticMean ()

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


    [tv,v,mu_v,q_v] = getData ([cAudioPath,'/',cName], cFeatureName);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the strings of the axis labels
    cXLabel = '$t / \mathrm{s}$';
    cYLabel1 = '$v_\mathrm{SC}(n)$';
    cYLabel2 = '$RFD(v)$';

    subplot(211), 
    plot(tv,v),
    axis([tv(1) tv(end) 0 max(v)])
    hold on;
    line([tv(1) tv(end)],mu_v*ones(1,2),'LineWidth', 2,'Color',[234/256 170/256 0])
    line([tv(1) tv(end)],q_v*ones(1,2),'LineWidth', 2,'Color',[0 0 1])
    hold off;
%     text(1.7, 2700, sprintf('$\\mu_x =%2.1f$',mean(v)));
%     text(1.7, q_v-500, sprintf('$Q_v(0.5)=%2.1f$',mean(v)));
    xlabel(cXLabel)
    ylabel(cYLabel1)

    subplot(212)
    histogram(v,100,'Normalization','probability')
    h = findobj(gca,'Type','patch');
    %h.FaceColor = [0.5 0.5 0.5];
    %h.EdgeColor = 'w';
    hold on;
    h1 = line(mu_v*ones(1,2), [0 0.06],'LineWidth', 2.5,'Color',[234/256 170/256 0]);
    h2 = line(q_v*ones(1,2), [0 0.06],'LineWidth', 2.5,'Color',[0 0 1]);
    hold off;
%     text(2250, 0.05,);
%     text(q_v-1250, 0.05, );
    cLegend1 =  sprintf('$\\mu_v =%2.1f$',mu_v);
    cLegend2 = sprintf('$Q_v(0.5)=%2.1f$',q_v);
    xlabel('$v_\mathrm{SC}$')
    ylabel(cYLabel2)
    legend([h1 h2],cLegend1,cLegend2)
    
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
function [tv,v, mu_v,q_v] = getData (cInputFilePath, cFeatureName)

    [x, fs] = audioread(cInputFilePath);
    x       = x/max(abs(x));

    [v, tv] = ComputeFeature (cFeatureName, x, fs);

    % avg feature
    mu_v = mean(v);
    
    q_v = median(v);

end
