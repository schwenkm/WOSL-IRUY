%%
%previous url: url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv';
url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv';
url_rec = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv';
url_dea = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv';
url_GER_R = 'https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Projekte_RKI/Nowcasting_Zahlen.xlsx?__blob=publicationFile';
dwn_filename     = [tempdir 'c.csv'];
dwn_filename_rec = [tempdir 'cr.csv'];
dwn_filename_dea = [tempdir 'de.csv'];
dwn_filename_GER_R = [tempdir 'GE_R.xlsx'];

dwn_filename     = websave(dwn_filename,url);
dwn_filename_rec = websave(dwn_filename_rec,url_rec);
dwn_filename_dea = websave(dwn_filename_dea,url_dea);
dwn_filename_ger = websave(dwn_filename_GER_R,url_GER_R);


PopCntryList = {'Germany','France total','Italy','China total','China Hubei','Spain','Norway','Sweden','Korea, South','US total','Czechia','Singapore','Taiwan*','Netherlands ','United Kingdom ','Croatia'};
PopCountList = [    80         67           60         1400        58        50       5.4     10.2       51.2           327      10.6          5.6       23.8        17.3            67                4    ] * 1e6;

%%
LANG = 'DE';
Measures ={...
            'Germany','11-Mar-2020','keine Großveranstalltungen','-';...
            'Germany','16-Mar-2020','allgemeine Schließungen','-';...
            'Germany','22-Mar-2020','Kontaktverbot','-';...
            'Germany','15-Apr-2020','kleine Geschäfte öffnen','+';...
            'Germany','29-Apr-2020','Maskenpflicht beim Einkaufen, ÖPNV','-';...
            'Germany', '4-May-2020','teilweise Schulbetrieb, Friseure öffnen','+';...
            'Germany','15-May-2020','Sport im Freien','+';...
            'Germany','1-Jun-2020' ,'BW: Veranstaltungen bis 100 Gäste','+';...
            'Germany','16-Jun-2020' ,'Start der Corona Warn App','+';...
            'Germany','1-Jul-2020'  ,'BW: Veranstaltungen bis 250 Gäste','+';...
            'Germany','15-Jul-2020' ,'Mallorca schließt Lokale','-';... 
            'Germany','10-Oct-2020' ,'Maskenpflicht in einzelnen Bereichen','-';...   
            'Germany','14-Oct-2020' ,'Feiern nur noch in kleinen Gruppen','-';...  
            'Germany','2-Nov-2020'  ,'Gaststätten und Theater schließen','-';...   
            'Germany','25-Nov-2020' ,'Apell Kontakte weiter zu reduzieren','-';...   
            'Germany','1-Dec-2020'  ,'Treffen begrenzt auf 5 Personen','-';...   
            'United Kingdom ','2-Dec-2020' ,'Biontec Impfstoff zugelassen','+';...   
            'Germany','1-Dec-2020'  ,'Treffen begrenzt auf 5 Personen','-';...   
            'United Kingdom ','8-Dec-2020' ,'erste Impfungen','+';...  
            'Germany','8-Dec-2020'  ,'Ausgangssperren in einzelnen Landkreisen','-';...   
            'Germany','12-Dec-2020'  ,'BW: allgemeine Ausgangssperre','-';...   
            'US total','14-Dec-2020'  ,'Impfungen mit Biontec','+';... 
            'Germany','16-Dec-2020'  ,'Geschäfte und Schulen schließen','-';...
            'US total','21-Dec-2020'  ,'Impfungen mit Moderna','+';...
            'Germany','24-Dec-2020' ,'Lockerungen für die Feiertage','+';...
            'France total','27-Dec-2020'  ,'Impfungen mit Biontec','+';...
            'Germany','27-Dec-2020'  ,'Impfungen mit Biontec','+';...
            'Italy','27-Dec-2020'  ,'Impfungen mit Biontec','+';...
            'Spain','27-Dec-2020'  ,'Impfungen mit Biontec','+';...
            'Czechia','27-Dec-2020'  ,'Impfungen mit Biontec','+';...
            'Croatia','27-Dec-2020'  ,'Impfungen mit Biontec','+';...
            'Sweden','27-Dec-2020'  ,'Impfungen mit Biontec','+';...
            'Netherlands ','27-Dec-2020'  ,'Impfungen mit Biontec','+';...
            'Norway','27-Dec-2020'  ,'Impfungen mit Biontec','+';...
            'Germany','11-Jan-2021' ,'Verschärfung d. Lockdown, nur Grundschulen offen','-';...
            'Germany','7-Jan-2021' ,'zusätzlich Moderna Impfstoff in der EU','+';...
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

% R values
if verLessThan('matlab','9.8')
Rger       = readtable(dwn_filename_ger);
else
Rger       = readtable(dwn_filename_ger,'Format','auto','Sheet','Nowcast_R');
end
ti_Rger      = Rger(:,1).Variables;
Rger = Rger.Punktsch_tzerDes7_Tage_RWertes;
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

%% bubble + active cases vs increase normed to population size (phase state diagram)
CLists{2} ={'Germany','France total','Italy','China Hubei','Spain','Sweden','Norway','Czechia','US total','Singapore','Netherlands ','United Kingdom ','Croatia'};
CLists{1} ={'Germany'} ;
for clx = 1:numel(CLists)
    CList = CLists{clx};
figure(9), close gcf;
hf9 = figure(9); hold off
hf9.Position = [50 0 1200 800];
cnt = 0;clear ACN ICN TCN DDN;
for pp = 1:numel(CList)
    cnt = cnt+1;
    norm_idx = find(strcmp(PopCntryList,CList{pp}),1);
    i1     = find(strcmp(cntry,CList{pp}),1);    
    i1_rec = find(strcmp(cntry_rec,CList{pp}),1);
    i1_dea = find(strcmp(cntry_dea,CList{pp}),1);    
    active = cases(i1,:) - recovered(i1_rec,:) - death(i1_dea,:);
    increase = [0 diff(cases(i1,:))]; % fill with 0 at index 1
    SEL_FILTER  = 1;
    if (SEL_FILTER == 1)
        Nf = 7;
        filtercoef=ones(Nf,1)/Nf;
        cases_f = filtfilt(filtercoef,1,[cases(i1,:) cases(i1,(end-1):-1:(end-1-Nf+1))]); % append mirrored signal to improve filtfilt etrapolation
        active_f = filtfilt(filtercoef,1,[active active((end-1):-1:(end-1-Nf+1))]);
        deadiff = [0  diff(death(i1_dea,:))];
        death_diff_f = filtfilt(filtercoef,1,[deadiff  deadiff((end-1):-1:(end-1-Nf+1))]); % fill with 0 at index 1
        increase_f = filtfilt(filtercoef,1,[increase increase((end-1):-1:(end-1-Nf+1))]); % fill with 0 at index 1
        cases_f = cases_f(1:(end-Nf)); % remove mirrored
        active_f = active_f(1:(end-Nf));
        death_diff_f = death_diff_f(1:(end-Nf));
        increase_f = increase_f(1:(end-Nf));
    elseif (SEL_FILTER == 2)
%     filtercoef=[4 5 6 7 6 5 4];
% %     filtercoef=ones(10,1);
%     filtercoef=filtercoef/sum(filtercoef);
% %     filtercoef=1
        filtercoef=[1 1 1 1 1 1 1]/7;
        cases_f = filter(filtercoef,1,cases(i1,:));
        active_f = filter(filtercoef,1,active);
        death_diff_f = filter(filtercoef,1,[0 diff(death(i1_dea,:))]); % fill with 0 at index 1
    end
    %increase_f = [0 diff(cases_f)]; % fill with 0 at index 1

    increase_n = increase_f / PopCountList(norm_idx) * 100000;
    active_n = active_f / PopCountList(norm_idx) * 100000;
    death_diff_n = death_diff_f / PopCountList(norm_idx) * 100000;
    sel = 1:(numel(active_n)-0);
    %sel = 1:(numel(active_n));
    
    % plot line, defining country color 
    hp(cnt) = plot(active_n(sel),increase_n(sel),'-','LineWidth',1.5,'HandleVisibility','off');
    hold all
    
    % store date for annotation ...
    ACN(cnt,:) = active_n(sel)';
    ICN(cnt,:) = increase_n(sel)';
    TCN(cnt,:) = ti(sel)';
    DDN(cnt,:) = death_diff_n(sel)';
    col(cnt,:) = hp(cnt).Color;
    CNT{cnt}   = CList{pp};

end
    Tmax = max(ti(:));
    
%repair data, skip falling number of death 
DDN(DDN<0) = NaN;
    
textoffset_x = 1;
textoffset_y = 0;

legcnt=0;clear Legend;

%
topy=ceil(max(ICN(:))/10)*10;
ht0=text(max(ACN(:))/20-5*textoffset_x,topy*(1-1/40),['Daten: ' datestr(min(TCN(:))) ' bis ' datestr(Tmax) ', dargestellt 7 Tage-Mittelwerte bis ' datestr(max(TCN(:)))]);

% death rate circles annotation, days and end date legend entry
DDN_ano = [2 1 0.1 0.01];
hs0=scatter(repmat(max(ACN(:))/20,1,numel(DDN_ano)),topy*(1-2/20-1/30-(1:numel(DDN_ano))/30),2+100*DDN_ano,'k');
scatter(0,0,1,'k','filled');
if LANG == 'DE'
legcnt=legcnt+1;Legend{legcnt}='Tage';
ht1=text(max(ACN(:))/20-5*textoffset_x,topy*(1-2/20),{'Tote pro Tag' 'pro 100000 Einw.'});
legcnt=legcnt+1;Legend{legcnt}=['letzter: ' datestr(TCN(1,end))];
else
legcnt=legcnt+1;Legend{legcnt}='days';
ht1=text(max(ACN(:))/20-5*textoffset_x,topy*(1-2/20),{'death per day' 'per 100000 inh.'});
legcnt=legcnt+1;Legend{legcnt}=['last: ' datestr(TCN(1,end))];
end
ht2=text(repmat(max(ACN(:))/20,1,numel(DDN_ano))+5*textoffset_x,topy*(1-2/20-1/30-(1:numel(DDN_ano))/30),num2str(DDN_ano(:)));

% bubble line and country text
hs1=[];hs2=[];
for qq = 1:size(ACN,1)
    hs1{qq} = scatter(ACN(qq,:),ICN(qq,:),2+100*DDN(qq,:),col(qq,:),'HandleVisibility','off');
    hs2{qq} = scatter(ACN(qq,end),ICN(qq,end),2+100*DDN(qq,end),col(qq,:),'filled','HandleVisibility','off');
    hcnt_txt(qq) = text(ACN(qq,end)+textoffset_x,ICN(qq,end)+textoffset_y,CNT(qq));
end
% max death rate
[qq,pp] = ind2sub(size(DDN),find(DDN == max(DDN(:))));
hs3 = scatter(ACN(qq,pp),ICN(qq,pp),2+100*DDN(qq,pp),col(qq,:),'HandleVisibility','off','LineWidth',1.5);
ht3 = text(ACN(qq,pp)+5*textoffset_x,ICN(qq,pp)+textoffset_y,[num2str(DDN(qq,pp),2) ]);



% measures annotation and legend entries
cnt_leg_ano = 0;
for qq = 1:size(ACN,1)
    for pp = 1:size(Measures,1)
        if strcmp(Measures{pp,1},CNT(qq))% ={'Germany','11.3.2020','keine Großveranstalltungen','-'}
            idx = find(TCN(qq,:)==Measures{pp,2});
            if ~isempty(idx)
                cnt_leg_ano=cnt_leg_ano +1;
                legcnt=legcnt+1;Legend{legcnt}=[Measures{pp,2} ': ' Measures{pp,3}];
                if strcmp(Measures{pp,4},'+')
                    hs4(cnt_leg_ano)=scatter(ACN(qq,idx),ICN(qq,idx),80,'d','filled','MarkerEdgeColor',col(qq,:),'MarkerFaceColor','g','LineWidth',1.5);
                    hs4(cnt_leg_ano).MarkerFaceAlpha = 0.5;
                else
                    hs4(cnt_leg_ano)=scatter(ACN(qq,idx),ICN(qq,idx),80,'d','filled','MarkerEdgeColor',col(qq,:),'MarkerFaceColor','r','LineWidth',1.5);
                    hs4(cnt_leg_ano).MarkerFaceAlpha = 0.5;
                end
                ht31 = text(ACN(qq,idx)+5*textoffset_x,ICN(qq,idx)+textoffset_y,datestr(Measures{pp,2},'dd.mm.'),'FontSize',6);
            end
        end
    end
    %scatter(ACN(qq,:),ICN(qq,:),1+100*DDN(qq,:),col(qq,:));
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
xl=xlim;yl=ylim;
xlim([-10 ceil(max(xl)/100)*100]);
ylim([-0.5 topy]);

if (clx == 1) % GER only
    ADDCOLORSONR = 1;
    if(ADDCOLORSONR == 1)
    hs1{1}.CData = repmat([0 0.447 0.741],size(hs1{1}.XData,2),1);
    cm = colormap('greenmiddle');
    hp(1).Color=[0.7 0.7 0.7]
    for iiti = 1:numel(ti_Rger)
        
        
           xii = find(TCN == ti_Rger(iiti));
           R = Rger(iiti);
           if ~isnan(R)
            colorindex = max([1 min([128 + round((R-1) * 128) 256])]);
            acolor = cm(colorindex,:);
           else
               xii=[];

           end
           if ~isempty(xii)
               hs1{1}.CData(xii,:) = acolor;  
               if xii < (size(ACN,2)-1)
                    plot([ACN(qq,xii) ACN(qq,xii+1)],[ICN(qq,xii) ICN(qq,xii+1)],'-','LineWidth',2.5,'HandleVisibility','off','Color',acolor);
               end
           end
    end
    hs1{1}.MarkerFaceColor = 'flat'
    c = colorbar;
    c.Label.String = 'RKI 7-Tage-R Wert';
    caxis([0 2])
    end
end
if (exist('publish_figure_on_schwenk_elektronik')==2)
save_covid_diagrams(9,['CovidDynamik_' num2str(clx,1)])
end
end % cls
if (exist('publish_figure_on_schwenk_elektronik')==2)
xlim([-1 ceil(max(xl)/100)*33]);
ylim([-0.05 topy/3]);
save_covid_diagrams(9,['CovidDynamik_3'])
end
xlim([-10 ceil(max(xl)/100)*100]);
ylim([-0.5 topy]);
if (exist('publish_figure_on_schwenk_elektronik')==2)
publish_existing_schwenk_elektronik
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
