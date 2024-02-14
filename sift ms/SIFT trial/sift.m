function [frames,descriptors,gss,dogss]=sift(I,varargin)

if(nargin < 1)
  error('At least one argument is required.') ;
end

[M,N,C] = size(I) ;

% Lowe's equivalents choices
S      =  3 ;
omin   = -1 ;
O      = floor(log2(min(M,N)))-omin-3 ; % up to 8x8 images
sigma0 = 1.6*2^(1/S) ;                  % smooth lev. -1 at 1.6
sigman = 0.5 ;
thresh = 0.04 / S / 2 ;
r      = 10 ;
NBP    = 4 ;%4
NBO    = 8 ;
magnif = 3.0 ;

% Parese input
compute_descriptor = 0 ;
discard_boundary_points = 1 ;
verb = 0 ;

for k=1:2:length(varargin)
  switch lower(varargin{k})

    case 'numoctaves'
      O = varargin{k+1} ;

    case 'firstoctave'
      omin = varargin{k+1} ;

    case 'numlevels'
      S = varargin{k+1} ;

    case 'sigma0'
      sigma0 = varargin{k+1} ;

    case 'sigman'
      sigmaN = varargin{k+1} ;

    case 'threshold'
      thresh = varargin{k+1} ;

    case 'edgethreshold'
      r = varargin{k+1} ;

    case 'boundarypoint'
     discard_boundary_points = varargin{k+1} ;

    case 'numspatialbins'
      NBP = varargin{k+1} ;

    case 'numorientbins'
      NBO = varargin{k+1} ;

    case 'magnif'
      magnif = varargin{k+1} ;

    case 'verbosity'
     verb = varargin{k+1} ;

    otherwise
      error(['Unknown parameter ''' varargin{k} '''.']) ;
  end
end

% Arguments sanity check
if C > 1
  error('I should be a grayscale image') ;
end

frames      = [] ;
descriptors = [] ;

% --------------------------------------------------------------------
%                                         SIFT Detector and Descriptor
% --------------------------------------------------------------------

% Compute scale spaces
if verb>0, fprintf('SIFT: computing scale space...') ; tic ; end

gss = gaussianss(I,sigman,O,S,omin,-1,S+1,sigma0) ;

if verb>0, fprintf('(%.3f s gss; ',toc) ; tic ; end

dogss = diffss(gss) ;

if verb > 0, fprintf('%.3f s dogss) done\n',toc) ; end
if verb > 0
  fprintf('SIFT scale space parameters [PropertyName in brackets]\n');
  fprintf('  sigman [SigmaN]        : %f\n', sigman) ;
  fprintf('  sigma0 [Sigma0]        : %f\n', dogss.sigma0) ;
  fprintf('       O [NumOctaves]    : %d\n', dogss.O) ;
  fprintf('       S [NumLevels]     : %d\n', dogss.S) ;
  fprintf('    omin [FirstOctave]   : %d\n', dogss.omin) ;
  fprintf('    smin                 : %d\n', dogss.smin) ;
  fprintf('    smax                 : %d\n', dogss.smax) ;
  fprintf('SIFT detector parameters\n')
  fprintf('  thersh [Threshold]     : %e\n', thresh) ;
  fprintf('       r [EdgeThreshold] : %.3f\n', r) ;
  fprintf('SIFT descriptor parameters\n')
  fprintf('  magnif [Magnif]        : %.3f\n', magnif) ;
  fprintf('     NBP [NumSpatialBins]: %d\n', NBP) ;
  fprintf('     NBO [NumOrientBins] : %d\n', NBO) ;
end

for o=1:gss.O
  if verb > 0
    fprintf('SIFT: processing octave %d\n', o-1+omin) ;
    tic ;
  end

  % Local maxima of the DOG octave
  %octave_size  = size(dogss.octave{o});
  %fprintf('octave size is  %d\n', octave_size); 
  
  % Calculate local maxima
  idx = siftlocalmax(dogss.octave{o}, 0.8*thresh);
  % Ensure idx is a column vector
  idx = idx(:);
  disp(size(idx));
  
  conc = siftlocalmax(-dogss.octave{o}, 0.8*thresh);
  % Ensure conc is a column vector
  conc = conc(:);
  disp(size(conc));
  
  % Concatenate idx and conc
  idx = [idx ; conc];  % Use semicolon for vertical concatenation
  %disp(size(idx));
  [i, j, s] = ind2sub(size(dogss.octave{o}), idx);
  for k = 1:min(length(idx), 10) % Print details for the first 10 keypoints
    fprintf('idx: %d, Subscripts - x: %d, y: %d, scale: %d\n', idx(k), j(k)-1, i(k)-1, s(k)-1+dogss.smin);
  end


  %disp('Concatenate idx and conc:');
  %disp(idx(:, 1:min(end, 5)));
  % Convert linear indices to subscripts
  [i,j,s] = ind2sub( size( dogss.octave{o} ), idx ) ;
  y=i-1 ;
  x=j-1 ;
  s=s-1+dogss.smin ;
  oframes = [x(:)';y(:)';s(:)'] ;
  %disp(oframes);
  %disp('Keypoints after Convert linear indices to subscripts:');
  %disp(oframes(:, 1:min(end, 5)));

  if verb > 0
    fprintf('SIFT: %d initial points (%.3f s)\n', ...
      size(oframes, 2), toc) ;
    tic ;
  end

  % Remove points too close to the boundary
    % Remove points too close to the boundary
  if discard_boundary_points
    % Calculate radius for discarding points
    rad = magnif * gss.sigma0 * 2.^(oframes(3,:)/gss.S) * NBP / 2 ;
    sel = ...
      oframes(1,:)-rad >= 1                     & ...
      oframes(1,:)+rad <= size(gss.octave{o},2) & ...
      oframes(2,:)-rad >= 1                     & ...
      oframes(2,:)+rad <= size(gss.octave{o},1) ;
    oframes = oframes(:,sel) ;

    
    
    if verb > 0
      fprintf('SIFT: %d away from boundary\n', size(oframes,2)) ;
    end
  end
  %disp(size(oframes,2));

  % Displaying first 5 keypoints
  % Refine the location, threshold strength and remove points on edges
  %oframes = siftrefinemx(...
    %oframes, ...
    %dogss.octave{o}, ...
    %dogss.smin, ...
    %thresh, ...
    %r) ;
  %oframes = siftrefinemx(oframes, dogss.octave{o},  dogss.smin, thresh,r);
  %disp(oframes);
  %if verb > 0
    %fprintf('SIFT: %d refined (%.3f s)\n', ...
            %size(oframes,2), toc) ;
    %tic ;
  %end

  % Compute the orientations
  oframes = siftormx(oframes, gss.octave{o}, gss.S, gss.smin, gss.sigma0);
 
  % Store frames
  x     = 2^(o-1+gss.omin) * oframes(1,:) ;
  y     = 2^(o-1+gss.omin) * oframes(2,:) ;
  sigma = 2^(o-1+gss.omin) * gss.sigma0 * 2.^(oframes(3,:)/gss.S) ;
  frames = [frames, [x(:)' ; y(:)' ; sigma(:)' ; oframes(4,:)] ] ;

  %disp(x);
  %disp(y);
  %disp(sigma);
  %disp(frames);
  % Descriptors (only if requested)
  if nargout > 1
    if verb > 0
      fprintf('SIFT: computing descriptors...') ;
      tic ;
    end

    descriptors = siftdescriptor(...
      gss.octave{o}, ...
      oframes, ...
      gss.sigma0, ...
      gss.S, ...
      gss.smin, ...
      'Magnif', magnif, ...
      'NumSpatialBins', NBP, ...
      'NumOrientBins', NBO) ;
    
    if verb > 0, fprintf('done (%.3f s)\n', toc) ; end
  end
end

% [Rest of your function]

end
