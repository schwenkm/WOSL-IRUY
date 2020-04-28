function [ret_val_out,std_out,err_out]=bash(cmd, varargin)
%bash calls the bash.exe, e.g. from a cygwin installation
% Syntax:
%  [ret_val,out,err]=bash(cmd,...)
%  [ret_val,out,err]=bash(['-v',]['-v',]['-q',]['-q',]['-d',]cmd,...)
%  [ret_val,out,err]=bash(...,'-ssh',user@host,cmd,...)
%  bash --verify-installation
% Parameters:
%  cmd  must be a command, or a series of commands (separated with
%       semicolons), which must be available in bash.
%       NOTE1: bash.exe is an executable which must be installed beforehand,
%              preferrably in a cygwin installation.
%       NOTE2: cmd will never be put in quotes as opposed to all other
%              parameters. Therefore if cmd contains a path which contains
%              spaces, preceed cmd with '' (an empty string).
%  all parameters following cmd will be passed on to the command, as parameters.
%       NOTE1: Any additional arguments that contain spaces or backslashes
%              will be put in quotes (this is not done in the 'first', the
%              cmd argument).
%              Therefore e.g. the outputs of these four commands,
%                   bash 'echo -n a    b .;    echo  c   d'
%                   bash 'echo -n a    b .' ';'echo  c   d
%                   bash echo -n  a    b .  ';'echo  c   d
%                   bash -d echo -n a  b . $   echo  c   d
%              are equal, but the output of this command is different:
%                   bash echo -n 'a    b .' ';'echo 'c   d'
%       NOTE2: As in the above example if you call bash using Matlab's
%              command syntax, note that you need to put the semicolon in
%              quotes yourself, or use the -d option.
% Special Optional Parameters:
%  -v       If the command is preceeded by the string '-v', the verbose
%           mode is activated., i.e. more details of what this function
%           does are printed. This option may be applied twice to increase
%           verbocity even more. 
%  -q       If the command is preceeded by the string '-q', the quiet mode
%           is activated., i.e. stdout is ignored (i.e. not shown).
%           If this option is applied twice, also the stderr is ignored.
%  -d       If the command is preceeded by the string '-d', the the string
%           " $ " can be used to separate several bash commands in one call
%           to bash, e.g. 
%               bash -d echo -n a  b . $ whoami
%           (The delimiter ' $ ' will be replaced by ';')
%  -ssh     If the command is preceeded by the string '-ssh' (which must be
%           immediately followed by a user@host argument, the command is
%           executed on the specified host, using an ssh shell on the same
%           path as the bash command (this is to avoid using
%           C:\windows\System32\OpenSSH\ssh.exe, which doesn't always work)
%  --verify-installation      If the one and only parameter is
%           '--verify-installation', this function will only verify the
%           installation of bash, ctags, nc and other tools that are needed
%           by one or the other matlab script. If you need other tools feel
%           free to extend this list. If any of the needed tools is not
%           available there will only be one warning. 
%
% Output Parameters:
%  out          contains the text of the output of the bash command
%               if not given, the bash command will send its output to
%               stdout directly
%
% Examples:
%  bash('echo', 'date  = $(date)')
%  bash -d for i in $(seq 74) $ do echo -n '.' $ sleep 0.01 $ done $ echo done;
%  rv=bash('for i in $(seq 74) ; do echo -n ''.'' ; sleep 0.01 ; done ; echo done')
%  [rv,txt]=bash('ls /bin/bas* /bad/file/which_does_not_exist')
%
% (C) Philips 2018, written by Andreas Schlack

persistent cygwin_bash_path pa_ssh

if isempty(cygwin_bash_path)
   cygpath_path=evalc('!which cygpath');
   cygpath_path=strtrim(cygpath_path);
   if ~isequal(cygpath_path, '/usr/bin/cygpath')
      if exist('C:\cygwin64\bin\bash.exe','file')
         warning('Please Add "C:\cygwin64\bin\" to your WINDOWS PATH environment variable (done).');
         setenv('PATH', ['C:\cygwin64\bin\;' getenv('PATH')]);
      elseif exist('C:\cygwin\bin\bash.exe','file')
         warning('Please Add "C:\cygwin\bin\" to your WINDOWS PATH environment variable (done).');
         setenv('PATH', ['C:\cygwin\bin\;' getenv('PATH')]);
      else
         warning('Please Install Cygwin first');
      end
   else
      cygwin_bash_path=evalc('!cygpath -w /usr/bin/bash');
      cygwin_bash_path=strtrim(cygwin_bash_path);
      assert(contains(cygwin_bash_path,'bash.exe'));
      cygwin_bash_path=strrep(cygwin_bash_path,'bash.exe','');
      assert(cygwin_bash_path(end) == '\');
   end
end

if nargin==1 && isequal(cmd,'--verify-installation')
   t0=tic;
   %bash_path=evalc('!which bash'); % NOTE: returns '/usr/bin/bash' only if cygwin's bash is on path before any other bash!
   bash_path=evalc('!which /usr/bin/bash'); % NOTE: returns '/usr/bin/bash' also if other bash is on path first!
   t1=toc(t0); t2=tic;
   if t1>3 % on my laptop this takes 37 .. 54 seconds in the first call, why?? 
      warning('I don''t know why, but the command "!which bash" took %.0f seconds, this is too long! Trying again:', t1);
      strtrim(evalc('!which /usr/bin/bash')), toc(t2) % this still takes up to 0.2 .. 8.9 seconds!
      % please add a hint here if you find a solution to this problem.
      % NOTE1: For Andreas, reinstalling cygwin from scratch made a speed-up from 40 to 37 seconds.
      % NOTE2: For Andreas, following https://superuser.com/questions/890249/cygwins-mintty-takes-about-a-minute-to-start-up did not help.     
   else
      fprintf('OK, bash is installed in %s, this check took %.2f seconds\n', strtrim(bash_path), t1);
   end
   bash_path=strtrim(bash_path);
   if ~isequal(bash_path, '/usr/bin/bash')
      warning('Please Install Cygwin first');
   end
   lw1=lastwarn;
   old_state=warning('off','ASK:BASH:VerifyFailed');
   V('/usr/bin/bash', mfilename)
   V('ctags', 'makeMexSpO2Algo')
   V('nc',    'get3DRec')
   V('ssh',   'get3DRec (only for remote_host modus)', {'/windows/System32/OpenSSH/ssh'})
   [~,b]=bash('-q','which','ssh');
   if ~isequal(b, '/usr/bin/ssh')
      warning('NOTE: ssh should be part of the cygwin installation. Other ssh programs might not work for get3DRec and get3Dand2DRec');
      V('ssh',   'get3DRec (only for remote_host modus)') % warn if /windows/System32/OpenSSH/ssh is used because it might not work
   end
   V('git',   'NOTE: only recommended!')
   V('tig',   'NOTE: only recommended!')
   V('xxd',   'NOTE: only recommended!')
   V('curl',  'NOTE: only recommended!', {'/cygdrive/c/windows/system32/curl'})
   % You might also want to install these cygwin packages:
   %  inetutils (for ftp, telnet, ...)
   warning(old_state)
   lw2=lastwarn;
   if ~isequal(lw1,lw2)
      warning('Please check your Cygwin installation, you might need some of the above mentioned tools.')
   end
   if toc(t0)>3
      t3=toc(t2);
      fprintf('Total time needed for verification is: %.1f + %.1f = %.1f seconds\n', t1, t3, t1+t3)
   end
else
   %% Check option-arguments:
   verbose=0;
   opt_quiet=0;
   opt_mult_cmd=0;
   opt_ssh=0;
   while true
      switch(cmd)
         case '-v' % may be applied more than once for even more verbosity
            verbose=verbose+1;
         case '-q'
            opt_quiet=opt_quiet+1;
         case '-d' % set $ as delimiter, note: you can  use ' ; ' without this option.
            opt_mult_cmd=1;
         case '-ssh'
            opt_ssh = 1;
            ssh_host = varargin{1};
            varargin=varargin(2:end);
         otherwise
            break
      end
      cmd = varargin{1};
      varargin=varargin(2:end);
   end
   % V(cmd,'caller') % does not work if cmd starts with e.g. 'for '.
   %% create command-string:
   if ~opt_ssh
      full_cmd=[cygwin_bash_path 'bash -c "(PATH=/usr/bin/:$PATH ']; % add double quotes around the command+args, here: opening quote
   else
      if isempty(pa_ssh)
         %%
         [rv_ba,pa_bash]=bash('-q','which','bash');   % == path to bash
         assert(rv_ba==0)
         pa_ssh_u = strrep(pa_bash,'bash','ssh'); % == path to ssh on unix
         [rv_ssh,pa_ssh]=bash('-q','cygpath','-w', pa_ssh_u); % == path to bash on windows
      end
      full_cmd=[pa_ssh ' ' ssh_host ' "(']; % add double quotes around the command+args, here: opening quote
   end
   if verbose > 1
      full_cmd=[full_cmd 'echo stdout:>&1; echo stderr:>&2;']; % force some output to stdout and stderr
   end
   % NOTE: the previous line was needed, because otherwise the files
   %       *.bash_stdout and *.bash_stderr might not be created, unfortunately!
   if contains(cmd,'"') && ~contains(cmd,'\"')
      cmd = strrep(cmd,'"','\"');    % escape double quotes with a preceeding escaped backslash 
      % NOTE: since cmd is not put into double quotes, a single backslash is sufficient
   end
   full_cmd=[full_cmd   cmd]; % add the command itself
   for i=1:numel(varargin)
      arg = varargin{i};
      if isnumeric(arg)
         arg=num2str(arg);
      end
      arg=strrep(arg,'"','\\\"');    % escape double quotes with a preceeding escaped backslash 
      % NOTE: since cmd is put into double quotes, the backslash must be escaped itself as well
      if (contains(arg,' ') || contains(arg,'\'))&& ~any(strfind(arg,'$(')==1)
         arg=['\"' arg '\"'];        %#ok<AGROW> % add (escaped) double-quotes around the arg
      end
      if opt_mult_cmd && isequal(arg, '$')
         arg=';';
      end
      full_cmd = [full_cmd ' ' arg]; %#ok<AGROW> % add a space
   end
   cmd_end = ')"';     % add double quotes around the command+args, here: closing quote
   if verbose
      fprintf('Calling: cmd=%s%s\n', full_cmd, cmd_end);
   end
   if (nargout<=1) && opt_quiet==0
      ret_val = system([full_cmd cmd_end]);
   elseif (nargout<=1) && opt_quiet==1
      ret_val = system([full_cmd cmd_end(1) ' > /dev/null' cmd_end(2:end)]);
   elseif (nargout<=1) && opt_quiet>1
      ret_val = system([full_cmd cmd_end(1) ' &> /dev/null' cmd_end(2:end)]);
   else
      f0=[tempname '.bash_ret_val'];
      f0c=RemoveLastEndline(evalc(['!cygpath -u ' f0]));
      f1=[tempname '.bash_stdout'];
      f1c=RemoveLastEndline(evalc(['!cygpath -u ' f1]));
      f2=[tempname '.bash_stderr'];
      f2c=RemoveLastEndline(evalc(['!cygpath -u ' f2]));
      if opt_ssh
         f0w=f0c; f0c=['/tmp/bash_f0c.' num2str(mexPid)];
         f1w=f1c; f1c=['/tmp/bash_f1c.' num2str(mexPid)];
         f2w=f2c; f2c=['/tmp/bash_f2c.' num2str(mexPid)];
      end
      if 1
         %!rm qwe0 qwe1 qwe2
         %tic; eval('!bash -c "(ls /bin/bash bad_cmd; echo $?>qwe0) 1> >(tee qwe1) 2> >(tee qwe2 >&2)"'); toc
         %!grep . qwe[012]
         %tic; qwe0=system('bash -c "(ls /bin/bash bad_cmd) 1> >(tee qwe1) 2> >(tee qwe2 >&2)"'); toc
         %NOTE: the eval version was faster than using system, so it is used.
         
         tee1='tee '; % use this to print "stdout:"
         tee2='tee '; % use this to print "stderr:"
         to_err = ' >&2';
         if opt_quiet
            tee1 = 'cat > ';
         end
         if opt_quiet>1
            tee2 = 'cat > ';
            to_err = [];
         else
         end
         eval(['!' full_cmd '; echo $?>' f0c cmd_end(1) ' 1> >(' tee1 f1c ') 2> >(' tee2 f2c to_err ')' cmd_end(2:end)]);
      end
      if opt_ssh
         rv_cp = NaN(1,3); rv_rm = rv_cp;
         rv_cp(1)=bash('-q','PATH=/usr/bin/:$PATH rsync ', [ssh_host ':' f0c], f0w);
         rv_cp(2)=bash('-q','PATH=/usr/bin/:$PATH rsync ', [ssh_host ':' f1c], f1w);
         rv_cp(3)=bash('-q','PATH=/usr/bin/:$PATH rsync ', [ssh_host ':' f2c], f2w);
         rv_rm(1)=bash('-q','-ssh', ssh_host, 'rm', f0c);
         rv_rm(2)=bash('-q','-ssh', ssh_host, 'rm', f1c);
         rv_rm(3)=bash('-q','-ssh', ssh_host, 'rm', f2c);
         assert(all([rv_cp rv_rm] == 0))
      end
      fid=fopen(f0); if fid~=-1; ret_val=char(fread(fid,'char')'); fclose (fid); delete(f0); else ret_val=char([]); end %#ok<SEPEX>
      fid=fopen(f1); if fid~=-1; std_out=char(fread(fid,'char')'); fclose (fid); delete(f1); else std_out=char([]); end %#ok<SEPEX>
      fid=fopen(f2); if fid~=-1; err_out=char(fread(fid,'char')'); fclose (fid); delete(f2); else err_out=char([]); end %#ok<SEPEX>
      ret_val = str2double(ret_val);
      if verbose>2
         assert(isequal(std_out(1:8), ['stdout:' 10])); std_out=std_out(9:end);
         assert(isequal(err_out(1:8), ['stderr:' 10])); err_out=err_out(9:end);
      end
      std_out = RemoveLastEndline(std_out);
      err_out = RemoveLastEndline(err_out);
      if opt_quiet && verbose
         fprintf('stdout: %s\n', std_out);
      end
      if ~isempty(err_out) && ((nargout < 3) || verbose)
         warning('stderr: %s', err_out)
      end
   end
   if (ret_val~=0) && (nargout < 1)
      warning('retval: %d', ret_val)
   elseif nargout>=1
      ret_val_out=ret_val;
   end
end
return
end

function V(cmd, user, alternate)
%V Verify that a command is installed (preferably in cygwin at /usr/bin/)
% Syntax:
%  V(cmd, user, alternate)
% Parameters:
%  cmd          a (unix) command which is needed.
%  user         the (matlab) command which uses 'cmd'.
%  alternate    a cell-array of alternat installation directories,
%               otherwise 'cmd' is expected to be installed in /usr/bin/.
if nargin<3; alternate=[]; end
p=strtrim(evalc(['!which ' cmd]));
if contains(p,'which: no')
   ws=warning('query','ASK:BASH:VerifyFailed');
   if isequal(ws.state,'on')
      disp(p)
   end
   if ~isequal(user, 'NOTE: only recommended!')
      warning('ASK:BASH:VerifyFailed', '%s is not available (needed e.g. for %s).\n', cmd, user)
      user = ['s.a. ' user];         
   end
   fprintf('Please run setup-x86_64.exe from: https://cygwin.org and select %s (%s)\n', cmd, user)
elseif ~isequal(p(1:9),'/usr/bin/')
   is_installed_in_alternate_path = false;   
   if ~iscell(alternate); alternate={alternate}; end
   for ai = 1:numel(alternate)
      if ~isempty(alternate{ai}) && contains(p,alternate{ai})
         is_installed_in_alternate_path = true;
      end
   end
   if ~is_installed_in_alternate_path
      fprintf('NOTE: %-30s is not installed in /usr/bin/, but on %s (ignored).\n', cmd, p)
   end
end
return
end

function cmd_out = RemoveLastEndline(cmd_out)
if ~isempty(cmd_out) && double(cmd_out(end))==10
   cmd_out=cmd_out(1:end-1);
end
return
end