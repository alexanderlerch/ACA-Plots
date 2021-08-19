function plotLinearRegression  ()

    if (exist('ComputeFeature') ~= 2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    
    hFigureHandle = generateFigure(13.12,5);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio'];

    % file path
    cName = 'sax_example.wav';

    [v,m21,b21,m23,b23,e21,e23] = getData ([cAudioPath,'/',cName]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the strings of the axis labels
    cXLabel = '$v_\mathrm{RMS}$';
    cYLabel1 = '$v_\mathrm{Peak}$';
    cYLabel2 = '$v_\mathrm{SC}$';

    % plot data
    iMarkerSize = 8;
    
    subplot(121)
    scatter(v(2,:),v(3,:),iMarkerSize), 
    hold on
    plot( v(2,:),m23*v(2,:) + b23)
    hold off
    xlabel(cXLabel)
    ylabel(cYLabel1)
    axis xy;
    axis([0 1 0 1])
    set(gca,'YTickLabel',{})
    set(gca,'XTickLabel',{})
    text(.1,.9,['MSE=' num2str(e23,2)]);

    subplot(122)
    scatter(v(2,:),v(1,:),iMarkerSize), 
    hold on
    plot( v(2,:),m21*v(2,:) + b21)
    hold off
    xlabel(cXLabel)
    ylabel(cYLabel2)
    axis xy;
    axis([0 1 0 1])
    set(gca,'YTickLabel',{})
    set(gca,'XTickLabel',{})
    text(.6,.9,['MSE=' num2str(e21,2)]);

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

% example function for data generation, substitute this with your code
function [v, m21,b21,m23,b23,e21,e23] = getData (cInputFilePath)

    iFFTLength = 4096;
    [x, fs] = audioread(cInputFilePath);
    
    [v1, t] = ComputeFeature ('SpectralCentroid', x, fs);
    [v2, t] = ComputeFeature ('TimeRms', x, fs);
    [v3, t] = ComputeFeature ('TimePeakEnvelope', x, fs);
 
    v1 = (v1-min(v1)) / (max(v1)-min(v1));
    v2 = (v2(1,:)-min(v2(1,:))) / (max(v2(1,:))-min(v2(1,:)));
    v3 = (v3(1,:)-min(v3(1,:))) / (max(v3(1,:))-min(v3(1,:)));
    v = [v1;v2;v3];
    
    mu = mean(v,2);
    m21 = ((v(1,:)-mu(1))*(v(2,:)-mu(2))')/((v(2,:)-mu(2))*(v(2,:)-mu(2))');
    b21 = mu(1) - m21*mu(2);
    e21 = mean((v(1,:) - m21*v(2,:) - b21).^2);
    
    m23 = ((v(3,:)-mu(3))*(v(2,:)-mu(2))')/((v(2,:)-mu(2))*(v(2,:)-mu(2))');
    b23 = mu(3) - m23*mu(2);
    e23 = mean((v(3,:) - m23*v(2,:) - b23).^2);
    
end
