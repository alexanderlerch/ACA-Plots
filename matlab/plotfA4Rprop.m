function plotfA4Rprop()

    % generate new figure
    hFigureHandle = generateFigure(13.12,4);
    
    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputFilePath = [cPath '/../graph/' strrep(cName, 'plot', '')];
 
    % generate plot data
    [t,f] = getData();
    
    % plot
    plot(t,452*ones(size(t)), 'Color', [.8 .8 .8])
    hold on;
    plot(t,f, 'k');
    axis([t(1) 0.03 435 460])
    hold off;
    
    xlabel('$t/\mathrm{s}$');
    ylabel('$\hat{f}_\mathrm{A4} /\mathrm{Hz}$');

    % write output file
    printFigure(hFigureHandle, cOutputFilePath)
end

function [t,f_hat] = getData()

    df_min  = 1e-20;
    df_max  = 10;
    f_start = 440;
    f_target= 452;
    
    fs      = 4800;
    t       = linspace(0,0.04,0.04*fs);
    
    f_hat   = zeros(size(t));
    f_hat(1)= f_start;
    df      = df_min;
    direction_prev = 0;
    
    % iterate until end of t
    for i=2:length(t)
        % current direction
        direction = sign(f_target - f_hat(i-1));
        
        % increase if same as previous direction, otherwise decrease
        if (direction == direction_prev)
            df  = min(1.9*df,df_max);
        else
            df  = max(.5*df,df_min);
        end
        % update fA4
        f_hat(i)= f_hat(i-1) + direction*df;
        direction_prev = direction;
    end
end

