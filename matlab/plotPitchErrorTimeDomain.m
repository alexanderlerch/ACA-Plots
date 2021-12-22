function plotPitchErrorTimeDomain()

    % generate new figure
    hFigureHandle = generateFigure(13.12,6);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    % read sample data
    [f,e_p,cLegend]  = getData();
    
    % plot
    semilogx(f,e_p,'LineWidth',.5);
    axis([f(1) f(end) -90 90])
    xlabel('$f_0$/Hz');
    ylabel('$1200\cdot\log_2\left(\frac{\hat{f_0}}{f_0}\right)$ [cent]');
    lh = legend(cLegend);
    set(lh,'Location','NorthWest','Interpreter','latex')

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f,e_p,cLegend] = getData()

    fs      = [44100,48000,96000];
    f       = linspace(100, 5000, 2^16);
    cLegend = {};
    
    for i=1:length(fs)
        TinSamples(i,:)     = fs(i)./f;
        TqInSamples(i,:)    = round(TinSamples(i,:));
        e_p(i,:)            = (1200*log2(TinSamples(i,:)./TqInSamples(i,:)));
        cLegend{i}          = ['$f_\mathrm{S} = ' num2str(fs(i)/1000) '$ kHz'];
    end
    cLegend = char(cLegend);
end

