function q = siftormx(P, G, S, smin, sigma0)
    %disp('siftormax P...');
    %disp(P);
    [M, N, ~] = size(G);
    K = size(P, 2);
    NBINS = 8;
    win_factor = 1.5;
    %disp('siftormax start...');
    disp(K);
    
    % Initialize output
    q = [];

    for p = 1:K
        %disp('in loop');
        x = P(1, p);
        y = P(2, p);
        s = P(3, p);
        sigmaw = win_factor * sigma0 * 2^((s - smin) / S);
        W = floor(3.0 * sigmaw);
    
        H = zeros(1, NBINS); % Histogram initialization
    
        % Loop over a window around the keypoint
        for xs = max(-W, 1 - x) : min(W, N - x)
            for ys = max(-W, 1 - y) : min(W, M - y)
                % Compute gradients
                Dx = G(y + ys, x + xs + 1) - G(y + ys, x + xs - 1);
                Dy = G(y + ys + 1, x + xs) - G(y + ys - 1, x + xs);
        
                % Compute magnitude and orientation
                magnitude = sqrt(Dx^2 + Dy^2);
                orientation = atan2(Dy, Dx);
                orientation = mod(orientation, 2 * pi);
        
                % Determine histogram bin
                bin = floor(orientation / (2 * pi) * NBINS) + 1;
        
                % Apply Gaussian weighting
                dx = x + xs - x;
                dy = y + ys - y;
                distance = sqrt(dx^2 + dy^2);
                weight = exp(-distance^2 / (2 * sigmaw^2));
        
                % Update histogram
                H(bin) = H(bin) + magnitude * weight;
                %disp('Hist');
                %disp(H(bin));
            end
        end
    
        % Smooth the histogram
        H = smoothHistogram(H);

    % ... (Rest of the loop, finding peaks)
        % Find peaks in the histogram
        peaks = findPeaksInHistogram(H, max(H) * 0.8);

    % Process each peak to compute the keypoint orientation
        for i = 1:length(peaks)
            peak = peaks(i);
            % ... Compute keypoint orientation based on peak ...
            % Add the keypoint to the output array q
            q = [q, [x; y; s; peak.orientation]];
            %disp('peaks');
            %disp(q);
        end
    end

function H = smoothHistogram(H)
    for iter = 1:6
        H = conv(H, [1/3, 1/3, 1/3], 'same');
    end
end

function peaks = findPeaksInHistogram(H, threshold)
    % Assuming H is the orientation histogram array of length NBINS
    peaks = []; % To store the peaks with their interpolated orientation
    
    for i = 1:NBINS
        left = H(mod(i-2-1, NBINS) + 1); % Wrap around the histogram
        center = H(i);
        right = H(mod(i, NBINS) + 1);
    
        % Check if the center bin is a peak and exceeds the threshold
        if center > left && center > right && center > threshold
            % Quadratic interpolation
            % Formula: interpolated_peak = i + 0.5 * (left - right) / (left - 2*center + right)
            interp_peak = i + 0.5 * (left - right) / (left - 2*center + right);
            peak_orientation = 2*pi * interp_peak / NBINS; % Convert bin number to angle
    
            % Store the peak value and its orientation
            peaks = [peaks, struct('value', center, 'orientation', peak_orientation)];
        end
    end
end


end
