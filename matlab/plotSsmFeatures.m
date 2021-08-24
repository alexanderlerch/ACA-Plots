function plotSsmFeatures ()

    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,8);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file name
    cName = 'bad.mp3';

    [tv, Dpc, Drms, Dmfcc, Dms, Dpcb, Drmsb, Dmfccb, Dmsb] = getData(cAudioPath, cName);

    ax = subplot(241);
    imagesc(tv,tv,nonlinearity(Dpc,2))
    c=colormap(ax,'jet');
    colormap(ax,flipud(c));
%     xlabel('$t / \mathrm{s}$')
    ylabel('$t / \mathrm{s}$')
    set(gca,'XTickLabels', {})
    set(gca,'YTickLabels', {})

    ax = subplot(242);
    imagesc(tv,tv,nonlinearity(Drms,8))
    c=colormap(ax,'jet');
    colormap(ax,flipud(c));
%     xlabel('$t / \mathrm{s}$')
    set(gca,'XTickLabels', {})
    set(gca,'YTickLabels', {})

    ax = subplot(243);
    imagesc(tv,tv,nonlinearity(Dmfcc,2))
    c=colormap(ax,'jet');
    colormap(ax,flipud(c));
%     xlabel('$t / \mathrm{s}$')
    set(gca,'XTickLabels', {})
    set(gca,'YTickLabels', {})

    ax = subplot(244);
    imagesc(tv,tv,nonlinearity(Dms,4))
    c=colormap(ax,'jet');
    colormap(ax,flipud(c));
%     xlabel('$t / \mathrm{s}$')
    set(gca,'XTickLabels', {})
    set(gca,'YTickLabels', {})

    ax = subplot(245);
    imagesc(tv,tv,Dpcb)
    c=colormap(ax,'gray');
    colormap(ax,flipud(c));
    xlabel('$t / \mathrm{s}$')
    ylabel('$t / \mathrm{s}$')
    set(gca,'XTickLabels', {})
    set(gca,'YTickLabels', {})

    ax = subplot(246);
    imagesc(tv,tv,Drmsb)
    c=colormap(ax,'gray');
    colormap(ax,flipud(c));
    xlabel('$t / \mathrm{s}$')
    set(gca,'XTickLabels', {})
    set(gca,'YTickLabels', {})

    ax = subplot(247);
    imagesc(tv,tv,Dmfccb)
    c=colormap(ax,'gray');
    colormap(ax,flipud(c));
    xlabel('$t / \mathrm{s}$')
    set(gca,'XTickLabels', {})
    set(gca,'YTickLabels', {})

    ax = subplot(248);
    imagesc(tv,tv,Dmsb)
    c=colormap(ax,'gray');
    colormap(ax,flipud(c));
    xlabel('$t / \mathrm{s}$')
    set(gca,'XTickLabels', {})
    set(gca,'YTickLabels', {})

    printFigure(hFigureHandle, cOutputPath)
end

function [tv, Dpc, Drms, Dmfcc, Dms, Dpcb, Drmsb, Dmfccb, Dmsb] = getData(cAudioPath, cName)

    cFeatureNames = char('SpectralPitchChroma','TimeRms','SpectralMfccs','TimeAcfCoeff');%char('TimeAcfCoeff');

    iBlockLength = 65536; %65536
    iHopLength = 4096; %4096
    
    % read sample data
    [x,fs]  = audioread([cAudioPath '/' cName]);
    x       = mean(x,2); 
    x       = x/max(abs(x));
    
    t = (0:(length(x)-1))/fs;
 
    [vpc, tpc] = ComputeFeature (deblank(cFeatureNames(1,:)), x, fs, [], iBlockLength, iHopLength);
    [vrms, trms] = ComputeFeature (deblank(cFeatureNames(2,:)), x, fs, [], iBlockLength, iHopLength);
    vrms = 10.^(vrms*.05);
    vrms = vrms/max(max(vrms));
    [vmfcc, tmfcc] = ComputeFeature (deblank(cFeatureNames(3,:)), x, fs, [], iBlockLength, iHopLength);
    vmfcc = 10.^(vmfcc*.05);
    vmfcc = vmfcc/max(max(vmfcc));

    [M, f_c, t_MS] = ComputeMelSpectrogram (x, fs, false, [], iBlockLength, iHopLength, 128, 16000);
    
    tv = tpc;
    Dpc = zeros(length(tv));
    Drms = zeros(length(tv));
    Dmfcc = zeros(length(tv));
    Dms = zeros(length(tv));
    for (i=1:length(tv))
        Dpc(i,:)  = sqrt(sum((repmat(vpc(:,i),1,length(tv))-vpc).^2));
        Drms(i,:)  = sqrt(sum((repmat(vrms(:,i),1,length(tv))-vrms).^2));
        Dmfcc(i,:)  = sqrt(sum((repmat(vmfcc(:,i),1,length(tv))-vmfcc).^2));
        Dms(i,:)  = sqrt(sum((repmat(M(:,i),1,length(tv))-M).^2));
    end
  
    Dpc = normalize(Dpc);
    Drms = normalize(Drms);
    Dmfcc = normalize(Dmfcc);
    Dms = normalize(Dms);
    
    % compute binary
    thresh = .89;
    Dpcb = 1-Dpc;
    Dpcb(Dpcb<+thresh) = 0;
    %Dpcb(Dpcb>thresh) = 1;
    
    thresh = .985;
    Drmsb = 1-Drms;
    Drmsb(Drmsb<+thresh) = 0;
    %Drmsb(Drmsb>thresh) = 1;
    
    thresh = .85;
    Dmfccb = 1-Dmfcc;
    Dmfccb(Dmfccb<+thresh) = 0;
    %Dmfccb(Dmfccb>thresh) = 1;
    
    thresh = .825;
    Dmsb = 1-Dms;
    Dmsb(Dmsb<+thresh) = 0;
    %Dmfccb(Dmfccb>thresh) = 1;
    
end

function [D] = nonlinearity(D, scale)
    if nargin < 2
        scale = 1;
    end
    D = normalize(D)*scale;
    D = tanh(D-scale/8);
end
function [D] = normalize(D)
    D = D-min(min(D));
    D = D/max(max(D));
end