function [train_D, train_F, train_gs, test_D, test_F, test_gs] = train_and_test()
    load('input_data.mat');
    
    train_D = cell(1, 800);
    train_F = cell(1, 800);
    train_gs = zeros(1, 800);
    test_D = cell(1, 200);
    test_F = cell(1, 200);
    test_gs = zeros(1, 200);
    
    train_gs(1:400) = 1;
    train_gs(401:800) = 9;
    
    test_gs(1:100) = 1;
    test_gs(101:200) = 9;
    
    %relabel 'non-food' into category 9
    for l = 2:6
       idx = find(label == l);
       label(idx) = 9;
    end
    
    %FOOD
    f_idx = find(label == 1);
    [~, n1] = size(f_idx);
    r = randperm(n1);
    
    for i = 1:500
        
        %400 -> train, 100 -> test
        k = r(i); %1~1213
        
        if i <= 400
           train_D{i} = im_D{f_idx(k)};
           train_F{i} = im_F{f_idx(k)};
        else
           test_D{i - 400} = im_D{f_idx(k)};
           test_F{i - 400} = im_F{f_idx(k)};           
        end 
    end
    
    %NON-FOOD
    nf_idx = find(label == 9);
    [~, n2] = size(nf_idx);
    r = randperm(n2);
    
    for i = 1:500
        
        %150 -> train, 350 -> test
        k = r(i); %
        
        if i <= 400
           train_D{400 + i} = im_D{nf_idx(k)};
           train_F{400 + i} = im_F{nf_idx(k)};
        else
           test_D{100 + i - 400} = im_D{nf_idx(k)};
           test_F{100 + i - 400} = im_F{nf_idx(k)};           
        end 
    end
end