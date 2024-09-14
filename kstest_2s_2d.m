function [H, pValue, KSstatistic] = kstest_2s_2d(x1, x2, alpha)
  %%
  if nargin < 2
   error('stats:kstest2:TooFewInputs','At least 2 inputs are required.');
  end
  %%
  %
  % x1,x2 are both 2-column matrices
  %
  if ((size(x1,2)~=2)||(size(x2,2)~=2))
   error('stats:kstest2:TwoColumnMatrixRequired','The samples X1 and X2 must be two-column matrices.');
  end
  n1 = size(x1,1);
  n2 = size(x2,1);
  %%
  %
  % Ensure the significance level, ALPHA, is a scalar
  % between 0 and 1 and set default if necessary.
  %
  if (nargin >= 3) && ~isempty(alpha)
   if ~isscalar(alpha) || (alpha <= 0 || alpha >= 1)
   error('stats:kstest2:BadAlpha',...
   'Significance level ALPHA must be a scalar between 0 and 1.');
   end
  else
   alpha = 0.05;
  end
  %%
  %
  % - A function handle to perform comparisons in all possible directions
  fhCounts = @(x, edge)([(x(:, 1) > edge(1)) & (x(:, 2) > edge(2))...
   (x(:, 1) <= edge(1)) & (x(:, 2) > edge(2))...
   (x(:, 1) <= edge(1)) & (x(:, 2) <= edge(2))...
   (x(:, 1) > edge(1)) & (x(:, 2) <= edge(2))]);
  KSstatistic = -inf;
  fprintf('Measuring [%6.2f%%]...', 0);
  for iX = 1:(n1+n2)
   % - Choose a starting point
   if (iX<=n1)
   edge = x1(iX,:);
   else
   edge = x2(iX-n1,:);
   end
  
   % - Estimate the CDFs for both distributions around this point
   vfCDF1 = sum(fhCounts(x1, edge)) ./ n1;
   vfCDF2 = sum(fhCounts(x2, edge)) ./ n2;
   % - Two-tailed test statistic
   vfThisKSTS = abs(vfCDF1 - vfCDF2);
   fKSTS = max(vfThisKSTS);
  
   % - Final test statistic is the maximum absolute difference in CDFs
   if (fKSTS > KSstatistic)
   KSstatistic = fKSTS;
   end
  
   if (mod(iX, 1000) == 0)
   fprintf('\b\b\b\b\b\b\b\b\b\b\b%6.2f%%]...', iX / (n1+n2)*100);
   end
  end
  fprintf('\n');
  %% Peacock Z calculation and P estimation
  n = n1 * n2 /(n1 + n2);
  Zn = sqrt(n) * KSstatistic;
  Zinf = Zn / (1 - 0.53 * n^(-0.9));
  pValue = 2 * exp(-2 * (Zinf - 0.5).^2);
  % Clip invalid values for P
  if (pValue > 1)
   pValue = 1;
  end
  H = (pValue <= alpha);