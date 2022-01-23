function plotLowPass ()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 4);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    [f, HMA, HSP] = getData();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the strings of the axis labels
    cXLabel = '$f/f_\mathrm{S}$';
    cYLabel1 = '$|H_\mathrm{MA}(f)| /\mathrm{dB}$';
    cYLabel2 = '$|H_\mathrm{SP}(f)| /\mathrm{dB}$';

    % plot 
    h(1) = subplot(121);
    plot(f, HMA')
    axis([f(1) f(end) -50 1]),
    grid on 
    xlabel(cXLabel);
    ylabel(cYLabel1);

    h(2) = subplot(122);
    plot(f, HSP')
    axis([f(1) f(end) -50 1]),
    grid on 
    xlabel(cXLabel);
    ylabel(cYLabel2);

    lh = legend(h(1), '$\mathcal{J}=2$', '$\mathcal{J}=10$', '$\mathcal{J}=50$', 'Location', 'SouthWest');
    lh = legend(h(2), '$\alpha=0.5$', '$\alpha=0.9$', '$\alpha=0.999$', 'Location', 'SouthWest');

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function    [f,HMA,HSP] = getData()
    [HMA(1, :), f] = freqz(ones(1, 2), 1); %rect
    f = f / (2*pi);
    HMA(1, :) = 10*log10(abs(freqz(ones(1, 2)/2, 1))); %rect
    HMA(2, :) = 10*log10(abs(freqz(ones(1, 10)/10, 1))); %rect
    HMA(3, :) = 10*log10(abs(freqz(ones(1,50)/50, 1))); %rect
    HSP(1, :) = 10*log10(abs(freqz(.5, [1 -.5]))); %sp
    HSP(2, :) = 10*log10(abs(freqz(.1, [1 -.9]))); %sp
    HSP(3, :) = 10*log10(abs(freqz(.001, [1 -.999]))); %sp
end
