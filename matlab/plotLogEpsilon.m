function plotLogEpsilon()

    % generate new figure
    hFigureHandle = generateFigure(12, 3);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % generate plot data
    [x, deltadb, epsilon] = getData ();

    % plot 
    plot (x, deltadb(1, :),...
        x, deltadb(2, :),...
        x, deltadb(3, :),...
        x, deltadb(4, :));

    % data formatting
    axis([x(end) x(1) -.5 20]);
    lh = legend(['$\epsilon = ' num2str(epsilon(1)', '%1.0e') '$'],...
        ['$\epsilon = ' num2str(epsilon(2)', '%1.0e') '$'],...
        ['$\epsilon = ' num2str(epsilon(3)', '%1.0e') '$'],...
        ['$\epsilon = ' num2str(epsilon(4)', '%1.0e') '$']);
    xlabel('$v_\mathrm{dB} / dBFS$');
    ylabel('$(v_\mathrm{app.,dB}-v_\mathrm{dB}) / dB$');

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)

end

function     [fMagIndB, fError, fEpsilon] = getData ()
    fLowerBound = 0.01;
    fUpperBound = 1;
    iNumValues = 16384;
    fEpsilon = [0.1 0.01 0.001 0.0001];
    fMagnitude = linspace (fUpperBound, fLowerBound, iNumValues);

    fMagIndB = 20*log10(fMagnitude);
    for i=1:size(fEpsilon, 2)
        fError(i, :) = 20 * log10(fMagnitude + fEpsilon(i)) - fMagIndB;
    end
end
    
