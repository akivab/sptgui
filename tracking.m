function [a,res] = tracking(ix, images)
    global file;
    if(nargin < 1)
        frames = 500;
        a = [];
        r = [];
        [f,path] = uigetfile;
        file = strcat(path,f);
        for i=1:frames;
            a{i} = tracking(i);
            % run a bandpass filter over data
            b = bpass(a{i},1,10);
            % find peaks in the data
            pk = pkfnd(b,max(max(b))*.2,10);
            % add the positions of peaks (and frames) to peak data
            for j=1:length(pk);
                r = [r; pk(j,1) pk(j,2) i];
            end
        end
        
        param.mem = 3;
        param.dim = 2;
        param.quiet = 0;
        param.good = 10;
        res = track(r, 10, param);
    elseif(nargin < 2)
        a = imread(file, ix);
        imagesc(a);
    elseif(nargin == 2)
        r = [];
        a = [];
        for i=1:length(images);
            % run a bandpass filter over data
            b = bpass(images{i},1,10);
            % find peaks in the data
            pk = pkfnd(b,max(max(b))*.2,10);
            % add the positions of peaks (and frames) to peak data
            for j=1:length(pk);
                r = [r; pk(j,1) pk(j,2) i];
            end
        end
        
        param.mem = 3;
        param.dim = 2;
        param.quiet = 0;
        param.good = 10;
        res = track(r, 10, param);
    end 
end