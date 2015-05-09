function confusion_matrix = classifier_bow(K)
    %K number of clusters: 100
    load('class_data.mat');
    load('consolidated_data.mat');

    %Construct visual words using k-mean on SIFT descriptors
    fprintf('Computing visual words ...\n');
    
    %Get ~10,000 SIFT from Training image: 6 from each image
    SD = [];
    
    food_examples = find(label == 1);
    non_food_examples = find(label > 2);
    
    label = label + 1;
    
    training_examples = [food_examples(1:400) non_food_examples(1:400)];
    testing_examples = [food_examples(401:456) non_food_examples(401:456)];
    
    train_D = im_D(training_examples);
    train_F = im_F(training_examples);
    test_D = im_D(testing_examples);
    test_F = im_F(testing_examples);
    
    for i = 1:800
        [~, ns] = size(train_D{i});
        
        %6 random idx of SIFT
        s_idx = randi([1 ns], 1, 6);
        
        SD = [SD train_D{i}(:, s_idx)];
    end
    SD = double(SD);
    
    %K-mean
    [~, n] = size(SD);
    
    %Intial centers
    s_idx = randi([1 n], 1, K);
    CCenter = SD(:, s_idx);
    A = zeros(1, n);
    
    while true
        %assign each SIFT to nearst center
        A_new = zeros(1, n);
        
        for i = 1:n
            %distance to each cluster center
            d = zeros(1, K);
            
            for k = 1:K
               d(k) = norm(SD(:, i) - CCenter(:, k)); 
            end
            
            [~, c_id] = min(d);
            A_new(i) = c_id;
        end
        
        %Convergence
        if all(A_new == A)
           break; 
        end
        
        %Update clucter centers
        for k = 1:K
            s_idx = find(A_new == k);
            CCenter(:, k) = mean(SD(:, s_idx), 2);
        end
        
        A = A_new;
    end
    
    %Construct visual word histogram for Training and Test images

    fprintf('Constructing histogram for Training and Test images ...\n');    
    [Hist_T_0, Hist_D_0] = bow_histogram(CCenter, 0, train_D, train_F, test_D, test_F);
	[Hist_T_1, Hist_D_1] = bow_histogram(CCenter, 1, train_D, train_F, test_D, test_F);
	[Hist_T_2, Hist_D_2] = bow_histogram(CCenter, 2, train_D, train_F, test_D, test_F);
    
    %Classification
    fprintf('Classifying Test images ...\n');
    C = zeros(1, 200);
    
    for i = 1:200
        %Score for each training image w.r.t test image i.
        S = zeros(1, 800);
        for j = 1:800
            %Histogram Intersection

            %Level 0
            s0 = 0.0;
            w0 = 1/4;
            
            for k = 1:K
                s0 = s0 + min(Hist_D_0(i, k), Hist_T_0(j, k));
            end
            
            s0 = s0 * w0;
           
            %Level 1
            s1 = 0.0;
            w1 = 1/4;
            
            for b = 1:4
                for k = 1:K
                    s1 = s1 + min(Hist_D_1((i - 1)*4 + b, k), Hist_T_1((j - 1)*4 + b, k));
                end
            end
            
            s1 = s1 * w1;

           
            %Level 2
            s2 = 0.0;
            w2 = 1/2;
            
            for b = 1:16
                for k = 1:K
                    s2 = s2 + min(Hist_D_2((i - 1)*16 + b, k), Hist_T_2((j - 1)*16 + b, k));
                end
            end
           
            s2 = s2 * w2;
       
            S(j) = s0 + s1 + s2;
        end
        
        [~, idx] = max(S);
        %Assign category to the same as training image with largest score
        C(i) = label(training_examples(idx));
    end
    
    %Statistics
    Confusion = zeros(9, 9);
    
    for i = 1:9
        %find idx of test images with category = i
        idx = find(label(testing_examples) == i);

        
        for k = idx
           %get the predicted category of the image
           c = C(k);
           Confusion(i, c) = Confusion(i, c) + 1;
        end
    end
    
    imagesc(Confusion), colorbar;
    accuracy = trace(Confusion) / 200    
    
    confusion_matrix = Confusion;
end