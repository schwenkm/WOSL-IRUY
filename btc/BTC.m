t      = BTC_tiles;
[p,pa] = BTC_permute(t);
o      = BTC_toorg(p);
[u,pu] = BTC_remdoub(o,pa);

h=nplot('all tiles');
BTC_plot_tile(u,pu);

%% plot selected
sel = (pu == 2);
h=nplot('tiles sel pu');
BTC_plot_tile(u(:,:,sel),pu(sel));

%% plot icons per parent
for psel = 1:12
    h=nplot(['icons, p=' num2str(psel)]);
    sel = (pu == psel);
    [ic,pic] = BTC_icon(u(:,:,sel),pu(sel));
    BTC_plot_tile(ic,pic);
end

%% all icons
h=nplot('icons, all');
sel = (pu > 0 );
tic
[ic,pic] = BTC_icon(u(:,:,sel),pu(sel));
toc
BTC_plot_tile(ic,pic);
numel(pic)
%% remove impossible
h=nplot('icons, impossible removed');
sel=(pic > 0 );
[icr, picr] = BTC_remimpo(ic(:,:,sel),pic(sel));
BTC_plot_tile(icr,picr);
numel(picr) 
%% select corner 1
mask = zeros(8,8);mask(1:2,1:2)=1;
mask = repmat(mask,1,1,size(icr,3));
match = icr & mask;
match = any(any(match));
sel = match(:);
h=nplot('icons, corner');
BTC_plot_tile(icr(:,:,sel),picr(sel));
numel(picr(sel))    
%%
