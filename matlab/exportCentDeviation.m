function exportCentDeviation ()

    % set output path relative to script location and to script name
    [cPath, cName] = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../tables/' strrep(cName, 'export', '')];

    iFeatIdx    = 1;
    Feature{1,iFeatIdx} = 'Harmonic';
    Feature{2,iFeatIdx} = '$f = f_0$';
    Feature{3,iFeatIdx} = '$f = 2\cdot f_0$';
    Feature{4,iFeatIdx} = '$f = 3\cdot f_0$';
    Feature{5,iFeatIdx} = '$f = 4\cdot f_0$';
    Feature{6,iFeatIdx} = '$f = 5\cdot f_0$';
    Feature{7,iFeatIdx} = '$f = 6\cdot f_0$';
    Feature{8,iFeatIdx} = '$f = 7\cdot f_0$';
    Feature{9,iFeatIdx} = '$\mu_{|\Delta C|}$';
    
    Feature{1,2}        = '$|\Delta C(f,f_T)|$';
    
    fStartPitch         = 60;
    fTuningFreq         = 440;
    for (i = 1:1)
        iFeatIdx = iFeatIdx + 1;
        
        fFreq       = Pitch2Freq(fStartPitch + (i-1), fTuningFreq);
        %Feature{1,iFeatIdx}     = num2str(i);
        for (j = 1:7)
            fNewFreq            = j*fFreq;
            fPitch              = Freq2Pitch(fNewFreq, fTuningFreq);
            fDiff(j)            = 100*abs(fPitch - round(fPitch));
            Feature{j+1,iFeatIdx} = num2str(fDiff(j), '%.2f');
        end
        Feature{9,iFeatIdx}     = num2str(mean(fDiff), '%.2f');
    end
    
    tablesize = size(Feature);
    astTable(tablesize(1),tablesize(2))    = struct('sValue', '');
    
    for (i = 1:tablesize(1))
        for (j = 1:tablesize(2))
            astTable(i,j).sValue     = char (Feature(i,j));
        end
    end
    
    printTable (astTable, strcat(cOutputPath, '.tex'));
end

function [f] = Pitch2Freq(fPitch, fTuningFreq)

f = 2^((fPitch-69)/12)*fTuningFreq;
end
function [p] = Freq2Pitch(fFreq, fTuningFreq)
p = 69+12*log2(fFreq/fTuningFreq);
end