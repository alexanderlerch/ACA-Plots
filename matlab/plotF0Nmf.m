function plotF0Nmf()

    % generate new figure
    hFigureHandle = generateFigure(13.12, 8);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName1 = 'Horn.ff.Db2.wav';
    cName2 = 'Oboe.ff.F4.wav';
    cName3 = 'Violin.arco.ff.sulD.B4.wav';

    % read audio and generate plot data
    [t, f, X, W, H] = getData([cAudioPath,cName1], [cAudioPath,cName2], [cAudioPath,cName3]);

    % plot
    subplot(6, 6, [4:6, 10:12, 16:18]), 
    imagesc(t, f/1000, X)
    axis xy;
    set(gca, 'XTickLabel', [])
    set(gca, 'YTick', [0 2 4 6])
    ylabel('$f\; [\mathrm{kHz}]$')

    subplot(6,6, [19, 25,31])
    plot(f/1000,W(:, 1))
    axis([f(1)/1000 f(end)/1000 0 max(max(W)) ])
    view(270,90)
    set(gca, 'XTick', [0 2 4 6])
    set(gca, 'YTickLabel', [])
    xlabel('$f\; [\mathrm{kHz}]$')
    ylabel('$\mathbf{w}_0$')
  
    subplot(6,6, [20, 26,32])
    plot(f/1000,W(:, 2))
    axis([f(1)/1000 f(end)/1000 0 max(max(W)) ])
    view(270,90)
    set(gca, 'XTick', [0 2 4 6])
    set(gca, 'XTickLabel', [])
    set(gca, 'YTickLabel', [])
    ylabel('$\mathbf{w}_1$')
  
    subplot(6,6, [21, 27,33])
    plot(f/1000,W(:,3))
    axis([f(1)/1000 f(end)/1000 0 max(max(W)) ])
    view(270,90)
    set(gca, 'XTick', [0 2 4 6])
    set(gca, 'XTickLabel', [])
    set(gca, 'YTickLabel', [])
    ylabel('$\mathbf{w}_2$')
 
    subplot(6,6, 22:24)
    plot(t,H(1, :))
    axis([t(1) t(end) 0 max(max(H))])
    set(gca, 'YTickLabel', [])
    yyaxis right
    set(gca, 'ycolor', 'k')
    set(gca, 'XTickLabel', [])
    set(gca, 'YTickLabel', [])
    ylabel('$\mathbf{h}_0$')
    
    subplot(6,6, 28:30)
    plot(t,H(2, :))
    axis([t(1) t(end) 0 max(max(H))])
    set(gca, 'YTickLabel', [])
    yyaxis right
    set(gca, 'ycolor', 'k')
    set(gca, 'XTickLabel', [])
    set(gca, 'YTickLabel', [])
    ylabel('$\mathbf{h}_1$')
     
    subplot(6,6,34:36)
    plot(t,H(3, :))
    axis([0 t(end) 0 max(max(H))])
    set(gca, 'XTick', [0 2 4 6 8])
    set(gca, 'YTickLabel', [])
    yyaxis right
    set(gca, 'ycolor', 'k')
    set(gca, 'YTickLabel', [])
    xlabel('$t\; [\mathrm{s}]$')
    ylabel('$\mathbf{h}_2$')
     
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end
function [tw, f, X, W, H] = getData(cInputFilePath1, cInputFilePath2, cInputFilePath3)

    iFFTLength = 4096;
    iPlotDecimation = 8;
    
    % read files
    [x1, f_s] = audioread(cInputFilePath1);
    t1 = linspace(0, length(x1)/f_s, length(x1));
    [x2, f_s] = audioread(cInputFilePath2);
    t2 = linspace(0, length(x2)/f_s, length(x2));
    [x3, f_s] = audioread(cInputFilePath3);
    t3 = linspace(0, length(x3)/f_s, length(x3));

    % mix files
    x = [x1;x2;x3;.5*x1];
    x(end-length(x2)+1:end) = x(end-length(x2)+1:end) + .5 * x2; 
    x(end-length(x3)+1:end) = x(end-length(x3)+1:end) + .5 * x3; 
    
    % compute spectrogram
    [X, f, tw] = ComputeSpectrogram(x, f_s, [], iFFTLength, iFFTLength/2);
    
    % compute factorization
    [W, H, D] = ToolSimpleNmf(X*2/iFFTLength, 3); 

    X = 20*log10(X(1:iFFTLength/iPlotDecimation, :));
    f = f(1:iFFTLength/iPlotDecimation);
    W = W(1:iFFTLength/iPlotDecimation, :);
end
