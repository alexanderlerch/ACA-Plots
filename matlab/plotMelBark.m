function plotMelBark()

    if(exist('ToolFreq2Mel') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    hFigureHandle = generateFigure(13.12,5);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % read sample data
    [f,fMel,fBark,cLegendMel,cLegendBark]  = generateSampleData();

    subplot(121)
    semilogx(f/1000,fMel)
    legend (cLegendMel,'Location','NorthWest');
    xlabel('$f/ \mathrm{kHz}$')
    ylabel('Mel')
    axis([f(1)/1000 f(end)/1000 0 4000])

    subplot(122)
    semilogx(f/1000,fBark)
    legend (cLegendBark,'Location','NorthWest');
    xlabel('$f/ \mathrm{kHz}$')
    ylabel('Bark')
    axis([f(1)/1000 f(end)/1000 0 40])

    printFigure(hFigureHandle, cOutputFilePath)
end

function [f,fMel,fBark,cLegendMel,cLegendBark] = generateSampleData()
    
    f = 50:16000;
    cLegendMel = char('Fant','Shaughnessy', 'Umesh');
    cLegendBark = char('Schroeder','Terhardt', 'Zwicker');

    for (i = 1:size(cLegendMel,1))
        fMel(i,:) = ToolFreq2Mel(f,deblank(cLegendMel(i,:)));
    end
    for (i = 1:size(cLegendBark,1))
        fBark(i,:) = ToolFreq2Bark(f,deblank(cLegendBark(i,:)));
    end
end