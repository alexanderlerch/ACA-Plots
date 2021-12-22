function plotMfccMelDct ()
 
    % check for dependency
    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    % generate new figure
    hFigureHandle = generateFigure(13.12,18);
 
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    [x, H] = getData ();

    % set the strings of the axis labels
    cXLabel = '$f / \mathrm{kHz}$';
    cYLabel = '$H_\mathrm{MFCC}(f)$';

    % plot
    numCols = 4;
    for (i = 1:size(H,2))
        subplot(size(H,2)/numCols,numCols,i),
        plot(x,H(:,i)), 
        axis([x(1) x(end) -1 1])

        if (mod(i,numCols) == 1)
            ylabel(cYLabel);
        else
            set(gca,'YTickLabel','');
        end
        if (i/numCols > (size(H,2)/numCols -1))
            xlabel(cXLabel);
        else
            set(gca,'XTickLabel','');
        end
    end

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f,H] = getData ()
    K = 3000;
    
    m = 1:K;

    f = ToolMel2Freq(m);

    k = 1:K;

    for (i = 1:16)
        H(:,i) = cos(i*pi/K*(k-.5));
    end

    f   = f/1000;

end
