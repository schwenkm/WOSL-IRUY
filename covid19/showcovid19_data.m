function CovidData = showcovid19_data()
%%
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
            'Germany','29-Apr-2020','Maskenpflicht beim Einkaufen, ÖPNV','-';...
            'Germany', '4-May-2020','teilweise Schulbetrieb, Friseure öffnen','+';...
            'Germany','15-May-2020','Sport im Freien','+';...
            'Germany','1-Jun-2020' ,'BW: Veranstaltungen bis 100 Gäste','+';...
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
%% population
T = import_population();
%% align
cnt = 0;
clear COV;

COV.raw.time = ti;
for pp = 1:numel(cntry)
    if (pp>numel(region)) region{pp}='';end
    if isempty(region{pp})
        i1     = pp;    
        i1_rec = find(strcmp(cntry_rec,cntry{pp}),1);
        i1_dea = find(strcmp(cntry_dea,cntry{pp}),1);  
        if (~isempty(i1)) & (~isempty(i1_rec)) & (~isempty(i1_dea))
            cnt = cnt +1;
            COV.country{cnt,1} = cntry{pp};
            COV.raw.cases(cnt,:) = cases(i1,:);
            COV.raw.recovered(cnt,:) = recovered(i1_rec,:);
            COV.raw.death(cnt,:) = death(i1_dea,:);
            COV.population(cnt,1) = showcovid19_getpopulation(T, cntry{pp});
        end
    end
end
% derived values
COV.raw.active = COV.raw.cases - COV.raw.recovered - COV.raw.death;
COV.raw.increase = [zeros(size(COV.raw.cases,1),1) diff(COV.raw.cases,[],2)];
% normed
popNorm = repmat(COV.population,1,size(COV.raw.cases,2)) / 100000;
COV.per100k.time =      COV.raw.time;
COV.per100k.cases =     COV.raw.cases ./ popNorm;
COV.per100k.recovered = COV.raw.recovered ./ popNorm;
COV.per100k.death =     COV.raw.death ./ popNorm;
COV.per100k.active =    COV.raw.active ./ popNorm;
COV.per100k.increase =  COV.raw.increase ./ popNorm;

% filtered
filtercoef=[1 1 1 1 1 1 1]/7;
COV.filtered.time =      COV.raw.time;
COV.filtered.cases =     filtfilt(filtercoef,1,COV.raw.cases')';
COV.filtered.recovered = filtfilt(filtercoef,1,COV.raw.recovered')';
COV.filtered.death =     filtfilt(filtercoef,1,COV.raw.death')';
COV.filtered.active =    filtfilt(filtercoef,1,COV.raw.active')';
COV.filtered.increase =  [zeros(size(COV.filtered.cases,1),1) diff(COV.filtered.cases,[],2)];
% filtered, normed
COV.filtered_per100k.time =      COV.raw.time;
COV.filtered_per100k.cases =     COV.filtered.cases    ./ popNorm;
COV.filtered_per100k.recovered = COV.filtered.recovered./ popNorm;
COV.filtered_per100k.death =     COV.filtered.death     ./ popNorm;
COV.filtered_per100k.active =    COV.filtered.active    ./ popNorm;
COV.filtered_per100k.increase =  [zeros(size(COV.filtered_per100k.cases,1),1) diff(COV.filtered_per100k.cases,[],2)];   
% meassures

COV.meassures = Measures;
%
CovidData = COV;
end

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
