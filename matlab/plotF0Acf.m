function plotF0Acf ()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    
    hFigureHandle = generateFigure(13.12,8);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    [t,x,xc,eta,r,rc,T0] = getData ([cAudioPath,cName]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the strings of the axis labels
    cXLabel1 = '$t / \mathrm{s}$';
    cXLabel2 = '$\eta / \mathrm{samples}$';
    cYLabel1 = '$x(t)$';
    cYLabel2 = '$r_{xx}(\eta)$';
    cYLabel12 = '$x_\mathrm{clip}(t)$';
    cYLabel22 = '$r_{x_cx_c}(\eta)$';

    subplot(221), 
    plot(t,x,'LineWidth', .5),
    axis([t(1) t(end) -1 1])
    xlabel(cXLabel1)
    ylabel(cYLabel1)

    subplot(223)
    line(T0*ones(1,2), [-1 1],'LineWidth', 2.5,'Color',[234/256 170/256 0])
    axis([eta(1) eta(end) -1 1])
    hold on;
    plot(eta,r,'LineWidth', .5),
    hold off;

    xtick = get(gca,'XTick');
    xtick = sort([xtick(xtick ~=0) T0]);
    set(gca,'XTick', xtick);
    xticklabel = get(gca,'XTickLabel');
    xticklabel(xtick == T0) = {'$\hat{T}_0$'};
    set(gca,'XTickLabel', xticklabel)
    xlabel(cXLabel2)
    ylabel(cYLabel2)
    
    subplot(222), 
    plot(t,xc,'LineWidth', .5),
    axis([t(1) t(end) -1 1])
    xlabel(cXLabel1)
    ylabel(cYLabel12)

    subplot(224)
    line(T0*ones(1,2), [-1 1],'LineWidth', 2.5,'Color',[234/256 170/256 0])
    axis([eta(1) eta(end) -1 1])
    hold on;
    plot(eta,rc,'LineWidth', .5),
    hold off;

    xtick = get(gca,'XTick');
    xtick = sort([xtick(xtick ~=0) T0]);
    set(gca,'XTick', xtick);
    xticklabel = get(gca,'XTickLabel');
    xticklabel(xtick == T0) = {'$\hat{T}_0$'};
    set(gca,'XTickLabel', xticklabel)
    xlabel(cXLabel2)
    ylabel(cYLabel22)


    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

% example function for data generation, substitute this with your code
function [t,x,xc,eta,r,rc,T0] = getData (cInputFilePath)

    % read sample data
    iStart  = 66000;
    iLength = 4096;
    [x,f_s] = audioread(cInputFilePath, [iStart iStart+iLength-1]);
    t       = linspace(0,length(x)/f_s,length(x));
    x       = x/max(abs(x));

    %initialization
    fMaxFreq    = 2000;
    fMinThresh  = 0.35;
    eta_min     = round(f_s/fMaxFreq);

    % copied from ACA-Code/PitchTimeAcf.m
    % calculate the acf maximum
    r           = xcorr(x,'coeff');
    r           = r((ceil((length(r)/2))+1):end);
    eta         = 0:(length(r)-1);
    
    % ignore values until threshold was crossed
    eta_tmp     = find (r < fMinThresh, 1);
    if (~isempty(eta_tmp))
        eta_min = max(eta_min, eta_tmp);
    end

    % only take into account values after the first minimum
    afDeltaCorr = diff(r);
    eta_tmp     = find(afDeltaCorr > 0, 1);
    if (~isempty(eta_tmp))
        eta_min = max(eta_min, eta_tmp);
    end

    %center clipping
    thresh          = .75;
    xc              = x;
    xc(abs(x) < thresh) = 0;
    rc              = xcorr(xc,'coeff');
    rc              = rc((ceil((length(rc)/2))+1):end);

    [fDummy,T0] = max(r(1+eta_min:end));

    % T0 in samples
    T0 = (T0 + eta_min);
%     f0 = f_s ./ (f0 + eta_min);

end
