function [tilesuni,parentuni] = BTC_remdoub(tiles,parents)
idx =1;doub=[];
sel = ones(size(tiles,3),1);
for d1 = 1:(size(tiles,3)-1)
for d2 = (d1+1):size(tiles,3)
    if tiles(:,:,d1) == tiles(:,:,d2)
      sel(d1) = 0;
    end
end
end
iduni = find(sel);
tilesuni = tiles(:,:,iduni);
parentuni = parents(iduni);
end
