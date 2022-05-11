function plotAll()
    
    % input representation
    plotPeriodic();
    plotFourierSeries();
    plotPdfExamples();
    plotRfd();
    plotArithmeticMean();
    plotStandardDeviation();
    plotPdfQuantiles();
    plotBlocking();
    plotFourierTransform();
    plotSpecgram();
    plotLogMelSpecgram();
    plotGammatone();
    plotResonanceFilterbank();
    plotWaveform();
    plotFeatureExtraction();
    plotFeature();
    plotMfccMelDct();
    plotMfccFilterbank();
    plotTextureWindow();
    plotSequentialForwardSelection();

    %inference
    plotThresholdClassification();
    plotFeaturespace();
    plotKnn();
    plotGmm();
    plotLinearRegression();
    plotKmeans();
    plotOverfitting();

    %data
    plotDataSplit();

    %evaluation
    plotROC();

    %tonal
    plotHarmonics();
    plotMelBark();
    plotPitchHelix();
    plotPitchErrorTimeDomain();
    plotPitchErrorFreqDomain();
    plotTimeInterp();
    plotFreqInterp();
    plotF0Zcr();
    plotF0Acf();
    plotF0Amdf();
    plotF0HpsMethod();
    plotF0Hps();
    plotF0AcfOfFft();
    plotF0Cepstrum();
    plotF0Template();
    plotF0Auditory();
    plotF0Nmf();
    plotTuningFreqs();
    plotfA4Rprop();
    plotPitchChromaGrouping();
    plotPitchChroma();
    plotPitchChromaLeakage();
    plotKeyProfiles();
    plotChordTemplates();
    plotChordDetection();

    %intensity
    plotLogEpsilon();
    plotLoudnessWeighting();

    %temporal
    plotOnset();
    plotBeatHierarchy();
    plotNovelty();
    plotBeatHistogram();
    plotBeatGrid();
    plotStructure();
    plotSsm();
    plotSsmFeatures();
    plotCheckerBoard();
    plotSsmNovelty();
    plotSsmLowPass();
    plotSsmRotated();

    %alignment
    plotSequenceAlignment();
    plotDtwPath();
    plotDtwCost();
    plotDtwConstraints();
    plotDtwFeatures();

    %fingerprinting
    plotFingerprint();

    %genre
    plotFeatureScatter();

    %mood
    plotFeatureScatterMood();

    %fundamentals
    plotSampling01();
    plotSampling02();
    plotQuantization();
    plotQuantizationError();
    plotLowPass();
    plotZeroPhase();
    plotAcfExample();

    %fourier
    plotSpectralOverlap();
    plotSpectralWindows();
    plotInstantaneousFreq();
    plotPca();
    plotPcaExample();

    %other
    plotWaveformWithoutBg();
end
    
