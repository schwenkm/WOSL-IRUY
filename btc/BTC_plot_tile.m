function BTC_plot_solution(tiles,parent)
h = gcf;
hold all;
set(h,'visible','off')


m = ceil(sqrt(size(tiles,3)));
sx = size(tiles,1)+1;sy = size(tiles,2)+1;
for d = 1:size(tiles,3)

if nargin>=2
acol = BTC_get_color(parent(d));
else
acol = BTC_get_color(1);    
end

recx = [0.1 0.9 0.9 0.1]; recy=[0.1 0.1 0.9 0.9];

dx = 0;%mod(d-1,m);
dy = 0;%floor((d-1)/m);
[y,x]=find(tiles(:,:,d));

Rx = repmat(recx,numel(x),1)'; Ry = repmat(recy,numel(x),1)';
X  = repmat(x,1,numel(recx))';Y  = repmat(y,1,numel(recx))';
X = X + Rx; Y = Y + Ry;
%hplot('t',dx*sx+x,dy*sy+y,'ks','MarkerSize',5,'MarkerFaceColor',acol);
patch(dx*sx+X,dy*sy+Y,acol);
%plot(dx*sx+x,dy*sy+y,'ks','MarkerSize',5,'MarkerFaceColor',acol,'MarkerEdgeColor','none');
[y,x]=find(tiles(:,:,d)==0);
%hplot('t',dx*sx+x,dy*sy+y,'ks','MarkerSize',5,'MarkerFaceColor','w');   
%plot(dx*sx+x,dy*sy+y,'ks','MarkerSize',2,'MarkerFaceColor',[0.9 0.9 0.9],'MarkerEdgeColor','none'); 
recx = [0.1 0.9 0.9 0.1]; recy=[0.1 0.1 0.9 0.9];
Rx = repmat(recx,numel(x),1)'; Ry = repmat(recy,numel(x),1)';
X  = repmat(x,1,numel(recx))';Y  = repmat(y,1,numel(recx))';
X = X + Rx; Y = Y + Ry;
patch(dx*sx+X,dy*sy+Y,[0.95 0.95 0.95],'EdgeColor','none');

end

set(h,'visible','on')
end
