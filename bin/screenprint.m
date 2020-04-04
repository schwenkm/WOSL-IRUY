function screenprint(filename,fignr,resolution)
%SCREENPRINT uses Matlab grab and save the screen-contents as *.png.
%Syntax:
%  screenprint(filename,fignr,resolution)
%
%Parameters:
%  filename the filename of the gif-file to be saved
%           (with or without .png ending)
%  fignr    the numbers of the figures that should be saved as png
%           if fignr is a horizontal row vector, it will be reshaped
%           into two columns, e.g.
%           [1 2 3 4] -> [1 2;   and  [1 2 3 4 5 6 7] -> [1 2;
%                         3 4];                           3 4;
%                                                         5 6;
%                                                         7 NaN];
%           The shape of fignr represents how the figures are saved.
%  resolution  the resolution for the plot (default is 72 dpi)
%           another useful value is 100.
%
% Known Bugs:
%       using the default resolution the dot-markers are too small.
%       workaround: use resolution = 100.
%
%See Also: screenshot

narginchk(2,3);

if ~ischar(filename)
   error('Arg1 must be a filename');
end

%% set default parameters:
if nargin < 3
   resolution = 72; % default is 150 for figures 
   DefaultFS = get(0,'DefaultTextFontSize'); 
   fontSize  = 13; % old: 6
   resolution_given = false;
   warning('ASK:Screenprint:NoDots','Dots may not be visible, use resolution=100!');
   warning('off','ASK:Screenprint:NoDots'); % print warning only once!
else
   resolution_given = true; % e.g. resolution==100
end

%% turn figure-object (rev >= R1015a) to numbers:
if isobject(fignr)
   fignr = [fignr.Number];
end

%% reshape fignr if it is a horizontal row-vector:
if (size(fignr,1)==1) && (numel(fignr)>1)
   if (numel(fignr)>2) && (mod(numel(fignr),2)==1)
      fignr = [fignr NaN];
   end
   fignr = reshape(fignr,2,numel(fignr)/2)';
end
%% loop through the given figures
filename = [strrep(filename,'.png','') '.png'];
nfigs = numel(fignr);
for figi = 1:nfigs
   fig = fignr(figi);
   if isnan(fig)
      continue;
   end
   %ignored, because it is not at all faster: set(fig,'Visible','Off');
   pt=get(fig,'PaperType');
   po=get(fig,'PaperOrientation');
   pu=get(fig,'PaperUnits');
   pp=get(fig,'PaperPosition');
   set(fig,'PaperType','A4');
   set(fig,'PaperOrientation','portrait');
   if resolution_given
      set(fig,'PaperUnits', 'inches');
      pos = get(fig,'position'); pos = [0 0 pos(3:4)/resolution];
      %set(fig,'PaperPosition', [0 0 5.6 4.2]); % good when resolution=100
      set(fig,'PaperPosition', pos); % good when resolution=100
   else
      set(fig,'PaperUnits', 'centimeters');
      set(fig,'PaperPosition', [0 0 19.86 14.89]);
      textobj = findall(fig,'FontSize', DefaultFS); 
      set(textobj, 'fontsize', fontSize);
   end
   print(['-f' num2str(fig)],'-dpng',['-r' num2str(resolution)],[filename 'tmp.png']);
   %[pcm,dev]=printopt,   arg1=['-f' num2str(fig)],   arg2='-dpng',   arg3=['-r' num2str(resolution)],   arg4=[filename 'tmp.png']
   if ~resolution_given
      set(textobj, 'fontsize', DefaultFS);
   end
   set(fig,'PaperType',pt);
   set(fig,'PaperOrientation',po);
   set(fig,'PaperUnits',pu);
   set(fig,'PaperPosition',pp);
   [im_rgb]=imread([filename 'tmp.png']);
   % use rot90 if the paper orientation was 'landscape' while printing
   im_r=im_rgb(:,:,1); %rot90(im_rgb(:,:,1),3);
   im_g=im_rgb(:,:,2); %rot90(im_rgb(:,:,2),3);
   im_b=im_rgb(:,:,3); %rot90(im_rgb(:,:,3),3);
   if figi==1
      all_r = repmat(uint8(255), size(im_r).*size(fignr));
      all_g = all_r; all_b = all_r;
   end
   [pts_y,pts_x]=size(im_r);
   num_y = mod(figi-1,size(fignr,1)); % == 0,1,2,..., number of columns of fignr
   num_x = floor((figi-1)/size(fignr,1)); % = e.g. 0, 0, 1, 1, 2, 2, ..., when n_col=2
   all_r(num_y*pts_y+(1:pts_y),num_x*pts_x+(1:pts_x)) = im_r;
   all_g(num_y*pts_y+(1:pts_y),num_x*pts_x+(1:pts_x)) = im_g;
   all_b(num_y*pts_y+(1:pts_y),num_x*pts_x+(1:pts_x)) = im_b;
end
delete([filename 'tmp.png']);
all_rgb=cat(3,all_r, all_g, all_b);
imwrite(all_rgb,filename);
return
end

