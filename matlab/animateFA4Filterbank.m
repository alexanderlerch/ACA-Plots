function animateFA4Filterbank()

    % generate new figure
    hFigureHandle = generateFigure(13.12,5);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/animation/' strrep(cName, 'animate', '')];

    iNumFrames  = 75;
    fStartFreq  = 220;
    
    for (i = 1:iNumFrames)
        fFreq   = fStartFreq*2^((i-1)/(24*iNumFrames));
        [f,H]   = generateSampleData(fFreq);
        for (k = 1:3)
            for (j = 1:12)
                plot (f(j,:,k), 10*log10(abs(H(j,:,k))),'LineWidth',0.5), hold on;
            end
        end   
        hold off;
        axis([ f(j,1,k) f(j,end,k) -18 1]);
        xlabel('$f/\mathrm{Hz}$')
        ylabel('$|H(f)|$ [dB]')
       % lh = legend();
        annotation('textbox',[.65 .65 .2 .2],'String',['$\hat{f}_\mathrm{A4} = ' num2str(fFreq*2,'%2.2f') '$ Hz'],'FitBoxToText','on','Interpreter','latex');
 
        printFigure(hFigureHandle, [cOutputPath '-' num2str(i,'%.2d')]); 
        delete(findall(gcf,'type','annotation'))
    end
end

function [f,H]   = generateSampleData(fFreq)
    fs                  = 6000;
    fResonatorBandwidth = -pi * .8 * 2.0 / fs;
    fResonatorRadius    = (exp(fResonatorBandwidth));
    fMultiply           = (fFreq-fResonatorBandwidth*fs/(-pi))/fFreq;
    fValues             = 201:.1:470;

    H                   = zeros(12,length(fValues),3);
    f                   = zeros(size(H));
    for (i=1:12)
        [b,a]   = calcResFilterCoeff (fFreq, fResonatorRadius, fs);
        [H(i,:,1),f(i,:,1)]             = freqz(b,a, fValues,fs);
        [b,a]   = calcResFilterCoeff (fFreq/fMultiply, fResonatorRadius, fs);
        [H(i,:,2),f(i,:,2)]             = freqz(b,a, fValues,fs);
        [b,a]   = calcResFilterCoeff (fFreq*fMultiply, fResonatorRadius, fs);
        [H(i,:,3),f(i,:,3)]             = freqz(b,a, fValues,fs);

        fFreq               = fFreq*2^(1/12);
        fResonatorBandwidth = fResonatorBandwidth*2^(1/12);
    end
end

function [b,a] = calcResFilterCoeff (fResFreq, fRadius, fSampleRate)

    fAlpha      = 2*pi * fResFreq / fSampleRate;
    fCosAlpha   = cos(fAlpha);

    coeff(1)    = (-2.0 * abs(fRadius) * fCosAlpha);  % IIR1
    coeff(2)    = (fRadius^2);                                % IIR2
    coeff(3)    = (coeff(1) + fCosAlpha*(1+coeff(2)))^2;
    coeff(3)    = coeff(3) + ((coeff(2)-1) * sin(fAlpha))^2;
    coeff(3)    = sqrt(coeff(3));                  % scale to 0dB

    b = coeff(3);
    a = [1 coeff(1) coeff(2)];
end