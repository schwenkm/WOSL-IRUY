function posix_path=posixStyle(dos_path)
%PosixStyle converts a DOS-style path-name into a posix-style path name
%
% Syntax:
%  posix_path=posixStyle(dos_path)
%
% Parameters:
%  dos_path       a DOS-style path-name, e.g. C:\Temp
%
% Return Values:
%  posix_path     a POSIX-style path-name, e.g. /cygdrive/c/Temp
%
% Notes:
%  replaces all paths in the given string, even if they only remotely
%  look like a path name, in fact all
%     '\'            are replaced by '/', and all
%     'X:\' or 'X:/' are replaced by '/cygdrive/X/'
%  where X can be any character
%
% See also:
%  http://cygwin.com/cygwin-ug-net/using.html#using-pathnames

% (C) Philips, by Andreas Schlack July 2010

narginchk(1,1); % ==> Not enough input arguments.

posix_path=strrep(dos_path,'\','/');
ii=strfind(posix_path,':/');
for i=sort(ii,'descend')
   if i>1
      posix_path = [posix_path(1:(i-2)) '/cygdrive/' posix_path(i-1) posix_path((i+1):end)];
   end
end
return
end
