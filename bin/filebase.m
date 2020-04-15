function new_string=filebase(char_arr)
%FILEBASE returns the filename without the path
%see also fileparts

char_arr=char(char_arr); % in case char_arr was a string like "C:\a\b.c"
n=max([strfind(char_arr, '/') strfind(char_arr, '\')]);

if isempty(n)
   n=0;
end

char_arr = char_arr((n+1):end);

if nargout >= 1
   new_string=char_arr;
else
   disp(char_arr)
end


