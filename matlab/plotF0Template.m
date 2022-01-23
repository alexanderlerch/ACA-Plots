function plotF0Template ()

    % check for dependency
    if(exist('ToolMidi2Freq') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    
    % generate new figure
    hFigureHandle = generateFigure(13.12, 8);
    
    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
    cAudioPath = [cPath '/../audio/'];
    cName = 'sax_example.wav';

    % read audio and generate plot data
    [f, Template, f_hr, Template_hr, X, f_c, p_coeff, f_0] = getData([cAudioPath, cName]);

    % set the strings of the axis labels
    cXLabel1 = '$t / \mathrm{s}$';
    cXLabel2 = '$\eta / \mathrm{samples}$';
    cYLabel1 = '$x(t)$';
    cYLabel2 = '$r_{xx}(\eta)$';
    cYLabel12 = '$x_\mathrm{clip}(t)$';
    cYLabel22 = '$r_{x_cx_c}(\eta)$';

    % plot
    for c = 1:11
        subplot(11, 6, [1:4]+(c-1)*6)
        plot(f_hr, Template_hr(c, :))
        axis([f_hr(1) .2*f_hr(end) 0 1])
        set(gca, 'XTickLabel', [])
        set(gca, 'YTickLabel', [])
        set(gca, 'YTick', [])
    end
    xlabel('$f$')
    
    subplot(11, 6, [1:11]*6-1)
    semilogy(f, X)
    axis([f(1) .2*f(end) 10^(-10) max(max(X)) ])
    view(90, 90)
    set(gca, 'XTickLabel', [])
    set(gca, 'YTickLabel', [])
    ylabel('$|X(f)|$')
    
    subplot(11, 6, [1:11]*6)
    line(f_0*ones(1, 2), [0 max(p_coeff)], 'LineWidth', 2.5, 'Color', [234/256 170/256 0])
    hold on
    plot(f_c, p_coeff)
    hold off
    axis([f_c(1) f_c(end) 0 max(p_coeff) ])
    set(gca, 'XAxisLocation', 'top')
    view(90, 90)
    box on
    set(gca, 'ycolor', 'k')
    
    xtick = get(gca, 'XTick');
    xtick = sort([xtick f_0]);
    set(gca, 'XTick', xtick);
    xticklabel = get(gca, 'XTickLabel');
    xticklabel(xtick == f_0) = {'$\hat{f}_0$'};
    xticklabel(xtick ~= f_0) = {''};
    set(gca, 'XTickLabel', xticklabel)
    set(gca, 'YTickLabel', [])
    ylabel('template strength')
    
    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [f, Template, f_hr, Template_hr, X, f_c, p_coeff, f_0] = getData(cInputFilePath)

    iStart = 66000;
    iLength = 4096;
    
    % read audio
    [x, f_s] = audioread(cInputFilePath, [iStart iStart+iLength-1]);
    x = x / max(abs(x));

    [f, Template, f_hr, Template_hr, f_c] = GenerateTemplate_I(iLength, f_s, 11, 440);

    X(1, :) = (abs(fft(hann(iLength).*x))*2/iLength).^2;
    X = X(1:iLength/2+1);

    p_coeff = Template * X';
    [~, p_idx] = max(p_coeff);

    f_0 = f_c(p_idx);
end

function [f_fft,H,f_fft_hr,H_hr,f_c] = GenerateTemplate_I (iFftLength, f_s, iNumFilters, f_A4)

    % initialization
    iNumHarmonics = 8;
    p_start = 60;
    p_c = p_start:p_start+iNumFilters-1;
    p_l = p_c - .5;
    p_u = p_c + .5;
    f_c = ToolMidi2Freq(p_c, f_A4);
    f_l = ToolMidi2Freq(p_l, f_A4);
    f_u = ToolMidi2Freq(p_u, f_A4);

    f_fft = linspace(0, f_s/2, iFftLength/2+1);
    f_fft_hr = linspace(0, f_s/2, 64*iFftLength/2+1);
    H = zeros(iNumFilters, length(f_fft));
    H_hr = zeros(iNumFilters, length(f_fft_hr));

    % compute the transfer functions
    for c = 1:iNumFilters
        for h = 1:iNumHarmonics
            H(c, f_fft > h*f_l(c) & f_fft <= h*f_u(c)) = sin(pi * (f_fft(f_fft > h*f_l(c) & f_fft <= h*f_u(c))-h*f_l(c)) / (h*f_u(c)-h*f_l(c))).^2;
            H_hr(c, f_fft_hr > h*f_l(c) & f_fft_hr <= h*f_u(c)) = sin(pi * (f_fft_hr(f_fft_hr > h*f_l(c) & f_fft_hr <= h*f_u(c))-h*f_l(c)) / (h*f_u(c)-h*f_l(c))).^2;
        end
    end
end