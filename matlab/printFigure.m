function printFigure(hFigureHandle, cOutputFilePath, inkscapepath)
    if nargin < 3
        inkscapepath = 'C:/Program Files/Inkscape/bin/inkscape.exe';
    end
    
    print(hFigureHandle, '-dsvg', strcat(cOutputFilePath,'.svg'));
    if exist(inkscapepath, 'file') == 2 
        %inkscape -D -z --file=image.svg --export-pdf=image.pdf --export-latex
       [a,b] = system(sprintf('"%s" "%s.svg" --export-area-drawing --export-type=pdf --export-filename="%s.pdf"',inkscapepath,cOutputFilePath));
    else
       warning('printFigure: svg to pdf conversion failed... Inkscape not found');
    end
%    print(hFigureHandle, '-depsc', '-tiff', '-r600', '-cmyk', strcat(cOutputFilePath,'.eps'));
%    [a,b] = system(sprintf('epstopdf --gsopt=-dPDFSETTINGS=/prepress --outfile=%s.pdf %s.eps',cOutputFilePath,cOutputFilePath));
%    if (~isempty(b))
%        warning('printFigure: eps to pdf conversion failed... ("%s")\n esp2pdf message: "%s"',cOutputFilePath,b);
%    end
end
