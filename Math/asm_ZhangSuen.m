function res = asm_ZhangSuen(im)

res = im;
prev = zeros(size(im));
while any(any(prev ~= res))
    prev = res;
    res1 = l_getTest(prev, 1);
    res = l_getTest(res1, 2);
end

end

%--------------------------------------------------------------------------
function black = l_getBlackNeigh(im)

sz = size(im);
imsum = zeros(sz+2);

for x = 0:2
    for y = 0:2
       if x == 1 && y == 1
           continue
       end
       imsum(x+(1:sz(1)), y+(1:sz(2))) = imsum(x+(1:sz(1)), y+(1:sz(2))) + im;
    end
end

black = imsum(2:end-1, 2:end-1);

end

%--------------------------------------------------------------------------
function trans = l_getBWTrans(im)

sz = size(im);
imt = zeros(sz(1)+2, sz(2)+2, 9);

xseq = [2 2 1 0 0 0 1 2 2];
yseq = [1 2 2 2 1 0 0 0 1];

for k = 1:length(xseq)
    imt(xseq(k)+(1:sz(1)),yseq(k)+(1:sz(2)),k) = im;
end

d = imt(2:end-1, 2:end-1, 1:end-1) - imt(2:end-1, 2:end-1, 2:end);
d(d < 0) = 0;

trans = sum(d, 3);

end

%--------------------------------------------------------------------------
function res = l_getTest(im, n)

sz = size(im);
black = l_getBlackNeigh(im);
trans = l_getBWTrans(im);

p2 = zeros(sz);
p2(2:end, :) = im(1:end-1, :);
p8 = zeros(sz);
p8(:, 2:end) = im(:, 1:end-1);
p6 = zeros(sz);
p6(1:end-1, :) = im(2:end, :);
p4 = zeros(sz);
p4(:, 1:end-1) = im(:, 2:end);

test = im & (2 <= black & black <= 6) & trans == 1;
if n == 1
    test = test & (p2 == 0 | p4 == 0 | p6 == 0);
    test = test & (p4 == 0 | p6 == 0 | p8 == 0);
else
    test = test & (p2 == 0 | p4 == 0 | p8 == 0);
    test = test & (p2 == 0 | p6 == 0 | p8 == 0);
end

res = im;
res(test) = 0;

end

% 
% int zhangSuenTest1(int row,int col){
% 	int neighbours = getBlackNeighbours(row,col);
% 	
% 	return ((neighbours>=2 && neighbours<=6) 
% 		&& (getBWTransitions(row,col)==1) 
% 		&& (imageMatrix[row-1][col]==blankPixel||imageMatrix[row][col+1]==blankPixel||imageMatrix[row+1][col]==blankPixel) 
% 		&& (imageMatrix[row][col+1]==blankPixel||imageMatrix[row+1][col]==blankPixel||imageMatrix[row][col-1]==blankPixel));
% }
% 
% int zhangSuenTest2(int row,int col){
% 	int neighbours = getBlackNeighbours(row,col);
% 	
% 	return ((neighbours>=2 && neighbours<=6) 
% 		&& (getBWTransitions(row,col)==1) 
% 		&& (imageMatrix[row-1][col]==blankPixel||imageMatrix[row][col+1]==blankPixel||imageMatrix[row][col-1]==blankPixel) 
% 		&& (imageMatrix[row-1][col]==blankPixel||imageMatrix[row+1][col]==blankPixel||imageMatrix[row][col+1]==blankPixel));
% }
% 
% void zhangSuen(char* inputFile, char* outputFile){
% 	
% 	int startRow = 1,startCol = 1,endRow,endCol,i,j,count,rows,cols,processed;
% 	
% 	pixel* markers;
% 	
% 	FILE* inputP = fopen(inputFile,"r");
% 	
% 	fscanf(inputP,"%d%d",&rows,&cols);
% 	
% 	fscanf(inputP,"%d%d",&blankPixel,&imagePixel);
% 	
% 	blankPixel<=9?blankPixel+='0':blankPixel;
% 	imagePixel<=9?imagePixel+='0':imagePixel;
% 	
% 	printf("\nPrinting original image :\n");
% 	
% 	imageMatrix = (char**)malloc(rows*sizeof(char*));
% 	
% 	for(i=0;i<rows;i++){
% 		imageMatrix[i] = (char*)malloc((cols+1)*sizeof(char));
% 		fscanf(inputP,"%s\n",imageMatrix[i]);
% 		printf("\n%s",imageMatrix[i]);
% 		
% 	}
% 
% 	fclose(inputP);
% 	
% 	endRow = rows-2;
% 	endCol = cols-2;
% 	do{
% 		markers = (pixel*)malloc((endRow-startRow+1)*(endCol-startCol+1)*sizeof(pixel));
% 		count = 0;
% 		
% 		for(i=startRow;i<=endRow;i++){
% 			for(j=startCol;j<=endCol;j++){
% 				if(imageMatrix[i][j]==imagePixel && zhangSuenTest1(i,j)==1){
% 					markers[count].row = i;
% 					markers[count].col = j;
% 					count++;
% 				}
% 			}
% 		}
% 		
% 		processed = (count>0);
% 		
% 		for(i=0;i<count;i++){
% 			imageMatrix[markers[i].row][markers[i].col] = blankPixel;
% 		}
% 		
% 		free(markers);
% 		markers = (pixel*)malloc((endRow-startRow+1)*(endCol-startCol+1)*sizeof(pixel));
% 		count = 0;
% 		
% 		for(i=startRow;i<=endRow;i++){
% 			for(j=startCol;j<=endCol;j++){
% 				if(imageMatrix[i][j]==imagePixel && zhangSuenTest2(i,j)==1){
% 					markers[count].row = i;
% 					markers[count].col = j;
% 					count++;
% 				}
% 			}
% 		}
% 		
% 		if(processed==0)
% 			processed = (count>0);
% 		
% 		for(i=0;i<count;i++){
% 			imageMatrix[markers[i].row][markers[i].col] = blankPixel;
% 		}
% 		
% 		free(markers);
% 	}while(processed==1);
% 	
% 	FILE* outputP = fopen(outputFile,"w");
% 	
% 	printf("\n\n\nPrinting image after applying Zhang Suen Thinning Algorithm : \n\n\n");
% 	
% 	for(i=0;i<rows;i++){
% 		for(j=0;j<cols;j++){
% 			printf("%c",imageMatrix[i][j]);
% 			fprintf(outputP,"%c",imageMatrix[i][j]);
% 		}
% 		printf("\n");
% 		fprintf(outputP,"\n");
% 	}
% 	
% 	fclose(outputP);
% 	
% 	printf("\nImage also written to : %s",outputFile);
% }
% 
% int main()
% {
% 	char inputFile[100],outputFile[100];
% 	
% 	printf("Enter full path of input image file : ");
% 	scanf("%s",inputFile);
% 	
% 	printf("Enter full path of output image file : ");
% 	scanf("%s",outputFile);
% 	
% 	zhangSuen(inputFile,outputFile);
% 	
% 	return 0;
% }
