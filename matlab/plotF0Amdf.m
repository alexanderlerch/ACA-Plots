function plotF0Amdf ()
    
    % generate new figure
    hFigureHandle = generateFigure(13.12, 6);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    % read audio and generate plot data
    [t, x, eta, amdf, ra, T_0, T_0A] = getData ([cAudioPath, cName]);

    % set the strings of the axis labels
    cXLabel1 = '$t\; [\mathrm{s}]$';
    cXLabel2 = '$\eta\; [\mathrm{samples}]$';
    cYLabel1 = '$x(t)$';
    cYLabel2 = '$AMDF(\eta)$';
    cYLabel22 = '$r_{xx}(\eta)/AMDF(\eta)$';

    % plot
    subplot(221), 
    plot(t, x, 'LineWidth', .5),
    axis([t(1) t(end) -1 1])
    xlabel(cXLabel1)
    ylabel(cYLabel1)

    subplot(223)
    line(T_0*ones(1, 2), [-1 1], 'LineWidth', 2.5, 'Color', getAcaColor('main'))
    axis([eta(1) eta(end) -1 1])
    hold on;
    plot(eta, amdf, 'LineWidth', .5),
    hold off;
    box on;

    xtick = get(gca, 'XTick');
    xtick = sort([xtick T_0]);
    set(gca, 'XTick', xtick);
    xticklabel = get(gca, 'XTickLabel');
    xticklabel(xtick == T_0) = {'$\hat{T}_0$'};
    xticklabel(xtick == 1000) = {'~'};
    set(gca, 'XTickLabel', xticklabel)
    xlabel(cXLabel2)
    ylabel(cYLabel2)
    
    subplot(222), 
    plot(t, x, 'LineWidth', .5),
    axis([t(1) t(end) -1 1])
    xlabel(cXLabel1)
    ylabel(cYLabel1)

    subplot(224)
    line(T_0A*ones(1, 2), [-1 max(ra)], 'LineWidth', 2.5, 'Color', getAcaColor('main'))
    axis([eta(1) eta(end) -1 max(ra)])
    hold on;
    plot(eta, ra, 'LineWidth', .5),
    hold off;
    box on;

    xtick = get(gca, 'XTick');
    xtick = sort([xtick(xtick ~= 0) T_0A]);
    set(gca, 'XTick', xtick);
    xticklabel = get(gca, 'XTickLabel');
    xticklabel(xtick == T_0A) = {'$\hat{T}_0$'};
    set(gca, 'XTickLabel', xticklabel)
    xlabel(cXLabel2)
    ylabel(cYLabel22)

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [t, x, eta, afAMDF, ra, T0, T_0A] = getData(cInputFilePath)

    iStart = 66000;
    iLength = 4096;
    
    % read audio
    [x, f_s] = audioread(cInputFilePath, [iStart iStart+iLength-1]);
    t = linspace(0, length(x)/f_s, length(x));
    x = x / max(abs(x));

    %initialization
    fMaxFreq = 2000;
    fMinThresh = 0.35;
    eta_min = round(f_s/fMaxFreq);

    % copied from ACA-Code/PitchTimeAcf.m
    % calculate the acf maximum
    r = xcorr(x, 'coeff');
    r = r((ceil((length(r)/2))+1):end);
    eta = 0:(length(r)-1);
    
    % ignore values until threshold was crossed
    eta_tmp = find (r < fMinThresh, 1);
    if (~isempty(eta_tmp))
        eta_min = max(eta_min, eta_tmp);
    end

    % only take into account values after the first minimum
    afDeltaCorr = diff(r);
    eta_tmp = find(afDeltaCorr > 0, 1);
    if (~isempty(eta_tmp))
        eta_min = max(eta_min, eta_tmp);
    end

    %initialization
    f_max = 1000;
    f_min = 50;
    eta_min = round(f_s/f_max);
    eta_max = round(f_s/f_min);

    % copied from ACA-Code/PitchTimeAcf.m
    % calculate the acf maximum
    afAMDF = amdf_I(x, eta_max);
    [fDummy, T0]= min(afAMDF(1+eta_min:end));

    ra = r ./ (afAMDF+1)';
    [fDummy, T_0A] = max(ra(1+eta_min:end));

    % T0 in samples
    T0 = T0 + eta_min;
    T_0A = T_0A + eta_min;
end

function [AMDF] = amdf_I(x, eta_max)
    K = length(x);
 
    AMDF = ones(1, K-1);
    
    for eta=0:min(K-1, eta_max-1)
        AMDF(eta+1) = sum(abs(x(1:K-1-eta) - x(eta+2:end))) / K;
    end
end