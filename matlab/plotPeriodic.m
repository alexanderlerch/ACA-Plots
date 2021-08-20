function plotPeriodic()

    hFigureHandle = generateFigure(13.12,4);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';
    iStart  = 66000;
    iLength = 1024;

    % retrieve plotdata
    [t,x] = getData ([cAudioPath,cName], iStart, iLength);

    %plot
    plot(t,x);
    
    xlabel('$t/\mathrm{s}$');
    ylabel('$x_\mathrm{periodic}(t)$');
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
    axis([t(1) t(end) floor(-10*max(abs(x)))/10 ceil(10*max(abs(x)))/10])
    
    colorGtGold = [234, 170, 0]/256;
    annotation(hFigureHandle,'doublearrow',[0.397983358739837 0.497983358739837],...
        [0.873541666666667 0.873541666666667],'Color',colorGtGold,...
        'Head2Width',6,...
        'Head2Length',6,...
        'Head1Width',6,...
        'Head1Length',6);
    annotation(hFigureHandle,'textbox',[0.42 0.83 0.026 0.067],...
        'Color',colorGtGold,...
        'EdgeColor','none',...
        'String',{'$T_0$'},...
        'interpreter','latex');


    printFigure(hFigureHandle, cOutputFilePath)
end

function [t,x] = getData(cAudioPath, iStart, iLength)

    [x,fs] = audioread(cAudioPath, [iStart iStart+iLength-1]);
    t      = linspace(0,iLength/fs,iLength);

end
