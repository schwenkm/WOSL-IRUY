if 0
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

mask_c1 = zeros(8,8);mask_c1(1:2,1:2)=1;
mask_c1d = repmat(mask_c1,1,1,size(icr,3));
match = icr & mask_c1d;
match = any(any(match));
c1_sel = match(:);
c1_idxsel = find(c1_sel);
h=nplot('icons, corner');
BTC_plot_tile(icr(:,:,c1_sel),picr(c1_sel));
numel(picr(c1_sel))    
%%
end

test1 = zeros(8,8);
corner1 = [];
palist =[];
testpalist = [];
k = 0;

for idx1 = c1_idxsel'
    test1 = icr(:,:,idx1);
    testpalist1 = idx1;
    if all(all((test1 & mask_c1) == mask_c1))
        k = k + 1;
        palist{k} = testpalist;
        corner(:,:,k) = test1;
    else
        % remove same parents and overlapping from c1 set -> c1b
        mask = repmat(icr(:,:,idx1),1,1,size(icr,3));
        match_pa = picr == picr(idx1);
        match_ov = any(any(icr & mask));
        c1_sel_2 = c1_sel & ~(match_ov(:) | match_pa');
        c1_idxsel_2 = find(c1_sel_2);
        numel(c1_idxsel_2);

        for idx2 = c1_idxsel_2'
            test2 = test1 + icr(:,:,idx2);
            testpalist2 = [testpalist1 idx2];
            if all(all((test2 & mask_c1) == mask_c1))
                k = k + 1;
                palist{k} = testpalist2;
                corner(:,:,k) = test2;
            else
                % remove same parents and overlapping from c1 set -> c1b
                mask = repmat(icr(:,:,idx2),1,1,size(icr,3));
                match_pa = picr == picr(idx2);
                match_ov = any(any(icr & mask));
                c1_sel_3 = c1_sel_2 & ~(match_ov(:) | match_pa');
                c1_idxsel_3 = find(c1_sel_3);
                numel(c1_idxsel_3);
                
                for idx3 = c1_idxsel_3'
                    test3 = test2 + icr(:,:,idx3);
                    testpalist3 = [testpalist2 idx3];
                    if all(all((test3 & mask_c1) == mask_c1))
                        k = k + 1;
                        palist{k} = testpalist3;
                        corner(:,:,k) = test3;
                    else
                        %% has holes
                    end
                end
            end
        end
    end
end


%%

h=nplot('solution corner c1');

BTC_plot_solution(icr,picr,palist(1:1000));





