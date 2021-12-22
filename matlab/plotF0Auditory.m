function plotF0Auditory()

    % generate new figure
    hFigureHandle = generateFigure(13.12,8);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % read sample data
    [t,x, f,X]  = getData();

    % label strings
    cXLabel     = char('$t / \mathrm{s}$','$f / \mathrm{Hz}$');
    cYLabelTime = char('$x(i)$','$x_\mathrm{HWR}(i)$','$x_\mathrm{S,HWR}(i)$');
    cYLabelFreq = char('$|X(k)|$','$|X_\mathrm{HWR}(k)|$','$|X_\mathrm{S,HWR}(k)|$');
    yTicksTime  = [-4 0 4
                    0 2 4
                    0 .5 1];

    % plot
    for (i = 1:3)
        subplot(3,2,2*i-1)
        plot(t,x(i,:));
        ylabel(deblank(cYLabelTime(i,:)));
        set(gca,'YTick',yTicksTime(i,:))
        axis('tight')
        if (i==1) 
            title('time domain'); 
            set(gca,'XTickLabels',[]);
        end
        if (i==2) 
            set(gca,'XTickLabels',[]);
        end
        if (i==3) xlabel(deblank(cXLabel(1,:))); end;

        subplot(3,2,2*i)
        plot(f,X(i,:));
        ylabel(deblank(cYLabelFreq(i,:)));
        axis([f(1) f(end) 0.01 1.2])
        if (i==1) 
            title('frequency domain'); 
            set(gca,'XTickLabels',[]);
        end
        if (i==2) 
            set(gca,'XTickLabels',[]);
        end
        if (i==3) xlabel(deblank(cXLabel(2,:))); end;
    end

    % write output file
    printFigure(hFigureHandle, cOutputPath)
end

function [t,x, f,X] = getData()
    
    iBlockSize  = 2048;
    fs          = 192000;
    dLengthInS  = iBlockSize/192000;
    iFilterLength = 128;
    maxFreq     = 7000;
    numReps     = 16;

    f_0     = 187.5;
    f       = f_0*[13 14 15 16 17];

    [x,t]   = generateSineWave_I(f(1), dLengthInS, fs);
    for (i = 2:length(f))
        x   = x + generateSineWave_I(f(i), dLengthInS, fs);
    end

    % periodic continuation
    fftSize = (numReps*iBlockSize);
    f       = (0:fftSize)*fs/fftSize;
    f       = f(find(f <= maxFreq));

    timesig = repmat(x(1,:), 1,numReps);
    tmp     = abs(fft(timesig))*2/fftSize;
    X       = tmp(1:length(f));

    % HWR
    x(2,:)              = x(1,:);
    x(2,find(x(2,:)<0)) = 0;        

    timesig = repmat(x(2,:), 1,numReps);
    tmp     = abs(fft(timesig))*2/fftSize;
    X(2,:)  = tmp(1:length(f));

    % low pass filter
    x(3,:)              = x(2,:);
    tmp                 = filtfilt(ones(iFilterLength,1)/iFilterLength,1,[x(3,:) x(3,:) x(3,:)]);
    x(3,:)              = tmp(length(x)+1:2*length(x));

    timesig = repmat(x(3,:),1, numReps);
    tmp     = abs(fft(timesig))*2/fftSize;
    X(3,:)  = tmp(1:length(f));
end

function [x,t] = generateSineWave_I(fFreq, fLengthInS, fSampleRateInHz)

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