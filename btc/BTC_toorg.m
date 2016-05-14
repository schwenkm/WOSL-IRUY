function tiles = BTC_toorg(tiles)
% move up and left
for d = 1:size(tiles,3)
while (sum(tiles(1,:,d)) == 0)
    tiles(1:4,:,d) = tiles(2:5,:,d);
    tiles(5,:,d) = 0;
end
while (sum(tiles(:,1,d)) == 0)
    tiles(:,1:4,d) = tiles(:,2:5,d);
    tiles(:,5,d) = 0;
end
end
