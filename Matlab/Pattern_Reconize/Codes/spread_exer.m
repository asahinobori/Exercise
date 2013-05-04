function spread_exer(X, label)
% 为样本集中不同类别的样本打上不同的标记
color = 'brgmcyk';
m = length(color);
c = max(label);

figure(gcf);
clf;
hold on;
for i = 1:c
    idc = label==i;
    scatter(X(1,idc),X(2,idc),36,color(mod(i-1,m)+1));
end
axis equal
grid on
hold off

end

