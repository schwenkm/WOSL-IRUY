%%
%previous url: url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv';
url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv';
url_rec = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv';

dwn_filename = 'd:\temp\websave\c.csv';
dwn_filename_rec = 'd:\temp\websave\cr.csv';
dwn_filename = websave(dwn_filename,url);
dwn_filename_rec = websave(dwn_filename_rec,url_rec);

PopCntryList = {'Germany','France total','Italy','China total','Spain','Norway','Sweden','Korea, South','US total'};
PopCountList = [    80         67           6         1400       50       5.4     10.2       51.2           327] * 1e6;
%%
A       = readtable(dwn_filename);
ti      = datetime(A{1,5:end},'InputFormat','MM/dd/yy');
cntry   = A{2:end,2};
state   = A{2:end,1};
cases   = str2double(A{2:end,5:end});
%%
A_rec       = readtable(dwn_filename_rec);
ti_rec      = datetime(A_rec{1,5:end},'InputFormat','MM/dd/yy');
cntry_rec   = A_rec{2:end,2};
state_rec   = A_rec{2:end,1};
recovered   = str2double(A_rec{2:end,5:end});
%%
assert(all(ti==ti_rec))

%% collect states
[cntry, cases] = collect_states(cntry,cases,'US');
[cntry, cases] = collect_states(cntry,cases,'France');
[cntry, cases] = collect_states(cntry,cases,'China');
[cntry_rec, recovered] = collect_states(cntry_rec,recovered,'US');
[cntry_rec, recovered] = collect_states(cntry_rec,recovered,'France');
[cntry_rec, recovered] = collect_states(cntry_rec,recovered,'China');
%%

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
    active = cases(i1,:) - recovered(i1_rec,:);
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
CList ={'Germany','France total','Italy','China total','Spain','US total'};
figure(7), hold off
cnt = 0;Legend=[];
for pp = 1:numel(CList)
    cnt = cnt+1;
    i1     = find(strcmp(cntry,CList{pp}),1);
    i1_rec = find(strcmp(cntry_rec,CList{pp}),1);
    active = cases(i1,:) - recovered(i1_rec,:);
    increase = diff(cases(i1,:));
    active = active(2:end);
    increase_f = filtfilt([0.5 1 1 1 1 1 0.5]/7,1,increase);
    active_f = filtfilt([0.5 1 1 1 1 1 0.5]/7,1,active);
    plot(active_f,increase_f,'.-');
    Legend{cnt}=cntry{i1};
    grid on
    hold all
end
legend(Legend);
%set(gca,'YScale','log')
%set(gca,'XScale','log')
title({'increase vs active','1 week average'})
xlabel('active')
ylabel('increase')
%% active cases vs increase normed to population size (phase state diagram)
CList ={'Germany','France total','Italy','China total','Spain','US total'};
figure(8), hold off
cnt = 0;Legend=[];
for pp = 1:numel(CList)
    cnt = cnt+1;
    norm_idx = find(strcmp(PopCntryList,CList{pp}),1);
    i1     = find(strcmp(cntry,CList{pp}),1);    
    i1_rec = find(strcmp(cntry_rec,CList{pp}),1);
    active = cases(i1,:) - recovered(i1_rec,:);
    increase = diff(cases(i1,:));
    active = active(2:end);
    increase_f = filtfilt([0.5 1 1 1 1 1 0.5]/7,1,increase);
    active_f = filtfilt([0.5 1 1 1 1 1 0.5]/7,1,active);
    increase_n = increase_f / PopCountList(norm_idx) * 100000;
    active_n = active_f / PopCountList(norm_idx) * 100000;
    plot(active_n,increase_n,'.-');
    Legend{cnt}=cntry{i1};
    grid on
    hold all
end
legend(Legend);
%set(gca,'YScale','log')
%set(gca,'XScale','log')
title({'increase vs active per 100000','1 week average'})
xlabel('active')
ylabel('increase')


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
