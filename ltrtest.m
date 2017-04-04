imageList = [1:13 15:112]';
filename = 'images/block/D10_12.gif';
dist = zeros( size(imageList,1),25);
img = imread(filename);
fv = [LtrPattern(img)];
for i = 1 : size(imageList,1)
    for j = 1 : 25
        fvtest = [featureVectors(i,j,:)];
        dist(i,j) = norm((fvtest(:) - fv)./(1+fvtest(:) - fv),1);
    end
end
maxval = max(max(dist));
distcomp = dist(:);
numsimilar = 16;
idx = [];
val = [];
for i = 1 : numsimilar
 [val(i) idx(i)]= min((distcomp));
 distcomp(idx(i)) = maxval;
end
idxsimilar = zeros(2,numsimilar);
[idxsimilar(1,:) idxsimilar(2,:)] = ind2sub(size(dist),idx);
for i = 1 : numsimilar
    if idxsimilar(1,i) > 13
        idxsimilar(1,i) = idxsimilar(1,i) +1;
    end
end
figure;
for i = 1 : numsimilar
subplot(4,4,i);
filename = strcat('images/block/D',num2str(idxsimilar(1,i)),'_',num2str(idxsimilar(2,i)),'.gif');

imshow(filename);
       if i == 1
            title('Query Image');
        else
            title(strcat('rank ',num2str(i)));
        end
end


