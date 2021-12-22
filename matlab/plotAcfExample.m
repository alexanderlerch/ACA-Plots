function plotAcfExample (fDimensions)

    % generate new figure
    hFigureHandle = generateFigure(13.12,7);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    [acfn,acfs,eta] = getData();

    % set the strings of the axis labels
    cXLabel  = '$\eta / 10^3$';
    cYLabel1 = '$r_{xx}$ (Sine)';
    cYLabel2 = '$r_{xx}$ (Noise)';

    % plot
    subplot(211)
    plot(eta,acfs)
    grid on,
    axis([eta(1) eta(end) -1.1 1.1])
    ylabel(cYLabel1);

    subplot(212)
    plot(eta,acfn)
    grid on,
    axis([eta(1) eta(end) -1.1 1.1])
    xlabel(cXLabel);
    ylabel(cYLabel2);

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [acfn,acfs,eta] = getData()

    iLength         = 16384;
    iNumSinePeriods = 8;

    noise = rand(1,iLength)*2-1;
    sine  = sin(2*pi*(0:iLength-1)/iLength * iNumSinePeriods);
    acfn  = xcorr(noise);
    acfs  = xcorr(sine);
    acfn  = acfn/max(acfn);
    acfs  = acfs/max(acfs);

    eta = (-iLength+1:iLength-1) * 1e-3;
end



