function plotOnset()
 
    if(exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12, 4);
    
    iStart = 800;
    iLength = 65536;
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];

    % file path
    cName = 'sax_example.wav';

    % read audio and get plot data
    [t, x, td, d, iOnsetIdx, iAcOnsetIdx] = getData ([cAudioPath, cName], [iStart iStart+iLength-1]);
 
    % plot
    plot(t, abs(x), 'Color', [.6 .6 .6]);
    hold on
    plot(td, d, 'k', 'LineWidth', 2);
    stem(td(iOnsetIdx), d(iOnsetIdx), 'fill', 'MarkerEdgeColor', [200/256 150/256 0], 'MarkerFaceColor', [234/256 170/256 0], 'Color', [234/256 170/256 0])
    stem(td(iAcOnsetIdx), d(iAcOnsetIdx), 'fill', 'MarkerEdgeColor', [200/256 150/256 0], 'MarkerFaceColor', [234/256 170/256 0], 'Color', [234/256 170/256 0])
    hold off
    xlabel('$t / \mathrm{s}$')
    ylabel('$|x(t)|$')
    axis([t(1) t(end) 0 1.1])
    text(td(iOnsetIdx)-0.01, d(iOnsetIdx)+.1, 'POT');
    text(td(iAcOnsetIdx)-0.01, d(iAcOnsetIdx)+.1, 'AOT');
    text(0.035, 1.0, '$\leftarrow$ att.\ time $\rightarrow$');
    
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function[t, x, td, d, iOnsetIdx, iAcOnsetIdx] = getData(cFilePath, aiSampleIdx)
    
    iLength = aiSampleIdx(2) - aiSampleIdx(1) + 1;
    iPlotLength = 8192;
    iBlockLength = 256;
    iHopLength = 16;

    % read audio
    [x, f_s] = audioread(cFilePath, aiSampleIdx);
    t = linspace(0,(iLength-1)/f_s,iLength);
    if (size(x, 2)> 1)
        x = mean(x, 2);
    end
    x = x / max(abs(x));

    % extract feature
    [d, td] = ComputeFeature('TimePeakEnvelope', x, f_s, hann(iBlockLength, 'periodic'), iBlockLength, iHopLength);
    d = 10.^(d(1, :)*.05);

    % smooth
    L = 8;
    d = filtfilt(1/L*ones(1,L), 1, d);
    n = diff([d(1) d]);

    t = t(1:iPlotLength);
    x = x(1:iPlotLength);
    td = td(td<=t(end));
    d = d(1:length(td));

    % pick onsets
    iAcOnsetIdx = find(d > 10^(-28/20));
    iAcOnsetIdx = iAcOnsetIdx(1);
    [dummy, iOnsetIdx] = max(n);
end
