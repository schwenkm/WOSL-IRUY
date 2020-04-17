function [a_out]=mavr(a_in,n)
%MOVING_AVERAGE calculates the right-bound valid moving average of data.
% Syntax:
%  [a_out]=mavr(a_in,n)
% Parameters:
%  a_in is a matrix, the colums will be filtered, unless one dimesion is 1
%  n  is the width of the boxcarfilter
%     
% Return Values:
%  a_out is the filtered data (only valid values are used).
%  a_out has the same size as a_in, but "right-bound" means, that
%  the first values are repeated n timnes.
%
% Examples:
%  mavr([1 2 3 4 5 6 7 1],4) % only last value is smaller than previous
%
% see also: moving_average, movmean, mav

narginchk(2,2)

if n==1
   a_out = a_in;
   return
end

boxf = ones(1,n)/n;
if size(a_in,1)>1 % do columns have more than 1 value?
   % to use columns as originally planned, a_in must be transposed:
   a_in = a_in';
end
if size(a_in,2)<n % less columns than n?
   a_out = mavr(a_in,n-1);
else
   a_out = conv2(a_in,boxf,'valid');
   a_out = [repmat(a_out(:,1), 1, n-1) a_out];
end

if size(a_in,1)>1 % do columns have more than 1 value?
   % since above a_in was transposed, we now need to transpose a_out:
   a_out = a_out';
end
return

end