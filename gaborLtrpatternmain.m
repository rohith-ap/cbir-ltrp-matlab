imageList = [1:13 15:112]';
featureVectors = zeros(111,25,3*8*2);
%featureVectors = single(featureVectors);
 gaborArray = gaborFilterBank(3,8,39,39);
for i =1: size(imageList,1)
    %featureVector = zeros(25,);
    parfor j = 1 : 25
    filename = strcat('images/block/D',num2str(imageList(i)),'_',num2str(j),'.gif');
    
    img = imread(filename);
     gaborfeature = gaborFeatures(img,gaborArray);
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
    featureVectors(i,j,:) = gLtrfeature;
     %}
     %{
     gaborfeaturemean = gaborfeature(1:2:size(gaborfeature,1));
     gaborfeaturemean = reshape(gaborfeaturemean,[3 8]);
     gaborfeaturesigma = gaborfeature(2:2:size(gaborfeature,1));
     gaborfeaturesigma = reshape(gaborfeaturesigma,[3 8]);
    gaborfeaturemean = fft2(gaborfeaturemean);
    gaborfeaturesigma = fft2(gaborfeaturesigma);
     gaborfeaturemean = abs(gaborfeaturemean);
    gaborfeaturesigma = abs(gaborfeaturesigma);
     featureVectors(i,j,:) = [gaborfeaturemean(:);gaborfeaturesigma(:)];
    %}
     featureVectors(i,j,:) = gaborfeature;
    end
    %featureVectors = [featureVectors featureVector];
end