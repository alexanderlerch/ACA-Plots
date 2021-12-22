function plotPdfQuantiles()

    % generate new figure
    hFigureHandle = generateFigure(13.12,6);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % generate sample data
    [x1, normal, x2, chi2, qp,qidx] = getData();

    color = [   234/256	170/256 0
                200/256 150/256 .2
                150/256 120/256 .4
                100/256 80/256  .6
                50/256  40/256  .8
                0/256   0       1];
     
    % plot        
    subplot(211)
    plot(x1,normal)
    y_annot = [.45 .55];
    x_fill  = find(x1<=-1,1,'last');
    axis([x1(x_fill) 2.5 0 max(y_annot)+.1]);
    hold on;
    for (i = 1:length(qp))
        h = area(x1(x_fill:qidx(1,i)-1),normal(x_fill:qidx(1,i)-1),'LineStyle','none');x_fill = qidx(1,i);
        h(1).FaceColor = color(i,:);
        line([x1(qidx(1,i)) x1(qidx(1,i))],[0 y_annot(mod(i+1,2)+1)],'Color',[.5 .5 .5],'LineWidth',.5);
        text(x1(qidx(1,i))-.5,y_annot(mod(i+1,2)+1),['$Q_x(' num2str(qp(i),2) ')=' num2str(x1(qidx(1,i)),2) '$'],'Color',color(i,:), 'FontSize',6);
    end
    ylabel('Gaussian')
    hold off;

    subplot(212)
    plot(x2,chi2)
    y_annot = [.4 .5];
    x_fill  = find(x2<=0,1,'last');
    axis([x2(1) 11 0 max(y_annot)+.1]);
    hold on;
    for (i = 1:length(qp))
        h = area(x2(x_fill:qidx(2,i)-1),chi2(x_fill:qidx(2,i)-1),'LineStyle','none');x_fill = qidx(2,i);
        h(1).FaceColor = color(i,:);
        line([x2(qidx(2,i)) x2(qidx(2,i))],[0 y_annot(mod(i+1,2)+1)],'Color',[.5 .5 .5],'LineWidth',.5);
        text(x2(qidx(2,i))-1.5,y_annot(mod(i+1,2)+1),['$Q_x(' num2str(qp(i),2) ')=' num2str(x2(qidx(2,i)),2) '$'],'Color',color(i,:), 'FontSize',6);
    end
    ylabel('Chi$^2$')    
    xlabel('$x$')
    hold off;
 
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [x1, normal, x2, chi2, qp,idx] = getData()

    qp      = [.5 .75 .9 .95 .99];
    x1      = [-10:.01:10];
    normal  = normpdf(x1,0,1);
    tmp1    = normcdf(x1,0,1);
    
    x2      = [0:.01:12];
    chi2    = chi2pdf(x2,2.5);
    
    tmp2    = chi2cdf(x2,2.5);
    for (i = 1:length(qp))
        idx(1,i)    = find(tmp1 <= qp(i),1,'last');
        idx(2,i)    = find(tmp2 <= qp(i),1,'last');
    end
end

function y = normpdf(x,mu,sigma)
    x = x-mu;
    
    y = 1/(sigma*sqrt(2*pi)) * exp(-x.^2/(2*sigma^2));
end
function y = normcdf(x,mu,sigma)
    x = (x - mu)/sigma;
    
    y = 0.5*erfc(-x/sqrt(2));
end

function y = chi2pdf(x,nu)
    y = x.^(.5*(nu-2)).*exp(-x/2)/(2^(nu/2)*gamma(nu/2));
end

function y = chi2cdf(x,nu)
    y = gammainc(x/2, nu/2);
end
