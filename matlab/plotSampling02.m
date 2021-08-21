function plotSampling02()

    hFigureHandle = generateFigure(13.12,8);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % generate sample data
    [t,x,ts,xs,f0,fs] = getData ();

    cXLabel = '$t / \mathrm{ms}$';
    for (i = 1:size(x,1))
        subplot(3,size(x,1),i)
        plot(t,x(i,:))
        ylabel('$x(t)$')
        %xlabel('$t\; [ms]$')
        title(['$f = ' num2str(f0(i)/1000) ' \mathrm{kHz}$'])
        axis([t(1) 1 -1.1 1.1])
    
        subplot(3,size(x,1),i+size(x,1))
        stem(ts, xs(i,:), 'k-','MarkerFaceColor',[0 0 0],'MarkerSize',3) 
        ylabel(['$x_{' num2str(fs/1000) '\mathrm{kHz}}(i)$'])
        xlabel(cXLabel)
        axis([ts(1) 1 -1.1 1.1])
    end
    subplot(3,1,3)
    plot(t,x)
    xlabel(cXLabel)
    ylabel('$x_n(t), x_n(i)$')
    axis([t(1) 1 -1.1 1.1])
    hold on;
    stem(ts, xs(1,:), 'k-','MarkerFaceColor',[0 0 0],'MarkerSize',5)
    hold off;
 
    printFigure(hFigureHandle, cOutputPath)
end

function [t,x,ts,xs,f0,fs] = getData()

    iLength             = 3000;
    iNumOfBasePeriods   = 1;
    iNumOfFreqs         = 3;
    fBaseFreqRatio      = 1/6; % between 0 and .5
    fs                  = 6000;

    iNumOfBasePeriods   = iNumOfBasePeriods/fBaseFreqRatio;
    T_0                 = round(iLength/iNumOfBasePeriods);
    f0                  = fBaseFreqRatio * fs;

    for i=2:iNumOfFreqs
        if (mod(i,2)==0)
            f0 = [f0; -fBaseFreqRatio * fs + floor(i/2)*fs];
        else
            f0 = [f0; fBaseFreqRatio * fs + floor(i/2)*fs];
        end
    end

    for i=1:iNumOfFreqs
        x(i,:)  = (-1)^(i+1)*sin (2*pi*f0(i)/fs*linspace(0,iNumOfBasePeriods-iNumOfBasePeriods/iLength,iLength));
    end
    t       = (0:(size(x,2)-1))/iLength/(fBaseFreqRatio * fs)*1000;
    ts      = t(1,1:T_0:end);
    xs(1,:) = x(1,1:T_0:end);
    xs(2,:) = xs(1,:);
    xs(3,:) = xs(1,:);

end