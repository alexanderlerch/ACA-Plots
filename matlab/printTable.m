function printTable (fTable, cOutputPath, iHLineIdx, bIsSafe)

if (nargin < 4)
    bIsSafe = false;
end
if (nargin < 3)
    iHLineIdx = [];
end

[m,n] = size(fTable);

fid = fopen(cOutputPath, 'wt');


if (bIsSafe)
    cHline = '\savehline';
else
    cHline = '\hline';
    fprintf(fid, '\\\\ %s\n', cHline);
end

fprintf(fid, '\\bf{\\emph{%s}}',deblank(fTable(1, 1).sValue));
for (j = 2:n)
    fprintf(fid, '\t & \\bf{\\emph{%s}}',deblank(fTable(1,j).sValue));
end

fprintf (fid, '\\\\ \n %s\n', cHline);


for (i = 2:m)
    fprintf(fid, '\\bf{%s}', fTable(i, 1).sValue);
    for (j = 2:n)
        fprintf(fid, '\t & %s', fTable(i,j).sValue);
    end
    fprintf (fid, '\\\\\n');
    if (find(iHLineIdx == i))
        fprintf (fid, '%s\n', cHline);
    end
end
%fprintf (fid, '\\hline\n');
fclose (fid);
