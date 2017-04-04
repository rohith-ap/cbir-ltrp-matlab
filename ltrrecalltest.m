imageList = [1:13 15:112]';
precision = zeros(size(imageList,1),25);
recallLtr = zeros(size(imageList,1),25);
ng = 16;
numsimilar = 16;
for x = 1 : size(imageList,1)
    for y = 1 : 25
      filename = strcat('images/block/D',num2str(imageList(x)),'_',num2str(y),'.gif');
      dist = zeros( size(imageList,1),25);
        img = imread(filename);
        fv = LtrPattern(img);
    %{
     l = 1;
     m =1;
     gLtrfeature = zeros(3*8*767,1);
     for k = 1 : 24
        gaborimg = imresize(gaborFeature(l:size(gaborFeature,1)*k/24),[128 128]);
         gaborimg = uint8(255 * mat2gray(gaborimg));

         gLtrfeature(m:767*k) = [LtrPattern(gaborimg)];
        m = 767*k+1;
        l = size(gaborFeature,1)*k/24+1;
     end
     fv = gLtrfeature;
    %}
    %{
    gaborfeaturemean = fv(1:2:size(fv,1));
     gaborfeaturemean = reshape(gaborfeaturemean,[3 8]);
     gaborfeaturesigma = fv(2:2:size(fv,1));
     gaborfeaturesigma = reshape(gaborfeaturesigma,[3 8]);
    gaborfeaturemean = fft2(gaborfeaturemean);
    gaborfeaturesigma = fft2(gaborfeaturesigma);
     gaborfeaturemean = abs(gaborfeaturemean);
    gaborfeaturesigma = abs(gaborfeaturesigma);
     fv= [gaborfeaturemean(:);gaborfeaturesigma(:)];
    %}
        for i = 1 : size(imageList,1)
            for j = 1 : 25
            fvtest = [featureVectors(i,j,:)];
            dist(i,j) = norm((fvtest(:) - fv)./(1+fvtest(:) - fv),1);
            end
        end
        maxval = max(max(dist));
        distcomp = dist(:);
        
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
        precisionval = 0;
        %recallval = 0;
        for i = 1 : numsimilar
        if idxsimilar(1,i) == imageList(x)
            precisionval = precisionval + (ng+1 - i);
            %recallval = recallval+1;
         end
        end
        recallLtr(x,y) =precisionval/(ng*(1+ng)/2);
        precision(x,y) = precisionval/numsimilar;
        %{
        figure;
        for i = 1 : numsimilar
        subplot(5,5,i);
        filename = strcat('images/block/D',num2str(idxsimilar(1,i)),'_',num2str(idxsimilar(2,i)),'.gif');

        imshow(filename);
               if i = 1
            title('Query Image');
        else
            title(strcat('rank ',num2str(i)));
        end
        end
        %}
        
    end
end

categoryrecall = mean(recallLtr');
totallarr = mean2(recallLtr)*100;
bar([1:111],categoryrecall');
xlabel('category images');
ylabel('average recall per category');