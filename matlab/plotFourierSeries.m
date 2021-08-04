function plotFourierSeries()

    hFigureHandle = generateFigure(13.12,6);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    cXLabel1        = '$t / T_0$';
    cXLabel2        = '$f / f_0$';
    cYLabel1        = '$x_\mathrm{saw}$';
    cYLabel2        = '$x_\mathrm{rect}$';
    cYLabel3        = '$a_\mathrm{saw}$';
    cYLabel4        = '$a_\mathrm{rect}$';

    aiOrder = [3 50];

    % configuration
    [t, x_sa, x_re, f_sa, f_re] = getData (aiOrder);  

    subplot(221)
    %subplot(2,5,1:3)
    plot(t,x_sa)
    ylabel(cYLabel1)
    axis([t(1) t(end) -1.3 1.3])
    set(gca,'XTickLabels',[])
    
    subplot(222)
    %subplot(2,5,4:5)
    stem(f_sa(:,3),'fill','MarkerSize',2,'MarkerFaceColor',[234/256 170/256 0],'MarkerEdgeColor',[234/256 170/256 0],'Color',[234/256 170/256 0])
    hold on;
    stem(f_sa(:,2),'fill','MarkerSize',2,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],'Color',[0 0 1])
    stem(f_sa(:,1),'fill','MarkerSize',2,'MarkerFaceColor',[234/256 170/256 0],'MarkerEdgeColor',[234/256 170/256 0],'Color',[234/256 170/256 0])
    hold off;
    ylabel(cYLabel3)
    axis([1 aiOrder(end) 0 1.3])
    set(gca,'XTickLabels',[])
    set(gca,'YTickLabels',[])
 
    subplot(223)
    %subplot(2,5,6:8)
    plot(t,x_re)
    xlabel(cXLabel1)
    ylabel(cYLabel2)
    axis([t(1) t(end) -1.3 1.3])

    subplot(224)
    %subplot(2,5,9:10)
    stem(f_re)
    stem(f_re(:,3),'fill','MarkerSize',2,'MarkerFaceColor',[234/256 170/256 0],'MarkerEdgeColor',[234/256 170/256 0],'Color',[234/256 170/256 0])
    hold on;
    stem(f_re(:,2),'fill','MarkerSize',2,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],'Color',[0 0 1])
    stem(f_re(:,1),'fill','MarkerSize',2,'MarkerFaceColor',[234/256 170/256 0],'MarkerEdgeColor',[234/256 170/256 0],'Color',[234/256 170/256 0])
    hold off;
    xlabel(cXLabel2)
    ylabel(cYLabel4)
    axis([1 aiOrder(end) 0 1.3])
    set(gca,'YTickLabels',[])
    
    Legend = cell(length(aiOrder),1);
    %Legend{1}='perfect'
    for i=1:length(aiOrder)
        Legend{i}=strcat(num2str(aiOrder(i)), ' harmonics');
    end
    legend(Legend)
    %legend('boxoff')

    printFigure(hFigureHandle, cOutputFilePath)
end

function [t, x_sa, x_re, f_sa, f_re] = getData (aiOrder)

    iLength = 16384;
    t = linspace(-.5,.5, iLength);
    x_sa(1,:) = [linspace(0,1,iLength/2), linspace(-1,0-1/iLength,iLength/2)];
    x_re(1,:) = [ones(1,iLength/2), -ones(1,iLength/2)];

    f_sa = zeros(length(aiOrder), max(aiOrder));
    f_re = zeros(length(aiOrder), max(aiOrder));
    iIdx   = 2;
    curr_sa(1,:)    = zeros(1,length(t));
    curr_re(1,:)    = zeros(1,length(t));
    for i = 1:aiOrder(end)
        n = [];
        curr_sa = curr_sa + 2/pi/i * -sin(2*pi*i*t);
        f_sa(iIdx-1,i) = 2/pi/i;
        if (mod(i,2))
%            curr_re = curr_re + 4/pi/(2*i-1) * -sin(2*pi*(2*i-1)*t);
            curr_re = curr_re + 4/pi/i * -sin(2*pi*i*t);
            f_re(iIdx-1,i) = 4/pi/i;
        else
            f_re(iIdx-1,i) = 0;
        end
        n = find (aiOrder == i);
        if (~isempty(n))
            x_sa(iIdx,:) = curr_sa;
            x_re(iIdx,:) = curr_re;
            iIdx        = iIdx + 1;
            f_sa(iIdx-1,:) = f_sa(iIdx-2,:);
            f_re(iIdx-1,:) = f_re(iIdx-2,:);
        end
    end
    f_sa = f_sa';
    f_re = f_re';
end
