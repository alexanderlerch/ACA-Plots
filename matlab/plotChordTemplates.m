function plotChordTemplates()

    % generate new figure
    hFigureHandle = generateFigure(13.2, 6);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    [T] = getData();

    % set the strings of the axis labels
    cYLabel2 = 'pitch class';
    
    % plot 
    imagesc(T)
    xlabel('pitch class')
    ylabel('chord template $\Gamma$')
    set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10 11 12])
    set(gca, 'XTickLabel', {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'})
    set(gca, 'YTick', [1 3 5 6 8 10 12 13 15 17 18 20 22 24])
    set(gca, 'YTickLabel', {'C Maj', 'D Maj', 'E Maj', 'F Maj', 'G Maj', 'A Maj', 'B Maj', 'c min', 'd min', 'e min', 'f min', 'g min', 'a min', 'b min'})
    colormap([1 1 1; getAcaColor('darkgray')]); 
    
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [T] = getData()
    T = zeros(24, 12);
    T(1, [1 5 8]) = 1/3;
    T(13, [1 4 8]) = 1/3;
    for i = 1:11
        T(i+1, :) = circshift(T(i, :), 1, 2);
        T(i+13, :) = circshift(T(i+12, :), 1, 2);
    end
end
