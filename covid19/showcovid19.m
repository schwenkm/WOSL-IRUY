%%
%previous url: url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv';
url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv';
url_rec = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv';
url_dea = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv';

dwn_filename     = [tempdir 'c.csv'];
dwn_filename_rec = [tempdir 'cr.csv'];
dwn_filename_dea = [tempdir 'de.csv'];

dwn_filename     = websave(dwn_filename,url);
dwn_filename_rec = websave(dwn_filename_rec,url_rec);
dwn_filename_dea = websave(dwn_filename_dea,url_dea);

PopCntryList = {'Germany','France total','Italy','China total','China Hubei','Spain','Norway','Sweden','Korea, South','US total','Czechia','Singapore','Taiwan*','Netherlands ','United Kingdom '};
PopCountList = [    80         67           60         1400        58        50       5.4     10.2       51.2           327      10.6          5.6       23.8        17.3            67] * 1e6;

%%
LANG = 'DE';
Measures ={...
            'Germany','11-Mar-2020','keine Großveranstalltungen','-';...
            'Germany','16-Mar-2020','allgemeine Schließungen','-';...
            'Germany','22-Mar-2020','Kontaktverbot','-';...
            'Germany','15-Apr-2020','kleine Geschäfte öffnen','+';...
            'Germany', '4-May-2020','teilweise Schulbetrieb','+';...
    };

%%
if verLessThan('matlab','9.8')
A       = readtable(dwn_filename);
else
A       = readtable(dwn_filename,'Format','auto');
end
ti      = datetime(A{1,5:end},'InputFormat','MM/dd/yy');
cntry   = A{2:end,2};
region  = A{2:end,1};
state   = A{2:end,1};
cases   = str2double(A{2:end,5:end});
%

if verLessThan('matlab','9.8')
A_rec       = readtable(dwn_filename_rec);
else
A_rec       = readtable(dwn_filename_rec,'Format','auto');
end
ti_rec      = datetime(A_rec{1,5:end},'InputFormat','MM/dd/yy');
cntry_rec   = A_rec{2:end,2};
region_rec  = A_rec{2:end,1};
state_rec   = A_rec{2:end,1};
recovered   = str2double(A_rec{2:end,5:end});
%
if verLessThan('matlab','9.8')
A_dea       = readtable(dwn_filename_dea);
else
A_dea       = readtable(dwn_filename_dea,'Format','auto');
end
ti_dea      = datetime(A_dea{1,5:end},'InputFormat','MM/dd/yy');
cntry_dea   = A_dea{2:end,2};
region_dea  = A_dea{2:end,1};
state_dea   = A_dea{2:end,1};
death      = str2double(A_dea{2:end,5:end});
%
assert(all(ti==ti_rec))
assert(all(ti==ti_dea))

% collect states
[cntry, cases] = collect_states(cntry,cases,'US');
[cntry, cases] = collect_states(cntry,cases,'France');
[cntry, cases] = collect_states(cntry,cases,'China');
[cntry, cases] = collect_region(cntry,region,cases,'China','Hubei');
[cntry, cases] = collect_region(cntry,region,cases,'Netherlands','');
[cntry, cases] = collect_region(cntry,region,cases,'United Kingdom','');
[cntry_rec, recovered] = collect_states(cntry_rec,recovered,'US');
[cntry_rec, recovered] = collect_states(cntry_rec,recovered,'France');
[cntry_rec, recovered] = collect_states(cntry_rec,recovered,'China');
[cntry_rec, recovered] = collect_region(cntry_rec,region_rec,recovered,'China','Hubei');
[cntry_rec, recovered] = collect_region(cntry_rec,region_rec,recovered,'Netherlands','');
[cntry_rec, recovered] = collect_region(cntry_rec,region_rec,recovered,'United Kingdom','');
[cntry_dea, death] = collect_states(cntry_dea,death,'US');
[cntry_dea, death] = collect_states(cntry_dea,death,'France');
[cntry_dea, death] = collect_states(cntry_dea,death,'China');
[cntry_dea, death] = collect_region(cntry_dea,region_dea,death,'China','Hubei');
[cntry_dea, death] = collect_region(cntry_dea,region_dea,death,'Netherlands','');
[cntry_dea, death] = collect_region(cntry_dea,region_dea,death,'United Kingdom','');


%%
if (0) % skip others
%% cases
CList ={'Germany','France total','Italy','China total','Spain','Norway','Sweden','Korea, South','US total'};
%CList ={'US total'};
%CList ={'Germany','Italy','China'};

figure(1), hold off
cnt = 0;Legend=[];
for pp = 1:numel(CList)
    cnt = cnt+1;
    i1 = find(strcmp(cntry,CList{pp}),1);
    plot(ti,cases(i1,:),'.-');
    Legend{cnt}=cntry{i1};
    grid on
    hold all
end
legend(Legend);
title('total')
set(gca,'YScale','log')
xlabel('date')
ylabel('confirmed cases')


%% recovered
figure(4), hold off
cnt = 0;Legend=[];
for pp = 1:numel(CList)
    cnt = cnt+1;
    i1 = find(strcmp(cntry_rec,CList{pp}),1);
    plot(ti_rec,recovered(i1,:),'.-');
    Legend{cnt}=cntry_rec{i1};
    grid on
    hold all
end
legend(Legend);
set(gca,'YScale','log')
title('recovered')
xlabel('date')
ylabel('confirmed cases')

%% cases aligned
alignat = 1000;
aligncntry ={'Italy'};
ial = find(strcmp(cntry,aligncntry),1);

figure(2), hold off
cnt = 0;Legend=[];
for pp = 1:numel(CList)
    cnt = cnt+1;
    i1 = find(strcmp(cntry,CList{pp}),1);
    i2 = find(cases(i1,:) >= alignat,1);
    if (min(cases(i1,:)) <= alignat)
        dural = (ti-ti(i2));
    else
        i2 = find(cases(ial,:) >= alignat,1);
        i3 = find(cases(ial,:) >= min(cases(i1,:)),1);
        i4 = find(cases(i1,:) >= min(cases(i1,:)),1);
        dural = (ti-ti(i4)) + (ti(i3)-ti(i2));
    end
    plot(dural,cases(i1,:),'.-');
    Legend{cnt}=cntry{i1};
    grid on
    hold all
end
plot(duration(days(0)), alignat,'mo','MarkerSize',12);
Legend{cnt+1}='alignment';

legend(Legend);
set(gca,'YScale','log')
xlabel('days')
ylabel('confirmed cases')
xtickformat('d')
%% new vs. cases 
CList ={'Germany','France total','Italy','China total','Spain','US total'};

daily_new = diff(cases,1,2);
figure(3), hold off
cnt = 0;Legend=[];
for pp = 1:numel(CList)
    cnt = cnt+1;
    i1 = find(strcmp(cntry,CList{pp}),1);
    plot(cases(i1,2:end),daily_new(i1,:),'.-');
    Legend{cnt}=cntry{i1};
    grid on
    hold all
end

legend(Legend,'Location','NorthWest');
set(gca,'YScale','log')
set(gca,'XScale','log')
ylabel('new cases')
xlabel('confirmed cases')

%% active cases 
figure(5), hold off
cnt = 0;Legend=[];
for pp = 1:numel(CList)
    cnt = cnt+1;
    i1     = find(strcmp(cntry,CList{pp}),1);
    i1_rec = find(strcmp(cntry_rec,CList{pp}),1);
    i1_dea = find(strcmp(cntry_dea,CList{pp}),1);    
    active = cases(i1,:) - recovered(i1_rec,:) - death(i1_dea,:);
    plot(ti,active,'.-');
    Legend{cnt}=cntry{i1};
    grid on
    hold all
end
legend(Legend);
set(gca,'YScale','log')
title('active')
xlabel('time')
ylabel('active')
%% increase 
figure(6), hold off
cnt = 0;Legend=[];
for pp = 1:numel(CList)
    cnt = cnt+1;
    i1     = find(strcmp(cntry,CList{pp}),1);
    increase = diff(cases(i1,:));
    plot(ti(1:(end-1)),increase,'.-');
    Legend{cnt}=cntry{i1};
    grid on
    hold all
end
legend(Legend,'location','best');
%set(gca,'YScale','log')
title('increase')
xlabel('time')
ylabel('increase')
%% active cases vs increase (state diagram)
% CList ={'Germany','France total','Italy','China total','Spain','US total'};
% figure(7), hold off
% cnt = 0;Legend=[];
% for pp = 1:numel(CList)
%     cnt = cnt+1;
%     i1     = find(strcmp(cntry,CList{pp}),1);
%     i1_rec = find(strcmp(cntry_rec,CList{pp}),1);
%     i1_dea = find(strcmp(cntry_dea,CList{pp}),1);    
%     active = cases(i1,:) - recovered(i1_rec,:) - death(i1_dea,:);
%     increase = diff(cases(i1,:));
%     active = active(2:end);
%     increase_f = filtfilt([0.5 1 1 1 1 1 0.5]/7,1,increase);
%     active_f = filtfilt([0.5 1 1 1 1 1 0.5]/7,1,active);
%     plot(active_f,increase_f,'.-');
%     Legend{cnt}=cntry{i1};
%     grid on
%     hold all
% end
% legend(Legend);
% %set(gca,'YScale','log')
% %set(gca,'XScale','log')
% title({'increase vs active','1 week average'})
% xlabel('active')
% ylabel('increase')
%% active cases vs increase normed to population size (phase state diagram)
CList ={'Germany','France total','Italy','China total','Spain','US total'};
figure(8), hold off
cnt = 0;clear Legend ACN ICN TCN;
for pp = 1:numel(CList)
    cnt = cnt+1;
    norm_idx = find(strcmp(PopCntryList,CList{pp}),1);
    i1     = find(strcmp(cntry,CList{pp}),1);    
    i1_rec = find(strcmp(cntry_rec,CList{pp}),1);
    i1_dea = find(strcmp(cntry_dea,CList{pp}),1);    
    active = cases(i1,:) - recovered(i1_rec,:) - death(i1_dea,:);
    increase = diff(cases(i1,:));
    active = active(2:end);
    increase_f = filtfilt([0.5 1 1 1 1 1 0.5]/7,1,increase);
    active_f = filtfilt([0.5 1 1 1 1 1 0.5]/7,1,active);
    increase_n = increase_f / PopCountList(norm_idx) * 100000;
    active_n = active_f / PopCountList(norm_idx) * 100000;
    sel = 1:(numel(active_n)-2);
    plot(active_n(sel),increase_n(sel),'.-');
    Legend{cnt}=cntry{i1};
    grid on
    hold all
    
    ACN(cnt,:) = active_n(sel(1:14:end))';
    ICN(cnt,:) = increase_n(sel(1:14:end))';
    TCN(cnt,:) = ti(sel(1:14:end)+1)';
end


plot(ACN(:,(end-2)), ICN(:,(end-2)),'bd','MarkerSize',3); cnt=cnt+1;Legend{cnt}=datestr(TCN(1,(end-2)));
plot(ACN(:,(end-1)), ICN(:,(end-1)),'bo','MarkerSize',4); cnt=cnt+1;Legend{cnt}=datestr(TCN(1,(end-1)));
plot(ACN(:,(end-0)), ICN(:,(end-0)),'bs','MarkerSize',5); cnt=cnt+1;Legend{cnt}=datestr(TCN(1,(end-0)));
    

legend(Legend);
%set(gca,'YScale','log')
%set(gca,'XScale','log')
title({'Covid19, increase of total cases vs active cases','per 100000 inhabitants - 1 week average'})
xlabel('active')
ylabel('increase')
end % skip others
%% bubble + active cases vs increase normed to population size (phase state diagram)
CList ={'Germany','France total','Italy','China Hubei','Spain','Sweden','Norway','Czechia','US total','Singapore','Netherlands ','United Kingdom '};
%CList ={'Germany'} 
figure(9), close gcf;
hf9 = figure(9); hold off
hf9.Position = [50 -200 1200 800];
cnt = 0;clear ACN ICN TCN DDN;
for pp = 1:numel(CList)
    cnt = cnt+1;
    norm_idx = find(strcmp(PopCntryList,CList{pp}),1);
    i1     = find(strcmp(cntry,CList{pp}),1);    
    i1_rec = find(strcmp(cntry_rec,CList{pp}),1);
    i1_dea = find(strcmp(cntry_dea,CList{pp}),1);    
    active = cases(i1,:) - recovered(i1_rec,:) - death(i1_dea,:);
    filtercoef=[1 1 1 1 1 1 1]/7;
    cases_f = filtfilt(filtercoef,1,cases(i1,:));
    active_f = filtfilt(filtercoef,1,active);
    death_diff_f = filtfilt(filtercoef,1,[0 diff(death(i1_dea,:))]); % fill with 0 at index 1
    increase_f = [0 diff(cases_f)]; % fill with 0 at index 1
  
    increase_n = increase_f / PopCountList(norm_idx) * 100000;
    active_n = active_f / PopCountList(norm_idx) * 100000;
    death_diff_n = death_diff_f / PopCountList(norm_idx) * 100000;
    sel = 1:(numel(active_n)-0);
    % plot line, defining country color 
    hp = plot(active_n(sel),increase_n(sel),'-','LineWidth',1.5,'HandleVisibility','off');
    hold all
    
    % store date for annotation ...
    ACN(cnt,:) = active_n(sel)';
    ICN(cnt,:) = increase_n(sel)';
    TCN(cnt,:) = ti(sel)';
    DDN(cnt,:) = death_diff_n(sel)';
    col(cnt,:) = hp.Color;
    CNT{cnt}   = CList{pp};
end

textoffset_x = 1;
textoffset_y = 0;

legcnt=0;clear Legend;

%
topy=ceil(max(ICN(:))/10)*10;
text(max(ACN(:))/20-5*textoffset_x,topy*(1-1/40),['Daten: ' datestr(min(TCN(:))) ' bis ' datestr(max(TCN(:)))])

% death rate circles annotation, days and end date legend entry
DDN_ano = [2 1 0.1 0.01];
scatter(repmat(max(ACN(:))/20,1,numel(DDN_ano)),topy*(1-2/20-1/30-(1:numel(DDN_ano))/30),2+100*DDN_ano,'k');
scatter(0,0,1,'k','filled');
if LANG == 'DE'
legcnt=legcnt+1;Legend{legcnt}='Tage';
text(max(ACN(:))/20-5*textoffset_x,topy*(1-2/20),{'Tote pro Tag' 'pro 100000 Einw.'})
legcnt=legcnt+1;Legend{legcnt}=['letzter: ' datestr(TCN(1,end))];
else
legcnt=legcnt+1;Legend{legcnt}='days';
text(max(ACN(:))/20-5*textoffset_x,topy*(1-2/20),{'death per day' 'per 100000 inh.'})
legcnt=legcnt+1;Legend{legcnt}=['last: ' datestr(TCN(1,end))];
end
text(repmat(max(ACN(:))/20,1,numel(DDN_ano))+5*textoffset_x,topy*(1-2/20-1/30-(1:numel(DDN_ano))/30),num2str(DDN_ano(:)))

% bubble line and country text
for qq = 1:size(ACN,1)
    scatter(ACN(qq,:),ICN(qq,:),2+100*DDN(qq,:),col(qq,:),'HandleVisibility','off');
    scatter(ACN(qq,end),ICN(qq,end),2+100*DDN(qq,end),col(qq,:),'filled','HandleVisibility','off');
    hcnt_txt(qq) = text(ACN(qq,end)+textoffset_x,ICN(qq,end)+textoffset_y,CNT(qq));
end
% max death rate
[qq,pp] = ind2sub(size(DDN),find(DDN == max(DDN(:))));
scatter(ACN(qq,pp),ICN(qq,pp),2+100*DDN(qq,pp),col(qq,:),'HandleVisibility','off','LineWidth',1.5);
text(ACN(qq,pp)+5*textoffset_x,ICN(qq,pp)+textoffset_y,[num2str(DDN(qq,pp),2) ]);



% measures annotation and legend entries
for qq = 1:size(ACN,1)
    for pp = 1:size(Measures,1)
        if strcmp(Measures{pp,1},CNT(qq))% ={'Germany','11.3.2020','keine Großveranstalltungen','-'}
            idx = find(TCN(qq,:)==Measures{pp,2});
            if ~isempty(idx)
                legcnt=legcnt+1;Legend{legcnt}=[Measures{pp,2} ': ' Measures{pp,3}];
                if strcmp(Measures{pp,4},'+')
                    so=scatter(ACN(qq,idx),ICN(qq,idx),80,'d','filled','MarkerEdgeColor',col(qq,:),'MarkerFaceColor','g','LineWidth',1.5);
                    so.MarkerFaceAlpha = 0.5;
                else
                    so=scatter(ACN(qq,idx),ICN(qq,idx),80,'d','filled','MarkerEdgeColor',col(qq,:),'MarkerFaceColor','r','LineWidth',1.5);
                    so.MarkerFaceAlpha = 0.5;
                end
            end
        end
    end
    scatter(ACN(qq,:),ICN(qq,:),1+100*DDN(qq,:),col(qq,:));
end

% put text on top
hchilds= get(gca,'Children');
hchilds_start = [];hchilds_end = [];
for oo = 1:numel(hchilds)
if ~isempty(find(hchilds(oo) == hcnt_txt(:)))
    hchilds_start = [hchilds_start;hchilds(oo)];
else
    hchilds_end = [hchilds_end;hchilds(oo)];
end
end
set(gca,'Children',[hchilds_start;hchilds_end]);
% plot documentation
legend(Legend,'location','northeastoutside');
grid on
grid minor

if LANG == 'DE'
    title({'Covid19 Dynamik','täglich neue über aktiven Fällen bezogen auf die Einwohnerzahl'})
    xlabel('aktive Fälle pro 100000 Einwohner')
    ylabel('täglich neue Fälle pro 100000 Einwohner')
else
    title({'Covid19 dynamic','daily new over active cases in relation to population size'})
    xlabel('active cases per 100000 inhabitants')
    ylabel('new per day per 100000 inhabitants')
end
dim = [.025 .02 .975 .035];
str = {'data provided by Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE): https://systems.jhu.edu/'...
       'per GitHub: https://github.com/CSSEGISandData/COVID-19, presentation: Marcus Schwenk (2020)'};
ant = annotation('textbox',dim,'String',str,'FitBoxToText','on','LineStyle','none');
ant.FontSize = 8;

% align boundaries
xl=xlim;yl=ylim;xlim([-10 ceil(max(xl)/100)*100]);

ylim([-0.5 topy]);
if (exist('publish_figure_on_schwenk_elektronik')==2)
publish_figure_on_schwenk_elektronik(9,'CovidDynamik')
end

%%

%% collect states
function [new_cntry, new_cases] = collect_states(CntryList,Cases,Cntry_Name)
    new_cntry = CntryList;
    new_cases = Cases;
    newidx = numel(CntryList) +1;
    collectCntry = Cntry_Name;
    icoll = find(strcmp(CntryList,collectCntry));
    new_cntry{newidx} = [collectCntry ' total'];
    new_cases(newidx,:) = 0;
    for pp = icoll'     new_cases(newidx,:) = new_cases(newidx,:) + new_cases(pp,:); end
end

%[cntry, cases] = collect_region(cntry,cases,'China','Hubei');
function [new_cntry, new_cases] = collect_region(CntryList,Region,Cases,Cntry_Name,Region_Name)
    new_cntry = CntryList;
    new_cases = Cases;
    newidx = numel(CntryList) +1;
    collectCntry = Cntry_Name;
    icoll = find(strcmp(CntryList,collectCntry));
    if(isempty(Region_Name))
        ext='.';
    else
        ext='';
    end
    new_cntry{newidx} = [collectCntry ' ' Region_Name];
    new_cases(newidx,:) = 0;
    for pp = icoll'
        if strcmp(Region(pp),Region_Name)
            new_cases(newidx,:) = new_cases(newidx,:) + new_cases(pp,:); 
        end
    end
end
