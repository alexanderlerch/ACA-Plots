function plotMfccMelDct ()
 
    if(exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end

    hFigureHandle = generateFigure(13.12,18);
 
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    [x, H] = getData ();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set the strings of the axis labels
    cXLabel = '$f / \mathrm{kHz}$';
    cYLabel = '$H_\mathrm{MFCC}(f)$';


    numCols = 4;
    for (i = 1:size(H,2))
        subplot(size(H,2)/numCols,numCols,i),
        %area(x,H(:,i),'BaseValue',-1,'FaceColor', [.99 .99 .99]),hold on
        plot(x,H(:,i)), 
        %hold off
        axis([x(1) x(end) -1 1])
        %grid on

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
    
    printFigure(hFigureHandle, cOutputFilePath)
end

% example function for data generation, substitute this with your code
function [f,H] = getData ()
    K = 3000;
    
    m = 1:K;

    %f = 700 * (10.^(m/2595)-1);
    f = ToolMel2Freq(m);

    k = 1:K;

    for (i = 1:16)
        H(:,i) = cos(i*pi/K*(k-.5));
    end

    f   = f/1000;

end
