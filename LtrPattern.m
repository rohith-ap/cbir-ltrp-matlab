function [featurevector] = LtrPattern(img)

uniPattern = [0, 1, 2, 3, 4, 6, 7, 8, 12, 14, 15, 16, 24,...
			28, 30, 31, 32, 48, 56, 60, 62, 63, 64, 96, 112, 120, 124, 126,...
			127, 128, 129, 131, 135, 143, 159, 191, 192, 193, 195, 199, 207,...
			223, 224, 225, 227, 231, 239, 240, 241, 243, 247, 248, 249, 251,...
252, 253, 254, 255 ]' +1;
isuniform = zeros(256,1);
isuniform(uniPattern) = 1;
%img = imread(filename);
img = padarray(img,[1 1],'replicate');
img = double(img);
img(1,:) = 2*img(3,:) - img(2,:);
img(size(img,1),:) = 2*img(size(img,1) -1,:) - img(size(img,1) -2,:);
img(:,1) = 2*img(:,2) - img(:,3);
img(:,size(img,2)) = 2*img(:,size(img,2) -1) - img(:,size(img,2) -2);
img(img < 0) = 0;
img(img > 255) = 255;
img(1,1) = (img(1,2) + img(2,1))/2;
img(1,size(img,2)) = (img(1,size(img,2) -1) + img(2,size(img,2)))/2;
img(size(img,1),1) = (img(size(img,1)-1,1) + img(size(img,1),2))/2;
img(size(img,1),size(img,2)) = (img(size(img,1)-1,size(img,2)) + img(size(img,1),size(img,2)-1))/2;

% first order derivative of image.

h  = [img(:,2:size(img,2)) zeros(size(img,1),1)] - img;
v = img - [img(2:size(img,1),:);zeros(1,size(img,2))] ;
gradcode = zeros(size(img));
magn = h.*h + v.*v;
h = sign(h);
h(h==0) =1;
v = sign(v);
v(v==0) =1;
gradcode(h>v) = 4;
gradcode(h<v) = 2;
gradcode(h==v & h>0) =1;
gradcode(h==v & h<=0) =3;
gradcode(1,:) = [[img(1,2:size(img,2)) 0] <= img(1,:)] +1;
magn(1,:) = [[img(1,2:size(img,2)) 0] - img(1,:)].^2;

gradcode(1,size(gradcode,2)) = 1;
magn(1,size(magn,2)) = 0;

gradcode(:,size(gradcode,2)) = [[img(2:size(img,1),size(img,2));0] > img(:,size(img,2))];
gradcode(gradcode == 0) = 4;
magn(:,size(magn,2)) = [[img(2:size(img,1),size(img,2));0] - img(:,size(img,2))].^2;

histogram = zeros(13,59);
for i = 2 : size(img,1) - 1
    for j = 2 : size(img,2) - 2
        trpattern = zeros(8,1);
        binpattern = zeros(3,1);
        binpattern = uint16(binpattern);
        if gradcode(i,j) ~= gradcode(i,j+1)
            trpattern(1) = gradcode(i,j+1);
        end
        if gradcode(i,j) ~= gradcode(i-1,j+1)
            trpattern(2) = gradcode(i-1,j+1);
        end
        if gradcode(i,j) ~= gradcode(i-1,j)
            trpattern(3) = gradcode(i-1,j);    
        end
        if gradcode(i,j) ~= gradcode(i-1,j-1)
            trpattern(4) = gradcode(i-1,j-1);
        end
        if gradcode(i,j) ~= gradcode(i,j-1)
            trpattern(5) = gradcode(i,j-1);
        end
        if gradcode(i,j) ~= gradcode(i+1,j-1)
            trpattern(6) = gradcode(i+1,j-1);
        end
        if gradcode(i,j) ~= gradcode(i+1,j)
            trpattern(7) = gradcode(i+1,j);
        end
        if gradcode(i,j) ~= gradcode(i+1,j+1)
            trpattern(8) = gradcode(i+1,j+1);
        end
       
        for k = 1 : 8
            idx = 1;
            for l = 1 : 4
                if l ~= gradcode(i,j)
                    f = (trpattern(k) == l);
                    if f ==1
                        binpattern(idx) = (2^(k-1) + binpattern(idx));
                    end
                    idx = idx +1;
                end
            end
        end
        binpattern = binpattern + 1;
        for t = 1 : 3
            idxuniform = find(uniPattern==binpattern(t));
            
            if (size(idxuniform,1) ~=0)
                histogram((gradcode(i,j)-1)*3+t,idxuniform) = histogram((gradcode(i,j)-1)*3+t,idxuniform) + 1;
            else
                histogram((gradcode(i,j)-1)*3+t,59) = histogram((gradcode(i,j)-1)*3+t,59) + 1;
            end
        end
    end
end

for i = 2 : size(img,1) - 1
    for j = 2 : size(img,2) - 2
        magpattern = zeros(8,1);
        pattern = 0;
        pattern = uint16(pattern);
        magpattern(1) = magn(i,j) <= magn(i,j+1);
        magpattern(2) = magn(i,j) <= magn(i-1,j+1);
        magpattern(3) = magn(i,j) <= magn(i-1,j);
        magpattern(4) = magn(i,j) <= magn(i-1,j-1);
        magpattern(5) = magn(i,j) <= magn(i,j-1);
        magpattern(6) = magn(i,j) <= magn(i+1,j-1);
        magpattern(7) = magn(i,j) <= magn(i+1,j);
        magpattern(8) = magn(i,j) <= magn(i+1,j+1);
        
        
       
        for k = 1 : 8
            f = (magpattern(k) == 1);
            if f == 1
                pattern = (2^(k-1) + pattern);
            end             
        end
        pattern = pattern + 1;
            idxuniform = find(uniPattern==pattern);
            
            if (size(idxuniform,1) ~=0)
                histogram(13,idxuniform) = histogram(13,idxuniform) + 1;
            else
                histogram(13,59) = histogram(13,59) + 1;
            end
        
    end
end
featurevector = histogram(:)/((size(img,1)-1)*(size(img,2)-1));
end