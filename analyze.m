function [res] = analyze(tmp, images, ~)
    % images -- acquired using `for i=1:500; images{i} = tracking(i); end;`
    res = zeros(size(tmp,1), 5);
    fr = 10;
    frwidth = size(images{1},2);
    
    for i =1:length(tmp);
        t = tmp(i,:);
        
        xmin = max(t(1)-fr,1);
        xmax = min(t(1)+fr,frwidth);
        ymin = max(t(2)-fr,1);
        ymax = min(t(2)+fr,frwidth);
        
        % surround the cell with a small box
        try
        b = images{t(3)}(xmin:xmax,ymin:ymax);
        if(nargin > 2)
        % show the image
            figure(1);
            hold off;
            subplot(2,1,1), imagesc(images{t(3)});
            title(tmp(i,3));
            hold on;
            scatter(tmp(i, 1), tmp(i, 2), 20,'ro');
            subplot(2,1,2); hold on; 
        end
        
        
        
        disp(t);
        
        ave = sum(sum(b));
        res(i,:) = [t(1:4) ave];
        catch err
            disp(err)
        end
    end;
    drawimage(tmp,res);
end

function drawimage(tmp,res)
    figure;
    for i=1:max(tmp(:,4));
       % get the color of the line plot
       c = double(i);
       c = [abs(sin(c)) abs(sin(c+pi/4)) abs(sin(c+pi/2))];
       hold on;
       plot(res(res(:,4)==i,3),res(res(:,4)==i,5),'Color', c);
    end
end