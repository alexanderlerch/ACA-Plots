function plotInstantaneousFreq()

    if (exist('ToolInstFreq') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    hFigureHandle = generateFigure(13.12,5);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % read sample data
    [f,X,f_I, cLegend]  = getData();

%     subplot(211)
    plot(f,X(1,:));
    axis([f(1) f(end) 0 0.6])
    xlabel('$f / \mathrm{Hz}$');
    ylabel('$|X(f)|$');
    
%     subplot(212)
%     plot(0:length(f_I)-1,f_I);
%     axis([0 length(f_I)+1 min(f_I) max(f_I)])

    annotation('textbox',[0.51, 0.7, 0.2, 0.2],'String',cLegend,'FontSize',6.5,'EdgeColor',[1 1 1],'FitBoxToText','on','Interpreter','latex');

%     xlabel('$k$');
%     ylabel('$|f_\mathrm{I}(k)|$');
%     lh = legend(cLegend);
%     set(lh,'Location','SouthEast','Interpreter','latex')

    printFigure(hFigureHandle, cOutputFilePath)
end

function [f,X,f_I, cLegend] = getData()

    iFftLength  = 1024;
    fs          = 48000;
    iHop        = 256;
    fFreqRes    = fs/iFftLength;
    fLengthInS  = (iFftLength + iHop)/fs;
    f           = linspace(0,fs/2,iFftLength/2+1);
    
    bins        = iFftLength./[32 8 4];
    fFreq       = fFreqRes*(bins + [.5 .25 0]);
    
    [x,t]   = generateSineWave(fFreq, fLengthInS, fs);
    %x       = 0.25*x;
    
    X(1,:)  = fft(sum(x(:,1:iFftLength),1).*hann(iFftLength)')*2/iFftLength;
    X(2,:)  = fft(sum(x(:,iHop+1:iFftLength+iHop),1).*hann(iFftLength)')*2/iFftLength;
%     X(1,:)  = fft(sum(x(:,1:iFftLength/4),1),iFftLength)*2/iFftLength;
%     X(2,:)  = fft(sum(x(:,iHop+1:iFftLength/4+iHop),1),iFftLength)*2/iFftLength;
 
    X       = X(:,1:iFftLength/2+1);
    f_I     = ToolInstFreq(X,iHop, fs);
    
    X       = abs(X);
    [pks,k] = findpeaks(X(1,:));
    
    cLegend = {};
    for (i=1:length(fFreq))
        fDiff(i,:) = abs([fFreqRes*(k(i)-1)-fFreq(i) f_I(k(i))-fFreq(i)]);
        cLegend{i}          = ['$f = ' num2str(fFreq(i),'%2.2f') '$ Hz, $f_{k} = ' num2str(fFreqRes*(k(i)-1),'%2.2f') '$ Hz, $f_\mathrm{I} = ' num2str(f_I(k(i)),'%2.2f') '$ Hz'];
    end
    cLegend = char(cLegend);
end

function [x,t] = generateSineWave(fFreq, fLengthInS, fSampleRateInHz)

    [m n]   = size(fFreq);
    if (min(m,n)~=1)
        error('illegal frequency dimension')
    end
    if (m<n)
        fFreq   = fFreq';
    end
    
    t = linspace(0,fLengthInS-1/fSampleRateInHz,fSampleRateInHz*fLengthInS);
    
    x = sin(2*pi*fFreq*t);
end
