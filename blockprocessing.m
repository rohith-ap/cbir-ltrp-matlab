for i = 15 : 112
    img = imread(strcat('images/D',num2str(i),'.gif'));
    img = imresize(img,[640 640]);
    rows = 640;
    columns = 640;
    blockSizeR = 128; % Rows in block.
    blockSizeC = 128; % Columns in block.
% Figure out the size of each block.
    wholeBlockRows = floor(rows / blockSizeR);
    wholeBlockCols = floor(columns / blockSizeC);
% Now scan though, getting each block and putting it as a slice of a 3D array.
    sliceNumber = 1;
    for row = 1 : blockSizeR : rows
        for col = 1 : blockSizeC : columns
        % Let's be a little explicit here in our variables
        % to make it easier to see what's going on.
        % Determine starting and ending rows.
        row1 = row;
        row2 = row1 + blockSizeR - 1;
        row2 = min(rows, row2); % Don't let it go outside the image.
        % Determine starting and ending columns.
        col1 = col;
        col2 = col1 + blockSizeC - 1;
        col2 = min(columns, col2); % Don't let it go outside the image.
        % Extract out the block into a single subimage.
        oneBlock = img(row1:row2, col1:col2);
        % Specify the location for display of the image.
        
        imwrite(oneBlock,strcat('images/block/D',num2str(i),'_',num2str(sliceNumber),'.gif'));
        
        sliceNumber = sliceNumber + 1;
        end
    end
end