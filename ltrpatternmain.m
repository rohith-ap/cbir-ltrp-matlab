imageList = [1:13 15:112]';
featureVectors = zeros(111,25,767);
for i =1: size(imageList,1)
    %featureVector = zeros(25,);
    parfor j = 1 : 25
    filename = strcat('images/block/D',num2str(imageList(i)),'_',num2str(j),'.gif');
    img = imread(filename);
    featureVectors(i,j,:) = [LtrPattern(img)];
    end
    %featureVectors = [featureVectors featureVector];
end
    