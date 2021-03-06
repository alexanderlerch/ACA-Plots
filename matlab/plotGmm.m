function plotGmm (cDatasetPath)

    if (nargin<1)
        % this script is written for the GTZAN dataset
        % this path needs to be edited
        cDatasetPath = 'd:\dataset\music_speech\';  
    end

    if (exist('ComputeFeature') ~=2)
        error('Please add the ACA scripts (https://github.com/alexanderlerch/ACA-Code) to your path!');
    end
    if ((exist([cDatasetPath 'music']) ~= 7) || (exist([cDatasetPath 'speech']) ~= 7))
        error('Dataset path wrong or does not contain music/speech folders!')
    end
    
    % generate new figure
    hFigureHandle = generateFigure(13.12, 10);

    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/' strrep(cName, 'plot', '')];
  
    cMusic = 'music';
    cSpeech = 'speech';
    cXLabel = '$\mu_\mathrm{SC}$';
    cYLabel = '$\sigma_\mathrm{RMS}$';

    % read audio data
    music_files = dir([cDatasetPath 'music/*.au']);
    speech_files = dir([cDatasetPath 'speech/*.au']);
 
    v_music = zeros(2, size(music_files, 1));
    v_speech = zeros(2, size(speech_files, 1)); 
    
    % assuming the same number of files in both directories....
    for (i=1:size(music_files, 1))
        v_music(:, i) = ExtractFeaturesFromFile([cDatasetPath 'music/' music_files(i).name]);
        v_speech(:, i) = ExtractFeaturesFromFile([cDatasetPath 'speech/' speech_files(i).name]);
    end

    % normalization
    for f = 1:size(v_music, 1)
        minimum = min([v_music(f, :) v_speech(f, :)]);
        maximum = max([v_music(f, :) v_speech(f, :)]) - minimum;
        v_music(f, :) = (v_music(f, :) - minimum) / maximum;
        v_speech(f, :) = (v_speech(f, :) - minimum) / maximum;
    end
    
    % seed for reproducibility
    rng(42)

    % get Gaussian parameters for 2 mixtures
    [mu_speech, sigma_speech, dummy] = ToolGmm(v_speech, 2);
    [mu_music, sigma_music, dummy] = ToolGmm(v_music, 2);

    % generate plot data from models
    numAxisPoints = 1000;
    tick = linspace(0, 1, numAxisPoints);
    
    % 1-d models for two dimensions (sum up 2 Gaussians)
    Gmm1d_speech = zeros(numAxisPoints, 2);
    model = computeGaussian(tick, mu_speech(1, :), sigma_speech(1, 1, :));
    Gmm1d_speech(:, 1) = sum(model, 2);
    model = computeGaussian(tick, mu_speech(2, :), sigma_speech(2, 2, :));
    Gmm1d_speech(:, 2) = sum(model, 2);

    Gmm1d_music = zeros(numAxisPoints, 2);
    model = computeGaussian(tick, mu_music(1, :), sigma_music(1, 1, :));
    Gmm1d_music(:, 1) = sum(model, 2);
    model = computeGaussian(tick, mu_music(2, :), sigma_music(2, 2, :));
    Gmm1d_music(:, 2) = sum(model, 2);
    
    
    % 2-d models (sum up 2 Gaussians)
    tick = tick(1:20:end);
    numAxisPoints = numAxisPoints / 20;
    [m n] = meshgrid(tick, tick);
    plotGrid = [m(:), n(:)]';
    
    model = computeGaussian(plotGrid, mu_speech, sigma_speech);
    Gmm2d_speech = reshape(sum(model, 2), numAxisPoints, numAxisPoints);

    model = computeGaussian(plotGrid, mu_music, sigma_music);
    Gmm2d_music = reshape(sum(model, 2), numAxisPoints, numAxisPoints);


    % plot
    iMarkerSize = 8;
    ax=subplot(10, 5, [11:14, 16:19, 21:24, 26:29]);
    scatter(v_music(1, :), v_music(2, :), iMarkerSize, getAcaColor('darkgray'), 'filled', 'o', 'MarkerEdgeColor', getAcaColor('darkgray', true));
    box on
    xlabel(cXLabel)
    ylabel(cYLabel)
    set(gca, 'XTickLabel', [], 'YTickLabel', []);
    hold on;
    scatter(v_speech(1, :), v_speech(2, :), iMarkerSize, getAcaColor('main'), 'filled', 'd', 'MarkerEdgeColor', getAcaColor('main', true));
    
    c = colormap(gray);
    c = flipud(c(round(size(c, 1)/2):end-1, :));
    colormap(ax, c)
    contour(tick, tick, Gmm2d_speech)
    contour(tick, tick, Gmm2d_music)
    scatter(v_music(1, :), v_music(2, :), iMarkerSize, getAcaColor('darkgray'), 'filled', 'o', 'MarkerEdgeColor', getAcaColor('darkgray', true));
    scatter(v_speech(1, :), v_speech(2, :), iMarkerSize, getAcaColor('main'), 'filled', 'd', 'MarkerEdgeColor', getAcaColor('main', true));
    hold off;
    legend(cMusic, cSpeech, 'Location', 'NorthWest')

    subplot(10, 5, [1:4, 6:9])
    plot(Gmm1d_music(:, 1), 'Color', getAcaColor('darkgray'))
    hold on;
    plot(Gmm1d_speech(:, 1), 'Color', getAcaColor('main'))
    hold off;
    set(gca, 'YTickLabel', {})
    set(gca, 'XTickLabel', {})

    subplot(10, 5, [15, 20, 25, 30])
    plot(Gmm1d_music(:, 2), 'Color', getAcaColor('darkgray'))
    hold on;
    plot(Gmm1d_speech(:, 2), 'Color', getAcaColor('main'))
    hold off;
    view([-270 -90])
    set(gca, 'YTickLabel', {})
    set(gca, 'XTickLabel', {})

    ax = subplot(10,5,31:50);
    mesh(Gmm2d_speech, 'FaceColor', 'none', 'FaceAlpha', 0.9, 'EdgeColor', getAcaColor('main'))
    hold on; 
    mesh(Gmm2d_music, 'FaceColor', 'none', 'FaceAlpha', 0.9, 'EdgeColor', getAcaColor('darkgray', true))
    hold off;
    view([-77 24])
    set(gca, 'YTickLabel', {})
    set(gca, 'XTickLabel', {})
    set(gca, 'ZTickLabel', {})
    xlabel(cXLabel)
    ylabel(cYLabel)
    
    printFigure(hFigureHandle, cOutputPath)
end

function [v] = ExtractFeaturesFromFile(cFilePath)

    cFeatureNames = char('SpectralCentroid',...
        'TimeRms');

    [x,f_s] = audioread(cFilePath);
    x = x / max(abs(x));
    
    feature = ComputeFeature (deblank(cFeatureNames(1, :)), x, f_s);
    v(1, 1) = mean(feature(1, :));
    
    feature = ComputeFeature (deblank(cFeatureNames(2, :)), x, f_s);
    v(2, 1) = std(feature(1, :));
    
end   

function G = computeGaussian(X, mu, sigma)
    K = length(mu);
    G = zeros(size(X, 2), K);
    
    % for each cluster
    for k=1:K
        % subtract mean
        Xm = X - repmat(mu(:, k), 1, size(X, 2));

        %  gaussian
        G(:, k) = 1 / sqrt((2*pi)^size(Xm, 1) * det(sigma(:, :, k))) * exp(-1/2 * sum((Xm .* (inv(sigma(:, :, k)) * Xm)), 1)');
    end
end


