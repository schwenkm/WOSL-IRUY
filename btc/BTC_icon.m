function [icons,parents] = BTC_icon(u,pu)

k = 0;icons=[];
for iu = 1:size(u,3)
    I = zeros(12,12);
    I(1:5,1:5) = u(:,:,iu);
    Jmask = ones(12,12);Jmask(1:8,1:8) = 0;Jmask(4:5,4:5)=1;
    for dx = 0:7
        for dy = 0:7
            J = circshift(I,[dx dy]);
            if ~any(J & Jmask)
                k=k+1;
                icons(:,:,k) = J(1:8,1:8);
                parents(k) = pu(iu);
            end
        end
    end
end

end
