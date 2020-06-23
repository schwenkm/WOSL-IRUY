%%
CD = showcovid19_data;
N=numel(CD.population);
%%
CD.meassures

fid = fopen('test country.txt','w+')
for pp = 1:N
fprintf(fid,'%s\t%d\n',CD.country{pp},CD.population(pp));
end
fclose(fid);
%%
sel = find(strcmp(CD.country,'Germany'));
nplot('cases',CD.raw.time,CD.raw.cases)
hplot('cases',CD.raw.time,CD.raw.cases(sel,:),'r*')
nplot('cases f',CD.filtered.time,CD.filtered.cases)
hplot('cases f',CD.filtered.time,CD.filtered.cases(sel,:),'r*')
nplot('cases 100',CD.filtered.time,CD.per100k.cases)
hplot('cases 100',CD.filtered.time,CD.per100k.cases(sel,:),'r*')
nplot('cases 100f',CD.filtered.time,CD.filtered_per100k.cases)
hplot('cases 100f',CD.filtered.time,CD.filtered_per100k.cases(sel,:),'r*')
%%
nplot('recovered',CD.raw.time,CD.raw.recovered)
hplot('recovered',CD.raw.time,CD.raw.recovered(sel,:),'r*')
nplot('recovered f',CD.filtered.time,CD.filtered.recovered)
hplot('recovered f',CD.filtered.time,CD.filtered.recovered(sel,:),'r*')
nplot('recovered 100',CD.filtered.time,CD.per100k.recovered)
hplot('recovered 100',CD.filtered.time,CD.per100k.recovered(sel,:),'r*')
nplot('recovered 100f',CD.filtered.time,CD.filtered_per100k.recovered)
hplot('recovered 100f',CD.filtered.time,CD.filtered_per100k.recovered(sel,:),'r*')
%%
nplot('death',CD.raw.time,CD.raw.death)
hplot('death',CD.raw.time,CD.raw.death(sel,:),'r*')
nplot('death f',CD.filtered.time,CD.filtered.death)
hplot('death f',CD.filtered.time,CD.filtered.death(sel,:),'r*')
nplot('death 100',CD.filtered.time,CD.per100k.death)
hplot('death 100',CD.filtered.time,CD.per100k.death(sel,:),'r*')
nplot('death 100f',CD.filtered.time,CD.filtered_per100k.death)
hplot('death 100f',CD.filtered.time,CD.filtered_per100k.death(sel,:),'r*')
%%
nplot('active',CD.raw.time,CD.raw.active)
hplot('active',CD.raw.time,CD.raw.active(sel,:),'r*')
nplot('active f',CD.filtered.time,CD.filtered.active)
hplot('active f',CD.filtered.time,CD.filtered.active(sel,:),'r*')
nplot('active 100',CD.filtered.time,CD.per100k.active)
hplot('active 100',CD.filtered.time,CD.per100k.active(sel,:),'r*')
nplot('active 100f',CD.filtered.time,CD.filtered_per100k.active)
hplot('active 100f',CD.filtered.time,CD.filtered_per100k.active(sel,:),'r*')
%%
nplot('increase',CD.raw.time,CD.raw.increase)
hplot('increase',CD.raw.time,CD.raw.increase(sel,:),'r*')
nplot('increase f',CD.filtered.time,CD.filtered.increase)
hplot('increase f',CD.filtered.time,CD.filtered.increase(sel,:),'r*')
nplot('increase 100',CD.filtered.time,CD.per100k.increase)
hplot('increase 100',CD.filtered.time,CD.per100k.increase(sel,:),'r*')
nplot('increase 100f',CD.filtered.time,CD.filtered_per100k.increase)
hplot('increase 100f',CD.filtered.time,CD.filtered_per100k.increase(sel,:),'r*')
%%
nplot('inc vs act',CD.filtered_per100k.active',CD.filtered_per100k.increase','k-')
hplot('inc vs act',CD.filtered_per100k.active(sel,:)',CD.filtered_per100k.increase(sel,:)','r*')
%%
for sel = 1:N
    nplot('ivsa',CD.filtered_per100k.active(sel,:)',CD.filtered_per100k.increase(sel,:)','k-')
    title([CD.country{sel} ' increase vs active']);
loacal_path = 'D:\temp\CovidBilder';
fname = CD.country{sel};
fname = replace(fname,{' ','*',',','.'},'_');
fig_filename_png = fullfile(loacal_path, [ fname '.png']);
saveas(gcf,fig_filename_png);
end


