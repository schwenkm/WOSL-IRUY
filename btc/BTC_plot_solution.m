function BTC_plot_solution(alltiles,allparents,apalist)
h = gcf;
hold all;
set(h,'visible','off')

for ns = 1:numel(apalist)

    tiles = alltiles(:,:,apalist{ns});
    parent = allparents(apalist{ns});
    
    m = ceil(sqrt(numel(apalist)));
    sx = size(tiles,1)+1;sy = size(tiles,2)+1;
    dx = mod(ns-1,m);
    dy = floor((ns-1)/m);

    board = ones(size(tiles,1),size(tiles,1));board(4:5,4:5) = 0;
    [y,x]=find(board);
    recx = [0.1 0.9 0.9 0.1]; recy=[0.1 0.1 0.9 0.9];
    Rx = repmat(recx,numel(x),1)'; Ry = repmat(recy,numel(x),1)';
    X  = repmat(x,1,numel(recx))';Y  = repmat(y,1,numel(recx))';
    X = X + Rx; Y = Y + Ry;
    patch(dx*sx+X,dy*sy+Y,[0.95 0.95 0.95],'EdgeColor','none');

    for d = 1:size(tiles,3)
        acol = BTC_get_color(parent(d));
        recx = [0.1 0.9 0.9 0.1]; recy=[0.1 0.1 0.9 0.9];
        [y,x]=find(tiles(:,:,d));
        Rx = repmat(recx,numel(x),1)'; Ry = repmat(recy,numel(x),1)';
        X  = repmat(x,1,numel(recx))';Y  = repmat(y,1,numel(recx))';
        X = X + Rx; Y = Y + Ry;
        patch(dx*sx+X,dy*sy+Y,acol);
    end    
    
end

set(h,'visible','on')
end
