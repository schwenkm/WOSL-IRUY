function IrfanView(varargin)
%IrfanView calls i_view32.exe with the given arguments
%  Syntax:
%     IrfanView(irfan_args)
%  Parameters:
%     irfan_args: a string that is passed to i_view32.exe
%
%  NOTE:
%     i_view32.exe and i_view64.exe is searched on the following paths:
%        'C:\Program Files\IrfanView'
%        'C:\Program Files (x86)\IrfanView'

% (C) Philips - created by Andreas Schlack April 2009

for i=1:nargin
   arg = strrep(varargin{i},'\','/'); % bash expects slashes and no backslashes in arguments
   if ~isempty(dir(arg))
      varargin{i} = arg;
   else
      % options are e.g. /fs for full-screen, etc.
      fprintf('Assuming that arg %d is an option: %s\n', i, varargin{i});
   end
end

i_view_path = {
   'C:\Program Files\IrfanView'
   'C:\Program Files (x86)\IrfanView'
   'D:\BBB (x64)\IrfanView'
   };
i_view_exe = {'i_view32.exe', 'i_view64.exe'};

for exe_idx=1:numel(i_view_exe)
   for path_idx=1:numel(i_view_path)
      fname = fullfile(i_view_path{path_idx},i_view_exe{exe_idx});
      if exist(fname,'file')
         bash('',posixStyle(fname),varargin{:},'&'); % run in background!
         return
      end
   end
end
error('ASK:IrfanView:NotFound', 'i_view32.exe not found on path!');
end
