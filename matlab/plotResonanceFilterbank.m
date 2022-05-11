function plotResonanceFilterbank()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 3);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % get plot data
    [f, H] = getData();

    % plot
    plot(f/1000, H)
    axis([0 3.4 -40 0])
    xlabel('$f / \mathrm{kHz}$')
    ylabel('$|H(f)|$ / dB')

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f, H] = getData()
    f_s = 8192;
    iNumFilters = 48;
    freq = zeros(1, iNumFilters);
    freq(1) = 220;
    fResonatorBandwidth = -pi * 1.35 / f_s; 

    for i = 1:iNumFilters
        freq(i) = freq(1) * 2^((i-1)/12);
        fResonatorRadius = exp(fResonatorBandwidth * 2^((i-1)/12));
        [b, a] = calcResFilterCoeff(freq(i), fResonatorRadius, f_s);
        [W, f] = freqz(b, a, 16384, f_s);
        H(i, :) = abs(W);

        H(i, :) = H(i, :) / log2((10*i)/12); % just example weighting for plot
        H(i, :) = 20 * log10(abs(H(i, :)));
    end
end

function [b,a] = calcResFilterCoeff (fResFreq, fRadius, fSampleRate)

    fAlpha = 2*pi * fResFreq / fSampleRate;
    fCosAlpha = cos(fAlpha);

    coeff(1) = (-2.0 * abs(fRadius) * fCosAlpha);  % IIR1
    coeff(2) = (fRadius^2);                                % IIR2
    coeff(3) = (coeff(1) + fCosAlpha*(1+coeff(2)))^2;
    coeff(3) = coeff(3) + ((coeff(2)-1) * sin(fAlpha))^2;
    coeff(3) = sqrt(coeff(3));                  % scale to 0dB

    b = coeff(3);
    a = [1 coeff(1) coeff(2)];
end