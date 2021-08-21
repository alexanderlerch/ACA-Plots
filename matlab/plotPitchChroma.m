function plotPitchChroma  ()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    
    hFigureHandle = generateFigure(12,7);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'sax_example.wav';

    [t,f,X,pclabel,pc,pcm] = getData ([cAudioPath,'/',cName]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the strings of the axis labels
    cXLabel = '$t / \mathrm{s}$';
    cYLabel1 = '$f / \mathrm{kHz}$';
    cYLabel2 = 'pitch class';
    
    % plot data
    subplot(2,10,1:9), imagesc(t,f/1000,X)
    axis xy;
    %xlabel(cXLabel)
    ylabel(cYLabel1)
    set(gca,'XTickLabel',[])

    subplot(2,10,11:19), imagesc(t,pclabel,pc)
    axis xy;
    set(gca,'YDir','normal','YTick',[0 2 4 6 8 10],'YTickLabel',{'C', 'D', 'E', 'F\#', 'G\#', 'A\#'})
    xlabel(cXLabel)
    ylabel(cYLabel2)
    
    subplot(2,10,20)
    plot(pcm,pclabel)
    set(gca,'YTickLabel',{})
    set(gca,'XTickLabel',{})
    axis([0 max(pcm) -.5 11.5])

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

% example function for data generation, substitute this with your code
function [tw,f,X, pclabel, vpc,vpcm] = getData (cInputFilePath)

    iFFTLength = 4096;
    [x, fs] = audioread(cInputFilePath);
    t       = linspace(0,length(x)/fs,length(x));
    x       = x/max(abs(x));

    
    [X,f,tw] = spectrogram(x,hanning(iFFTLength),iFFTLength*.5,iFFTLength,fs);
    X       = abs(X);

    [vpc, tv]         = ComputeFeature (deblank('SpectralPitchChroma'), x, fs);

    % avg pitch chroma
    vpcm = mean(vpc,2);

    X       = 10*log10(abs((X(1:iFFTLength/16,:))));
    f       = f(1:iFFTLength/16,:);

    pclabel = 0:11;
end
