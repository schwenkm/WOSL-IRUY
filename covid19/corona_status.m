%%
% Data Quelle A: Johns Hopkins database
% see: https://de.mathworks.com/matlabcentral/fileexchange/74589-load-covid-19-case-data-from-john-hopkins-database
%      https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series
% See also: https://hgis.uw.edu/virus/virus

%%
png_file=[];
idx=0;
for url_idx=1:2
   url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv'; %#ok<NASGU>
   url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv';
   if url_idx==2
      url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv';
   end
   
for do_diff = 0:2
do_mav  = 2*do_diff + 2*url_idx - 1;
if do_diff==2; do_mav = 14; end
%%
if ~exist('dwn_url','var') || ~isequal(dwn_url, url) || ~isequal(dwn_date,date)
   dwn_filename = 'c:\temp\websave\corona_stat.csv';
   if ~exist(fileparts(dwn_filename),'dir')
      mkdir(fileparts(dwn_filename))
   end
   if ~exist('ntitle','file')
      addpath(fullfile(fileparts(which(mfilename)),'..','bin'))
   end
   options = weboptions;
   options.Timeout = 13;
   dwn_filename = websave(dwn_filename,url,options);
   dwn_url=url;
   dwn_date=date;
   if verLessThan('matlab', '9.8')
      A     = readtable(dwn_filename);
   else
      A     = readtable(dwn_filename,'Format','auto');
   end
end
if idx==0
   % Start with the current verion of images:
   bash('-v', 'git', 'pull');
end
tit=strrep(url((find(url=='/',1,'last')+1):end),'time_series_','');
tit=strrep(tit,'.csv','');
ti      = datetime(A{1,5:end},'InputFormat','MM/dd/yy');
cntry   = A{2:end,2};
state   = A{2:end,1};
cases   = str2double(A{2:end,5:end});
Legend = {};
DatX={};
DatY={};
Col={};
to_be_deleted=[];
lineh=[];
%%
EUList = {'Austria','Belgium','Bulgaria','Croatia','Cyprus','Czechia','Denmark','Estonia','Finland','France','Germany','Greece','Hungary','Ireland','Italy','Latvia','Lithuania','Luxembourg','Malta','Netherlands','Poland','Portugal','Romania','Slovakia','Slovenia','Spain','Sweden',};
CList1 = {'EU' 'Italy','Germany','France','China','US','Korea, South'};
CList2 = cntry(find(max(cases')>30000))';   % mind 30k infizierte
if url_idx==2
   CList2 = cntry(find(max(cases')>2400))'; % mind 2400 tote
end
CList = unique({CList1{:} CList2{:}});
figure(1), hold off
cnt = 0;
min_dt = inf;
for pp = 1:numel(CList)
%    if isequal(CList{pp},'Iran')
%       continue; % ignore Iran for now
%    end
   cnt = cnt+1;
   cntry_long =           CList{pp};
   i1 = find(strcmp(cntry,CList{pp}));
   if isequal(cntry_long,'EU')
      i1=find(cellfun(@(s) ~isempty(find(strcmp(s,EUList))), cntry));
   end
   if numel(i1)>1
      jj=find(cellfun(@isempty,strfind(state(i1),',')));
      i1=i1(jj); % remove e.g. 'New York County, NY'
      cntry_long = [cntry_long ' N=' num2str(numel(i1))]; %#ok<AGROW>
   end
   case_sum=sum(cases(i1,:),1);
   if do_diff
      case_sum=mavr([zeros(1,do_diff) diff(case_sum,do_diff)],do_mav)';
   end
   dt=0;f=1;cl='-';
   cntry_short = cntry_long;
   if isequal(CList{pp},'EU')
      cl='m-.';  sum_eu=round(case_sum(end));
      dt=7;       cntry_short='EU';
      if url_idx==2; dt=14; end
   elseif isequal(CList{pp},'Germany')
      cl='r*-'; sum_ger=round(case_sum(end));
   elseif isequal(CList{pp},'France')
      cl='g.-';  sum_fr=round(case_sum(end));
   elseif isequal(CList{pp},'US')
      cl='co-';  sum_us=round(case_sum(end));
   elseif isequal(CList{pp},'Italy')
      cl='b.-';
      dt=6; if url_idx==2; dt=12; end
   elseif isequal(CList{pp},'China') 
      dt=46;     cntry_short='Chn';
      if url_idx==2; dt=53; end
%    elseif isequal(CList{pp},'Korea, South') 
%       f=2;       cntry_short='SK';
%       dt=15; % if url_idx==2; dt=13; end
   elseif isequal(CList{pp},'United Kingdom') 
                 cntry_long='UK';
   end
   %plot(ti,case_sum,cl); grid on; hold all
   DatX{cnt}=ti;
   DatY{cnt}=case_sum;
   Col{cnt}=cl;
   to_be_deleted(cnt)=0;
   Legend{cnt}=cntry_long;
   if dt>0
      dp=21; % extrapolate max 3 weeks
      rr=1:min(numel(ti),numel(ti)-dt+21);
      %dlh=plot(ti(rr)+dt,f*case_sum(rr),':');
      cnt = cnt+1;
      DatX{cnt}=ti(rr)+dt;
      DatY{cnt}=f*case_sum(rr);
      Col{cnt}=':';
      to_be_deleted(cnt) = 1; % all delayed lines
      if f==1
         Legend{cnt}=[cntry_short ' ' num2str(dt) ' days ago'];
      else
         Legend{cnt}=[cntry_short ' x' num2str(f) ', ' num2str(dt) 'd ago'];
      end
      min_dt = min(min_dt,dt);
   end
end
%% re-sort by maximum, so that legend reflects order:
if do_diff==0
   Max=NaN(1,cnt);
   for ci=1:cnt
      Max(ci)=max(DatY{ci});
   end
   Max(find(to_be_deleted))=Max(find(to_be_deleted)-1)-(1e-3);
   [~,cii]=sort(Max,'descend');
   fprintf('Die kleinsten 6 Zahlen (%s and below):', Legend{cii(end-5)}); disp(round(Max(cii((end-5):end))))
end
DatX=DatX(cii);
DatY=DatY(cii);
Col=Col(cii);
to_be_deleted=to_be_deleted(cii);
Legend=Legend(cii);
DatY_end = NaN(1,cnt);
for ci=1:cnt
   lineh(ci)=plot(DatX{ci},DatY{ci},Col{ci}); grid on; hold all   
   DatY_end(ci) = DatY{ci}(end);
end
legend(Legend,'Location','northwest');
set(gcf,'position',[230,200,700,420])
%% Add extra Legend at right to reflect right most order with colors
xx=max(get(gca,'XLim')) + diff(get(gca,'XLim'))/100;
yy=max(get(gca,'YLim'));
[~,ci_sort]=sort(DatY_end,'descend');
for ci=[-1 ci_sort]
   if ci==-1
      set(text(xx,yy,'Order:'),'Units','pixels'); % do not change on Zoom
      yy = yy - diff(get(gca,'YLim'))/40;
   elseif ~contains(Legend{ci},' ago')
      yy = yy - diff(get(gca,'YLim'))/20;
      legNoSp = Legend{ci}; legNoSp(find(legNoSp==' '):end)='';
      legh(ci)=text(xx,yy,legNoSp,'Color',get(lineh(ci),'Color'));
      set(legh(ci),'Units','pixels'); % do not change on Zoom
   end
end
%%
if do_diff
   tit=[ 'diff(' tit ',' num2str(do_diff) ')' ];
   if do_mav
     tit=[ 'mavr(' tit ',' num2str(do_mav) ')' ];
   end
   if do_diff == 1
      ylabel(sprintf('%s:  %d-Tages-Mittelwert der ersten Ableitung', ti(end), do_mav));
   else
      ylabel(sprintf('%s  %d-Tages-Mittelwert der %d-ten Ableitung', ti(end), do_mav, do_diff));
   end
   delete(lineh(to_be_deleted>0))
else
   ylabel(sprintf('%s  Ger: %d, US: %d, EU: %d', ti(end), sum_ger, sum_us, sum_eu));
end
ntitle(['Quelle: Johns Hopkins database  /  ' tit])
ax=gca; ax.YRuler.Exponent=0; ax.YRuler.TickLabelFormat='%.0f';

%%
idx=idx+1;
fname=sprintf('corona_%02d_heute', idx);
xx=mean(get(gca,'XLim'))-diff(get(gca,'XLim'))/6;
y1=mean(get(gca,'YLim')) + diff(get(gca,'YLim'))*0.36;
y2=mean(get(gca,'YLim')) + diff(get(gca,'YLim'))*0.30;
y3=mean(get(gca,'YLim')) + diff(get(gca,'YLim'))*0.24;
t1=[]; t2=[]; t3=[];
switch(idx)
   case 1
      t1=text(xx,y1,'Anzahl der Infizierten,');
      t2=text(xx,y2,'bis dato, aufsummiert');
      t3=text(xx,y3,' ');
   case 3
      t1=text(xx,y1,'Anzahl Infizierte pro Tag');
      t2=text(xx,y2,sprintf('(Durchschnittswert über %d Tage)', do_mav));
   case 4
      t2=text(xx,y1,'Anzahl Infizierte mehr,');
      t2=text(xx,y2,'im Vergleich zum Vortag');
      t3=text(xx,y3,sprintf('(Durchschnittswert über %d Tage)', do_mav));      
   case 5
      t1=text(xx,y1,'Anzahl der Toten,');
      t2=text(xx,y2,'bis dato, aufsummiert');
      t3=text(xx,y3,' ');
   case 7
      t1=text(xx,y1,'Anzahl Tote pro Tag');
      t2=text(xx,y2,sprintf('(Durchschnittswert über %d Tage)', do_mav));
   case 8
      t1=text(xx,y1,'Anzahl Tote mehr,');
      t2=text(xx,y2,'im Vergleich zum Vortag');
      t3=text(xx,y3,sprintf('(Durchschnittswert über %d Tage)', do_mav));      
end
set([t1 t2 t3],'units','pixel')

%set(gca,'ylim',[0 sum_eu])
xxx=xlim; xx1=(ti(end)-xxx(1));
if ~do_diff
   xlabel(sprintf('vergangene %d Tage, und projizierte %d bis %d Tage', days(xx1), min_dt, dp));
else
   ttt=datetime(ti(end), 'Format', 'd. MMMM'); xx2=(xxx(2)-ttt);
   xlabel(sprintf('%d Tage vor dem %s und %d Tage danach', days(xx1), ttt, days(xx2)))
end
img_dir='Bilder';
if ~exist(img_dir,'dir')
   mkdir(img_dir)
end

screenprint(fullfile(img_dir,[fname '_full']),gcf,100,'ImageModTime',datenum(ti(end)))
disp(['Save As ' fname '_full.png'])
if isempty(png_file)
   png_file=[fname '_full.png'];
end
%IrfanView(fullfile(img_dir,[fname '_full.png']))

if ~do_diff
   idx=idx+1;
   fname=sprintf('corona_%02d_heute', idx);
   set(gca,'xlim',datetime('today')+[-20 10])
   set(gca,'ylim',[0 max([sum_ger*2 sum_fr sum_us])])
   xxx=xlim; xx1=(ti(end)-xxx(1));
   if min_dt < 10
        xlabel(sprintf('vergangene %d Tage, und projizierte %d bis %d Tage', days(xx1), min_dt, 10));
   else
        xlabel(sprintf('vergangene %d Tage, und projizierte %d Tage', days(xx1), 10));
   end
   t3.String='(Ausschnitt-Darstellung)';
   screenprint(fullfile(img_dir,[fname '_zoom']),gcf,100,'ImageModTime',datenum(ti(end)))
   disp(['Save As ' fname '_zoom.png'])
   %pause
   %IrfanView(fullfile(img_dir,[fname '_zoom.png']))
end

set(gca,'xlimmode','auto')
set(gca,'ylimmode','auto')
xlabel('')

%%
end
end
%%
IrfanView(fullfile(img_dir,png_file))

%% Copy dependencies
if 0
   %%
   dest='C:\AAA\Git\Github_Schlack_WOSL-IRUY\bin';
   this_mfile='corona_status.m';
   dest=fullfile(fileparts(which('corona_status.m')),'..','bin')
   fList = matlab.codetools.requiredFilesAndProducts(this_mfile);
   for i=1:numel(fList)
      if ~isequal(filebase(fList{i}), this_mfile)
         copyfile(fList{i}, dest)
      end
   end
else
   %% add to git
   commit_msg=sprintf('Add Images from %s', ti(end));
   bash('-v', 'git', 'commit', '-a', '-m', commit_msg);
   bash('git', 'push');
end
