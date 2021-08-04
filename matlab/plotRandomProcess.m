function plotRandomProcess()

    hFigureHandle = generateFigure(13.12,8);
    
    iLength = 512;
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % generate sample data
    x_r = getData(5,iLength);
    
    
    for (i = 2:size(x_r,1)-1)
        subplot(size(x_r,1),1,i)
        plot(x_r(i,:),'Linewidth',1)
        ylabel(['series ' num2str(i)])
        axis([1 iLength -ceil(10*max(max(abs(x_r))))/10 ceil(10*max(max(abs(x_r))))/10])
        set(gca,'XTick',[])
        set(gca,'YTick',[])
%         set(gca,'xcolor',[1 1 1])
%         set(gca,'ycolor',[1 1 1])
    end
    xlabel('$t / \mathrm{s}$')
    
    annotation(hFigureHandle,'line',[0.30 0.30],[0.80 0.25]);
    annotation(hFigureHandle,'line',[0.60 0.60],[0.80 0.25]);
    annotation(hFigureHandle,'textbox',[0.29 0.19 0.10 0.10],...
    'String',{'$f_X(x,t_1)$'},...
    'LineStyle','none',...
    'Interpreter','latex');
    annotation(hFigureHandle,'textbox',[0.59 0.19 0.10 0.10],...
    'String','$f_X(x,t_2)$',...
    'LineStyle','none',...
    'Interpreter','latex');
    annotation(hFigureHandle,'textbox',[0.20 0.20 0.1 0.1],...
    'String',{'.','.','.','.'},...
    'LineStyle','none');
    annotation(hFigureHandle,'textbox',[0.20 0.90 0.1 0.1],...
    'String',{'.','.','.'},...
    'LineStyle','none');
    annotation(hFigureHandle,'textbox',[0.50 0.20 0.1 0.1],...
    'String',{'.','.','.','.'},...
    'LineStyle','none');
    annotation(hFigureHandle,'textbox',[0.50 0.90 0.1 0.1],...
    'String',{'.','.','.'},...
    'LineStyle','none');
    annotation(hFigureHandle,'textbox',[0.80 0.20 0.1 0.1],...
    'String',{'.','.','.','.'},...
    'LineStyle','none');
    annotation(hFigureHandle,'textbox',[0.80 0.90 0.1 0.1],...
    'String',{'.','.','.'},...
    'LineStyle','none');


    printFigure(hFigureHandle, cOutputFilePath)
end

% generate sample data
function    [x_r] = getData (iRank,iLength)
    x_r = randn(iRank,iLength);
end
