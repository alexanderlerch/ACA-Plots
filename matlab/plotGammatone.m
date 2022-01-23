function plotGammatone()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 6);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    cXLabel1 = '$t / \mathrm{s}$';
    cXLabel2 = '$f / \mathrm{kHz}$';
    cYLabel1 = '$h(t)$';
    cYLabel2 = '$|H(f)| / \mathrm{dB}$';
    
    % generate plot data
    [t, h, f, H] = getData();
    
    % plot
    subplot(211),
    plot(t, h)
    axis([t(1) t(end) -1.05 1.05])
    
    xlabel(cXLabel1)
    ylabel(cYLabel1)
    legend('$f_\mathrm{c}=1$ kHz')
    
    subplot(212),
    plot(f, H),
    axis([0.1 16 -60 3])
    xlabel(cXLabel2)
    ylabel(cYLabel2)

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [t, h, f, H] = getData()
    f_c = 1000;
    b = 125;
    O = 4;
    t = linspace (0, 0.015, 4096);
    
    h = t.^(O-1) .* exp(-2*pi*b*t) .* cos(2*pi*f_c*t);
    h = h / max(abs(h));
    
    fs = 48000;
    iFFTLength = 2^14;
    i = 1;
 
    t2 = linspace (0, 1, iFFTLength);
    
    for i = 1:20
       f_c(i) = 228.7 * exp((2*i/9.26)-1);
       b(i) = f_c(i) / 8;
       h2 = t2.^(O-1) .* exp(-2*pi*b(i)*t2) .* cos(2*pi*f_c(i)*t2);
       H(i, :) = abs(fft(h2));
       H(i, :) = 20*log10(H(i, :) / max(H(i, :)));
    end

    H = H(:, 1:(iFFTLength/2))';
    f = (0:(iFFTLength/2-1)) * fs / iFFTLength / 1000;
end
