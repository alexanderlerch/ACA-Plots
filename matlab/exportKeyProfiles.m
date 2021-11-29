function exportKeyProfiles  ()

    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../tables/' strrep(cName, 'export', '')];

    [y,d,circ] = getData ();

    tablesize = [7,13];
    astTable(tablesize(1),tablesize(2))    = struct('sValue', '');

    astTable(1,1).sValue = '';
    astTable(2,1).sValue = '$\nu_\mathrm{o}$';
    astTable(3,1).sValue = '$\nu_\mathrm{d}$';
    astTable(4,1).sValue = '$\nu_\mathrm{5}$';
    astTable(5,1).sValue = '$\nu_\mathrm{p}$';
    astTable(6,1).sValue = '$\nu_\mathrm{t}$';

    astTable(1,2).sValue = '$\nu(0)$';
    astTable(1,3).sValue = '$\nu(1)$';
    astTable(1,4).sValue = '$\nu(2)$';
    astTable(1,5).sValue = '$\nu(3)$';
    astTable(1,6).sValue = '$\nu(4)$';
    astTable(1,7).sValue = '$\nu(5)$';
    astTable(1,8).sValue = '$\nu(6)$';
    astTable(1,9).sValue = '$\nu(7)$';
    astTable(1,10).sValue = '$\nu(8)$';
    astTable(1,11).sValue = '$\nu(9)$';
    astTable(1,12).sValue = '$\nu(10)$';
    astTable(1,13).sValue = '$\nu(11)$';

    for (i = 2:6)
        for (j = 2:13)
            astTable(i,j).sValue = num2str(y(i-1,j-1),2);
            if (i == 4)
                astTable(i,j).sValue = ['$r\cdot e^{j 2\pi\frac{' num2str(circ(j-1)) '}{12}}$'];
            end
        end
    end

    printTable (astTable', strcat(cOutputPath,'.tex'));

end

% example function for data generation, substitute this with your code
function [kp,dist,circ] = getData ()

    circ = [0 -5 2 -3 4 -1 6 1 -4 3 -2 5];
    kp =[
        1       0       0       0       0       0       0       0       0       0       0       0 % diatonic
        %1       1       1       0       0       0       0       0       0       0       1       1 % smoothed orthogonal
        1       0       1       0       1       1       0       1       0       1       0       1 % diatonic
        j*circ/12 % circle of fifths
        6.35    2.23    3.48    2.33    4.38    4.09    2.52    5.19    2.39    3.66    2.29    2.88 % krumhansl
        0.748   0.06    0.488   0.082   0.67    0.46    0.096   0.715	0.104	0.366	0.057	0.4]; % temperley
    kp(3,:)  = exp(kp(3,:));

    % set the circle radius to 2
    R       = 1;
    kp(3,:)  = kp(3,:)*R;

    norm    = sqrt(sum(kp.^2,2));
    for (i = 2:size(kp,1))
        kp(i,:)  = kp(i,:) / norm(i);
    end

    dist = zeros(size(kp,1), size(kp,1)+1);
    for (k = 1: size(kp,1))
        for (i = 0:12)
            dist(k,i+1)    = sqrt((kp(k,:)-circshift(kp(k,:),[0 i]))*(kp(k,:)-circshift(kp(k,:),[0 i]))');
        end
    end
end
