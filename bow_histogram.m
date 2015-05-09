function [Hist_T, Hist_D] = bow_histogram(CCenter, l, train_D, train_F, test_D, test_F)
    %CCenter: Cluster Centers
    %l: level of the spatial pyramid
    
    %Each image has 2^l * 2^l Histograms
    %Each histogram is a 1 x K matrix
    
    load('class_data.mat');
    
    Hist_T = [];
    Hist_D = [];
    
    [~, K] = size(CCenter);
    
    a = 256 / 2^l;
    
    %Construct Histogram for training images
    for im = 1:800
        %The 2^l*2^l x K Hist of image i
        
        Hi = zeros((2^l)^2, K);
        Si = train_D{im};
        Fi = train_F{im};
        
        [~, ni] = size(Si);
        
        for j = 1:2^l
           for i = 1:2^l
                %bin (i, j)
                %computer image boundary
                t = sub2ind([2^l 2^l], i, j);
                x_min = (j - 1) * a;
                x_max = j * a;              
                y_min = (i - 1) * a;
                y_max = i * a;
                
                XFi = Fi(1, :);
                YFi = Fi(2, :);
                
                X = find(XFi > x_min);
                X = intersect(X, find(XFi < x_max));
                Y = find(YFi > y_min);
                Y = intersect(Y, find(YFi < y_max));
                
                %The SIFT in the subimage/bin
                S = double(Si(:, intersect(X, Y)));
                [~, ns] = size(S);
                
                for s = 1:ns
                    d = zeros(1, K);

                    for k = 1:K
                       d(k) = norm(S(:, s) - CCenter(:, k)); 
                    end  

                    [~, c_id] = min(d);
                    Hi(t, c_id) = Hi(t, c_id) + 1;
                end
                
                %Normalize
                Hi(t, :) = Hi(t, :) / ni;
           end
        end
        
        Hist_T = [Hist_T; Hi];
    end
    
	%Construct Histogram for Test images
    for im = 1:200
        %The 2^l*2^l x K Hist of image i
        
        Hi = zeros((2^l)^2, K);
        Si = test_D{im};
        Fi = test_F{im};
        
        [~, ni] = size(Si);
        
        for j = 1:2^l
           for i = 1:2^l
                %bin (i, j)
                %computer image boundary
                t = sub2ind([2^l 2^l], i, j);
                x_min = (j - 1) * a;
                x_max = j * a;              
                y_min = (i - 1) * a;
                y_max = i * a;
                
                XFi = Fi(1, :);
                YFi = Fi(2, :);
                
                X = find(XFi > x_min);
                X = intersect(X, find(XFi < x_max));
                Y = find(YFi > y_min);
                Y = intersect(Y, find(YFi < y_max));
                
                %The SIFT in the subimage/bin
                S = double(Si(:, intersect(X, Y)));
                [~, ns] = size(S);
                
                for s = 1:ns
                    d = zeros(1, K);

                    for k = 1:K
                       d(k) = norm(S(:, s) - CCenter(:, k)); 
                    end  

                    [~, c_id] = min(d);
                    Hi(t, c_id) = Hi(t, c_id) + 1;
                end
                
                %Normalize
                Hi(t, :) = Hi(t, :) / ni;
           end
        end
        
        Hist_D = [Hist_D; Hi];
    end

end