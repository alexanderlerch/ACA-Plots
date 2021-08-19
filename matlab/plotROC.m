function plotROC ()

    hFigureHandle = generateFigure(13.12,7);

    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];

    ROC = 0:.001:1;
    
    plot(ROC,ROC)
    hold on;
    plot(ROC,ROC.^.5)
    plot(ROC,ROC.^.25)
    plot(ROC,ROC.^.125)
%     plot(ROC,ROC.^2)
%     plot(ROC,ROC.^4)
%     plot(ROC,ROC.^8)
    plot(ROC,[0 ones(1,length(ROC)-1)])
    axis([-.01 1 0 1.01])
    ylabel('TPR')
    xlabel('FPR')
    hold off;
    text(.05, .97,'perfect classifier')
    text(.4, .35,'random classifier','rotation', 30)
    annotation(hFigureHandle,'arrow',[0.3 0.2],...
        [.35 0.6],...
        'HeadWidth',6,...
        'HeadStyle','plain',...
        'HeadLength',6);
    text(.13,.5,'better')
    
    legend('AUC = 0.5', 'AUC = 0.67', 'AUC = 0.75', 'AUC = 0.88', 'AUC = 1.0','Location', 'southeast')

    printFigure(hFigureHandle, cOutputPath)
end

