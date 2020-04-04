function new_string=ntitle(string)
%NTITLE calls title() but the string will not be intperpretable as Tex-String

if isnumeric(string)
   string = sprintf('%g ',string);
else
   string=strrep(string,'\','\\');
   %string=strrep(string,'/','\/');
   string=strrep(string,'_','\_');
end
title(string)

if nargout >= 1
   new_string=string;
end


