function [tilesp parent] = BTC_permute(tiles)
pidx = 1;
SKIP_PERMUTE = 8; % onyl one orientation, removing doublicates by mirroring and rotation

for i = 1:size(tiles,3)
    if i == SKIP_PERMUTE
            tilesp(:,:,pidx) = tiles(:,:,i);
            parent(pidx) = i;pidx = pidx+1;
    else
        for k = 0:3
            tilesp(:,:,pidx) = rot90(       tiles(:,:,i) ,k);
            parent(pidx) = i;pidx = pidx+1;
            tilesp(:,:,pidx) = rot90(flipud(tiles(:,:,i)),k);
            parent(pidx) = i;pidx = pidx+1;
        end
        end
end
