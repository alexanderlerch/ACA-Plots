function plotBeatHistogram()

    hFigureHandle = generateFigure(12,4);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName1 = 'classic_excerpt.wav';
    cName2 = 'pop_excerpt.wav';

    [B,f] = getData ([cAudioPath,cName1],[cAudioPath,cName2]);

    cXLabel = 'Tempo / BPM';
    cYLabel = 'Beat Histogram';

    % plot data
    subplot(121)
    plot(f,B(1,:));
    xlabel(cXLabel);
    ylabel(cYLabel);
    axis([30 120 .1 .35])
    set(gca,'YTickLabels',{})

    subplot(122)
    plot(f,B(2,:));
    xlabel(cXLabel);
    ylabel(cYLabel);
    axis([30 120 .1 .35])
    set(gca,'YTickLabels',{})

    printFigure(hFigureHandle, cOutputFilePath)

end

function     [B,f] = getData (cAudio1, cAudio2)

    [x1, f_s] = audioread(cAudio1);
    [x2, f_s] = audioread(cAudio2);

%     [T1, Bpm1] = ComputeBeatHisto (x1, f_s);
%     [T2, Bpm2] = ComputeBeatHisto (x2, f_s);
%     
%     B = [T1 T2];
%     f = Bpm1;

    iOrder = 40;
    [v1, t] = ComputeFeature ('TimePeakEnvelope', x1, f_s, hann(1024), 1024, 8);
    
    dv1 = diff([10.^(0.05*v1(1,:)) 0],1,2);
    dv1(dv1<0) = 0;
    
    dv1 = filtfilt(1/iOrder*ones(1,iOrder), 1, dv1);
    dv1(dv1<0) = 0;
    c = xcorr(dv1,'coeff');
    
    c       = c(length(dv1)+1:end);
    tres    = 8/f_s;
    f       = fliplr(60./(tres*(1:length(c))));
    B       = fliplr (c);

    
    [v2, t] = ComputeFeature ('TimePeakEnvelope', x2, f_s, hann(1024), 1024, 8);
    
    dv2 = diff([10.^(0.05*v2(1,:)) 0],1,2);
    dv2(dv2<0) = 0;
    
    dv2 = filtfilt(1/iOrder*ones(1,iOrder), 1, dv2);
    dv2(dv2<0) = 0;
    c = xcorr(dv2,'coeff');
    
    c       = c(length(dv2)+1:end);
    tres    = 8/f_s;
    f       = fliplr(60./(tres*(1:length(c))));
    B(2,:)  = fliplr (c);

end
    
