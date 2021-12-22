function exportFftResolution ()

    % set output path relative to script location and to script name
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../tables/' strrep(cName, 'export', '')];

    % add range
    % add normalized or not
    iFeatIdx    = 1;
    Feature{iFeatIdx,1} = '$\mathcal{K}$';
    Feature{iFeatIdx,2} = '$\Delta f\;[\unit{Hz}]$';
    Feature{iFeatIdx,3} = '$k_\mathrm{ST}$';
    Feature{iFeatIdx,4} = '$f(k_\mathrm{ST})\;[\unit{Hz}]$';

    fs          = 48000;
    iFFTLength  = [256, 512, 1024, 2048, 4096, 8192, 16384];
    fFreqRes    = fs./iFFTLength;

    for (i = 1:length(iFFTLength))
        fFrequencies = (0:(iFFTLength(i)/2))*fFreqRes(i);
        fPitch       = 69+12*log2(fFrequencies/440);
        iIndex(i)    = min(find(diff(fPitch) < .5))-1;

        iFeatIdx = iFeatIdx + 1;
        Feature{iFeatIdx,1} = int2str(iFFTLength(i));
        Feature{iFeatIdx,2} = num2str(fFreqRes(i),'%.2f');
        Feature{iFeatIdx,3} = int2str(iIndex(i));
        Feature{iFeatIdx,4} = num2str(fFrequencies(iIndex(i)+1),'%.2f');
    end

    tablesize = size(Feature);
    astTable(tablesize(1),tablesize(2))    = struct('sValue', '');

    for (i = 1:tablesize(1))
        for (j = 1:tablesize(2))
            astTable(i,j).sValue     = char (Feature(i,j));
        end
    end

    printTable (astTable, strcat(cOutputPath,'.tex'));
end