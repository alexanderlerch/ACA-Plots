function plotOnset()
 
    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    hFigureHandle = generateFigure(13.12,4);
    
    iStart  = 800;
    iLength = 65536;
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'sax_example.wav';

    [t,x,td,d,iOnsetIdx,iAcOnsetIdx] = getData ([cAudioPath,'/',cName], [iStart iStart+iLength-1]);
 
    plot(t,abs(x),'Color', [.6 .6 .6]);
    hold on
    plot(td,d, 'LineWidth',2);
    stem(td(iOnsetIdx),d(iOnsetIdx),'fill','r')
    stem(td(iAcOnsetIdx),d(iAcOnsetIdx),'fill','b')
    hold off
    xlabel('$t / \mathrm{s}$')
    ylabel('$|x(t)|$')
    axis([t(1) t(end) 0 1.1])
    text(td(iOnsetIdx)-0.01,d(iOnsetIdx)+.1,'POT');
    text(td(iAcOnsetIdx)-0.01,d(iAcOnsetIdx)+.1,'AOT');
    text(0.035,1.0,'$\leftarrow$ att.\ time $\rightarrow$');
    
    printFigure(hFigureHandle, cOutputFilePath)
end

function[t,x,td,d,iOnsetIdx,iAcOnsetIdx] = getData(cFilePath, aiSampleIdx)
    
    iLength = aiSampleIdx(2)-aiSampleIdx(1)+1;
    iPlotLength = 8192;
    iBlockLength = 256;
    iHopLength = 16;

    [x, fs] = audioread(cFilePath, aiSampleIdx);
    t       = linspace(0,(iLength-1)/fs,iLength);
    if (size(x,2)> 1)
        x = mean(x,2);
    end
    % pre-processing: normalization
    x = x/max(abs(x));

    [d,td]   = ComputeFeature ('TimePeakEnvelope', x, fs, hann(iBlockLength,'periodic'), iBlockLength, iHopLength);
    d = 10.^(d(1,:)*.05);

    L = 8;
    d = filtfilt(1/L*ones(1,L),1,d);
    n = diff([d(1) d]);

    t = t(1:iPlotLength);
    x = x(1:iPlotLength);
    td = td(td<=t(end));
    d = d(1:length(td));
%plot(to,d)

    iAcOnsetIdx = find(d > 10^(-28/20));
    iAcOnsetIdx = iAcOnsetIdx(1);

    [dummy,iOnsetIdx] = max(n);
end
