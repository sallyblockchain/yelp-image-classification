function confusion_matrix = color_histogram()
    load('class_data.mat');
    load('consolidated_data.mat');
    
    num_training_examples = 800;
    num_testing_examples  = 200;
    num_pyramid_level = 3;  % for this MP
    
    food_examples = find(label == 1);
    non_food_examples = find(label ~= 1);
    
    label = label + 1;
    
    training_examples = [food_examples(1:400) non_food_examples(1:400)];
    testing_examples = [food_examples(401:500) non_food_examples(401:500)];
    
%     test_gs = zeros(1, 200);
%     for i = 1:200
%         if label(testing_examples(i)) == 1
%             test_gs(i) = 1;
%         else
%             test_gs(i) = 9;
%         end
%     end
    
    all_histograms_train = cell(num_training_examples, num_pyramid_level);
    all_histograms_test  = cell(num_testing_examples,  num_pyramid_level);

    for i = 1:num_training_examples
        im = imread(strcat('images/', int2str(training_examples(i)), '.jpg'));
        all_histograms_train{i, 1} = get_gridded_histograms(im, 0, 16);
        all_histograms_train{i, 2} = get_gridded_histograms(im, 1, 16);
        all_histograms_train{i, 3} = get_gridded_histograms(im, 2, 16);
    end
    
    for i = 1:num_testing_examples
        im = imread(strcat('images/', int2str(testing_examples(i)), '.jpg'));
        all_histograms_test{i, 1} = get_gridded_histograms(im, 0, 16);
        all_histograms_test{i, 2} = get_gridded_histograms(im, 1, 16);
        all_histograms_test{i, 3} = get_gridded_histograms(im, 2, 16);
    end    

    fprintf('finished building histograms.\n');

    guess(num_testing_examples, 1) = 0;  % label given by the classifier
    
    for test_im_index = 1:num_testing_examples
        match_scores(num_training_examples, 1) = 0;  % histogram intersection score
        
        for train_im_index = 1:num_training_examples
            level_0_score = ...
                get_match_score(all_histograms_train{train_im_index, 1}, ...
                                all_histograms_test{test_im_index, 1});
            level_1_score = ...
                get_match_score(all_histograms_train{train_im_index, 2}, ...
                                all_histograms_test{test_im_index, 2});
            level_2_score = ...
                get_match_score(all_histograms_train{train_im_index, 3}, ...
                                all_histograms_test{test_im_index, 3});
            match_scores(train_im_index) = ...
                0.25 * level_0_score + 0.25 * level_1_score + 0.5 * level_2_score;
        end
        
%         [~, best_match] = max(match_scores);
%         guess(test_im_index) = train_gs(best_match);
          [~, best_matches] = sort(match_scores', 2, 'descend');
          top_five = best_matches(1:5);
%           match_scores
%           top_five
%           train_gs(top_five)
%           mode(train_gs(top_five))
          guess(test_im_index) = mode(label(training_examples(top_five)));
    end
    
    % stats
    num_categories = 9;
    confusion_matrix(num_categories, num_categories) = 0;
    
    for real = 1:num_categories
        im_indexes = find(label(testing_examples) == real);
        for j = im_indexes
           pred = guess(j);  % prediction
           confusion_matrix(real, pred) = confusion_matrix(real, pred) + 1;
        end
    end
    
    imagesc(confusion_matrix), colorbar;
    accuracy = trace(confusion_matrix) / num_testing_examples   % display result in console
end

function match_score = get_match_score(gridded_hist_1, gridded_hist_2)
    [h, w] = size(gridded_hist_1);  % assuming size(hist_1) == size(hist_2)
    total = 0;
    for i = 1:h
        for j = 1:w
            hist_1 = gridded_hist_1{i, j};
            hist_2 = gridded_hist_2{i, j};
            for k = 1:3
                hist_intersection = min(hist_1(k, :), hist_2(k, :));
                score = sum(hist_intersection);
                total = total + score;
            end
        end
    end
    match_score = total;
    % match_score = total / (h * w);  % shouldn't it?
end

function histograms = get_gridded_histograms(im, grid_level, num_bins)
    
    h = 250;
    w = 250;
    
    N = 2 ^ grid_level;  % N = number of cells along each dimension
    
    histograms = cell(N, N);
    cell_bounds = round(linspace(1, w, N+1));  % symmetric for all directions
    
    for i = 1:N
        rows = cell_bounds(i):cell_bounds(i+1);
        for j = 1:N
            cols = cell_bounds(j):cell_bounds(j+1);
            
            [hist_r, hist_g, hist_b] = get_histogram(im(rows, cols, :), num_bins);
            histograms{i, j} = [hist_r; hist_g; hist_b];
        end
    end

end

function [hist_r, hist_g, hist_b] = get_histogram(im, num_bins)
    [h, w, ~] = size(im);
    num_pixels = h * w;
    
    % bin centers
    bounds = linspace(0, 255, num_bins+1);
    bin_width = bounds(2) - bounds(1);
    bin_centers = bounds(1:num_bins) + 0.5 * bin_width;
    
    % hist works better on vectors; flatten each channel
    im_flat = reshape(im, [num_pixels, 1, 3]);
    
    hist_r = hist(im_flat(:, :, 1), bin_centers) / num_pixels;
    hist_g = hist(im_flat(:, :, 2), bin_centers) / num_pixels;
    hist_b = hist(im_flat(:, :, 3), bin_centers) / num_pixels;
end

