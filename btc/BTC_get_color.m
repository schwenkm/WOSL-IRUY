function acolor = BTC_get_color(parent)

cm=colormap('hsv');
acolor=cm(1+mod(parent*15,size(cm,1)),:);

end