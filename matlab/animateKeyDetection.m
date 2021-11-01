function animateKeyDetection()

     hFigureHandle = generateFigure(13.12,7);
    
    [cPath, cName]  = fileparts(mfilename('fullpath'));
    cOutputPath = [cPath '/../graph/animation/' strrep(cName, 'animate', '')];
    
    [testprofile, refprofile]   = getData();

    iNumFrames      = 12;
    framerate = 1;
    
    for (i = 1:iNumFrames)
        dist(i)    = sqrt(sum(abs(testprofile-refprofile).^2));
        subplot(211)
        plot(1:12,testprofile,'o-', 'Color',[234/256 170/256 0]), hold on
        plot(1:12,refprofile, 'ko-','LineWidth',1.5), hold off
        set(gca,'XTick',1:12),xlim([1 12])
        set(gca,'XTickLabel',{'C', 'C#', 'D', 'D#', 'E','F', 'F#', 'G', 'G#', 'A', 'A#','B'})
        xlabel('Pitch Class');
        ylabel('Key Profiles');
        legend('measure','ref');
 
        subplot(212)
        bar(dist,'k')
        set(gca,'XTick',1:12),xlim([.5 12.5]),grid on
        set(gca,'XTickLabel',{'C M', 'C# M', 'D M', 'D# M', 'E M','F M', 'F# M', 'G M', 'G# M', 'A M', 'A# M','B M'})
        axis([.5 12.5 0 0.3])
        xlabel('Key');
        ylabel('Distance');

        refprofile = circshift(refprofile,[0 1]);
        for (k =1:framerate)
            printFigure(hFigureHandle, [cOutputPath '-' num2str(i,'%.2d')]); 
        end
    end  
    
    [dummy,keyidx] = min(dist);
    
    dist((1:length(dist))~=keyidx) = 0;
    hold on,
    bar(dist,'FaceColor',[234/256 170/256 0]);
    hold off
    for (k =1:2*framerate)
        printFigure(hFigureHandle, [cOutputPath '-' num2str(i,'%.2d')]); 
    end
 end

function [testprofile, refprofile]   = getData()
    profile(1,:) = [6.35    2.23    3.48    2.33    4.38    4.09    2.52    5.19    2.39    3.66    2.29    2.88]; % krumhansl
    profile(2,:) = [0.748   0.06    0.488   0.082   0.67    0.46    0.096   0.715	0.104	0.366	0.057	0.4]; % temperley
    
    profile     = diag([1./sum(profile,2)']) * profile;
    
    testprofile = circshift(profile(1,:),[0 7]);
    refprofile  = profile(2,:);
end
