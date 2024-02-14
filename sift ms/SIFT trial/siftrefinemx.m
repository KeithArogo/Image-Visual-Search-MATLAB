function refined_keypoints = siftrefinemx(keypoints, dog, smin, threshold, r)
    [M, N, S] = size(dog);
    max_iter = 5;

    refined_keypoints = [];

    for p = 1:size(keypoints, 2)
        %disp(size(keypoints));
        x = keypoints(1, p);
        y = keypoints(2, p);
        s = keypoints(3, p) - smin;
        %disp(x);
        %disp(y);
        %disp(s);
        if x < 1 || x > N-2 || y < 1 || y > M-2 || s < 1 || s > S-2
            %disp('continue');
            continue;
        end

        for iter = 1:max_iter
            disp('in 2nd for loop refine');
            [Dx, Dy, Ds, Dxx, Dyy, Dss, Dxy, Dxs, Dys] = computeGradientsAndHessians(dog, x, y, s);

            % Solve the 3x3 system [Dxx Dxy Dxs; Dxy Dyy Dys; Dxs Dys Dss] * b = -[Dx; Dy; Ds]
            A = [Dxx, Dxy, Dxs; Dxy, Dyy, Dys; Dxs, Dys, Dss];
            b = -[Dx; Dy; Ds];
            b = A\b;

            x = x + b(1);
            y = y + b(2);
            s = s + b(3);

            if abs(b(1)) < 0.6 && abs(b(2)) < 0.6 && abs(b(3)) < 0.6
                break;
            end
        end

        val = dog(y, x, s) + 0.5 * (Dx * b(1) + Dy * b(2) + Ds * b(3));
        score = (Dxx+Dyy)^2 / (Dxx*Dyy - Dxy^2);
        if abs(val) > threshold && score < (r+1)^2/r && score >= 0
            refined_keypoints = [refined_keypoints, [x; y; s + smin]];
            disp('refined keypointsss');
            disp(refined_keypoints);
        end
    end
end

function [Dx, Dy, Ds, Dxx, Dyy, Dss, Dxy, Dxs, Dys] = computeGradientsAndHessians(dog, x, y, s)
    % Computes the gradient and Hessian at a specific point in the DOG scale space.

    % Gradient
    Dx = (dog(y, x+1, s) - dog(y, x-1, s)) / 2;
    Dy = (dog(y+1, x, s) - dog(y-1, x, s)) / 2;
    Ds = (dog(y, x, s+1) - dog(y, x, s-1)) / 2;

    % Hessian
    Dxx = dog(y, x+1, s) - 2*dog(y, x, s) + dog(y, x-1, s);
    Dyy = dog(y+1, x, s) - 2*dog(y, x, s) + dog(y-1, x, s);
    Dss = dog(y, x, s+1) - 2*dog(y, x, s) + dog(y, x, s-1);

    Dxy = (dog(y+1, x+1, s) - dog(y+1, x-1, s) - dog(y-1, x+1, s) + dog(y-1, x-1, s)) / 4;
    Dxs = (dog(y, x+1, s+1) - dog(y, x-1, s+1) - dog(y, x+1, s-1) + dog(y, x-1, s-1)) / 4;
    Dys = (dog(y+1, x, s+1) - dog(y-1, x, s+1) - dog(y+1, x, s-1) + dog(y-1, x, s-1)) / 4;
end

