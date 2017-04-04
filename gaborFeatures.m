function featureVector = gaborFeatures(img,gaborArray)




img = double(img);

[u,v] = size(gaborArray);
gaborResult = cell(u,v);
for i = 1:u
    for j = 1:v
        gaborResult{i,j} = imfilter(img, (gaborArray{i,j}));
    end
end

featureVector = zeros(u*v*2,1);
k = 1;
for i = 1:u
    for j = 1:v
        
        gaborAbs = abs(gaborResult{i,j});

        gaborAbs = gaborAbs(:);
        
        %gaborAbs = (gaborAbs-mean(gaborAbs))/std(gaborAbs,1);
        
        featureVector((k-1)*2+1:k*2) =  [mean(gaborAbs);var(gaborAbs)];
        k = k +1;
    end
end

