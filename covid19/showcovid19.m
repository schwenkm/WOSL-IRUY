%%
%previous url: url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv';
url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv';

dwn_filename = 'c:\temp\websave\c.csv';
dwn_filename = websave(dwn_filename,url);

%%
A       = readtable(dwn_filename);
ti      = datetime(A{1,5:end},'InputFormat','MM/dd/yy');
cntry   = A{2:end,2};
state   = A{2:end,1};
cases   = str2double(A{2:end,5:end});
%% collect US
newidx = numel(cntry) +1;
collectCntry = 'US';
icoll = find(strcmp(cntry,collectCntry));
cntry{newidx} = [collectCntry ' total'];
cases(newidx,:) = 0;
for pp = icoll'     cases(newidx,:) = cases(newidx,:) + cases(pp,:); end
%% collect France
newidx = numel(cntry) +1;
collectCntry = 'France';
icoll = find(strcmp(cntry,collectCntry));
cntry{newidx} = [collectCntry ' total'];
cases(newidx,:) = 0;
for pp = icoll'     cases(newidx,:) = cases(newidx,:) + cases(pp,:); end
%% collect China
newidx = numel(cntry) +1;
collectCntry = 'China';
icoll = find(strcmp(cntry,collectCntry));
cntry{newidx} = [collectCntry ' total'];
cases(newidx,:) = 0;
for pp = icoll'     cases(newidx,:) = cases(newidx,:) + cases(pp,:); end

%%
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
set(gca,'YScale','log')
xlabel('date')
ylabel('confirmed cases')

%%
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
%%
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



