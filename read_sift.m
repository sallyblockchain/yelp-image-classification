function [im_D, im_F] = read_sift()
    d_pref = 'sift_data/descriptors_';
    f_pref = 'sift_data/keypoints_';
    posf = '.txt';
    
    im_D = cell(1, 1840);
    im_F = cell(1, 1840);
    
    %1-272 274-1754 1756-1840
    
    for i = 1:1840
        i
        if i == 273 || i == 1755
           continue 
        end
        
        d_name = strcat(strcat(d_pref, int2str(i)), posf);
        f_name = strcat(strcat(f_pref, int2str(i)), posf);
        
        descriptor = uint8(dlmread(d_name));
        descriptor = descriptor';
        
        feature = double(dlmread(f_name));
        feature = feature';
        
        im_D{i} = descriptor;
        im_F{i} = feature;
        
    end
    
end