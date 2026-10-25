function [val, pos] = ts_pics(x, seuil, dmin)
x = x(:);
pos = [];
for k = 2:length(x)-1
    if x(k) > seuil && x(k) >= x(k-1) && x(k) > x(k+1)
        pos(end+1) = k;
    end
end
[~, ordre] = sort(x(pos), 'descend');
pos = pos(ordre);
garde = [];
for i = 1:length(pos)
    if all(abs(pos(i) - garde) >= dmin)
        garde(end+1) = pos(i);
    end
end
pos = sort(garde);
val = x(pos);
end