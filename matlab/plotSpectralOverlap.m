function plotSpectralOverlap()

    % generate new figure
    hFigureHandle = generateFigure(13.12,6);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % parametrization
    fs      = 300;
    i       = 1;
    f_max   = [100 250];

    % get plot data
    [X] = getData(f_max(1),fs);
    
    % plot
    subplot(221)
    plot((0:length(X)-1)/fs,X(1,:));
    axis([0 2 0 1.1]);
    ylabel('$|X(f)|$');
    xlabel('$f/f_\mathrm{S}$');
    text(f_max(1)/fs, .1, '$f_\mathrm{max}$')    
        
    subplot(222)
    X   = [fliplr(X) X];
    plotOverlap(X,f_max(1),fs)
    
    % get plot data
    [X] = getData(f_max(2),fs);
    
    % plot
    subplot(223)
    plot((0:length(X)-1)/fs,X(1,:));
    axis([0 2 0 1.1]);
    ylabel('$|X(f)|$');
    xlabel('$f/f_\mathrm{S}$');
    text(f_max(2)/fs, .1, '$f_\mathrm{max}$')
        
    subplot(224)
    X   = [fliplr(X) X];
    plotOverlap(X,f_max(2),fs)
    
    % write output file
    printFigure(hFigureHandle, cOutputPath); 
end

function [X] = getData(fmax,fs)

    X           = zeros(3,2*fs);
    X(1,1:fmax) = linspace(1,0,fmax);
    X(2,fs-fmax+1:fs+fmax) = [fliplr(X(1,1:fmax)), X(1,1:fmax)];
    X(3,:)      = fliplr(X(1,:));
end

function plotOverlap(X,fmax,fs)
    plot((-length(X)/2+1:length(X)/2)/fs,X(1,:));

    hold on
    if (fs*.5 < fmax)
        H = area(linspace(.5,fmax/fs,fmax-.5*fs),X(1,length(X)/2+.5*fs+1:length(X)/2+fmax));
        set(H,'FaceColor', [.1 .1 .1]);
        H = area(linspace(-fmax/fs,-.5,fmax-.5*fs),fliplr(X(1,length(X)/2+.5*fs+1:length(X)/2+fmax)));
        set(H,'FaceColor', [.1 .1 .1]);


        H = area(linspace(1.5,1+fmax/fs,fmax-.5*fs),X(2,fs+.5*fs+1:fs+fmax));
        set(H,'FaceColor', 'b');
        H = area(linspace(1-fmax/fs,.5,fmax-.5*fs),X(2,fs-fmax+1:fs*0.5));
        set(H,'FaceColor', 'b');
        H = area(linspace(-1-fmax/fs,-1.5,fmax-.5*fs),fliplr(X(2,fs+.5*fs+1:fs+fmax)));
        set(H,'FaceColor', 'b');
        H = area(linspace(-.5,-1+fmax/fs,fmax-.5*fs),fliplr(X(2,fs-fmax+1:fs*0.5)));
        set(H,'FaceColor','b');

        H = area(linspace(2-fmax/fs,1.5,fmax-.5*fs),X(3,length(X)/2+2*fs-fmax+1:length(X)/2+1.5*fs));
        set(H,'FaceColor', 'r');
        H = area(linspace(-1.5,-2+fmax/fs,fmax-.5*fs),X(2,fs+.5*fs+1:fs+fmax));
        set(H,'FaceColor', 'r');

    end
    plot((-length(X)/2+1:length(X)/2)/fs,X(2,:),'b');%,'LineWidth', 2*iPlotLineWidth);
    plot((-length(X)/2+1:length(X)/2)/fs,X(3,:),'r');%,'LineWidth', 2*iPlotLineWidth);
    set(gca,'XTick',[-2 -1 -.5 0 .5 1 2]);
    set(gca,'YTick',[0 .5 1]);
    axis([-2 2 0.1 1.1]);
    ylabel('$|X(\mathrm{j}\omega)|$');
    xlabel('$f/f_\mathrm{S}$');
    hold off
end