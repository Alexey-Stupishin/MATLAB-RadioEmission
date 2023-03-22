function data = fitsread(varargin)
%FITSREAD Read data from FITS file
%
%   DATA = FITSREAD(FILENAME) reads data from the primary data of the FITS
%   (Flexible Image Transport System) file FILENAME.  Undefined data values
%   will be replaced by NaN.  Numeric data will be scaled by the slope and
%   intercept values and is always returned in double precision.
%
%   DATA = FITSREAD(FILENAME,OPTIONS) reads data from a FITS file according
%   to the options specified in OPTIONS.  Valid options are:
%
%   EXTNAME      EXTNAME can be either 'primary', 'asciitable', 'binarytable',
%                'image', or 'unknown' for reading data from the primary
%                data array, ASCII table extension, Binary table extension,
%                Image extension or an unknown extension respectively. Only
%                one extension should be supplied. DATA for ASCII and
%                Binary table extensions is a 1-D cell array. The contents
%                of a FITS file can be located in the Contents field of the
%                structure returned by FITSINFO.
%
%   EXTNAME,IDX  Same as EXTNAME except if there is more than one of the
%                specified extension type, the IDX'th one is read.
%
%   'Raw'        DATA read from the file will not be scaled and undefined
%                values will not be replaced by NaN.  DATA will be the same
%                class as it is stored in the file.
%
%   'Info',INFO  When reading from a FITS file multiple times, passing
%                the output of FITSINFO with the 'Info' parameter helps
%                FITSREAD locate the data in the file more quickly.
%
%   'PixelRegion',{ROWS, COLS, ..., N_DIM}  
%                FITSREAD returns the sub-image specified by the boundaries
%                for an N dimensional image. ROWS, COLS, ..., N_DIM are
%                each vectors of 1-based indices given either as START,
%                [START STOP] or [START INCREMENT STOP] selecting the
%                sub-image region for the corresponding dimension. This
%                parameter is valid only for primary or image extensions.
%
%   'TableColumns',COLUMNS
%                COLUMNS is a vector with 1-based indices selecting the
%                columns to read from the ASCII or Binary table extension.
%                This vector should contain unique and valid indices into
%                the table data specified in increasing order. This
%                parameter is valid only for ASCII or Binary extensions.
%
%   'TableRows',ROWS
%                ROWS is a vector with 1-based indices selecting the rows
%                to read from the ASCII or Binary table extension. This
%                vector should contain unique and valid indices into the
%                table data specified in increasing order. This parameter
%                is valid only for ASCII or Binary extensions.
%                
%            
%   Example: Read primary data from file.
%      data = fitsread('tst0012.fits');
%
%   Example: Inspect available extensions, read 'image' extension using the
%   EXTNAME option.
%      info      = fitsinfo('tst0012.fits');
%      % List of contents, includes any extensions if present.
%      disp(info.Contents);
%      imageData = fitsread('tst0012.fits','image');
%
%   Example: Subsample the fifth plane of 'image' extension by 2.
%      info        = fitsinfo('tst0012.fits');
%      rowend      = info.Image.Size(1);
%      colend      = info.Image.Size(2);
%      primaryData = fitsread('tst0012.fits','image',...
%                     'Info', info,...
%                     'PixelRegion',{[1 2 rowend], [1 2 colend], 5 });
%
%   Example: Read every other row from a ASCII table data.
%      info      = fitsinfo('tst0012.fits');
%      rowend    = info.AsciiTable.Rows; 
%      tableData = fitsread('tst0012.fits','asciitable',...
%                   'Info',info,...
%                   'TableRows',[1:2:rowend]);
%
%   Example: Read all data for the first, second and fifth column of the
%   Binary table.
%      info      = fitsinfo('tst0012.fits');
%      rowend    = info.BinaryTable.Rows;       
%      tableData = fitsread('tst0012.fits','binarytable',...
%                   'Info',info,...
%                   'TableColumns',[1 2 5]);
%
%
%   See also FITSINFO.

%   Copyright 2001-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.19 $  $Date: 2011/05/17 02:24:49 $

%Parse Inputs
[filename,extension,index,raw, info, pixelRegion, tableColumns, tableRows] =...
    parseInputs(varargin{:});

%Get file info. FITSINFO will check for file existence.
if isempty(info)
    info = fitsinfo(filename);
elseif ~all(isfield(info, {'Filename', 'FileModDate', 'FileSize', ...
                           'Contents', 'PrimaryData'}))
    error(message('MATLAB:imagesci:fitsread:invalidInfoStruct'));
else
    fid = fopen(filename,'r','ieee-be');
    if (fid == -1)  
        error(message('MATLAB:imagesci:fitsread:fileOpen', filename));
    end
    d = dir(fopen(fid));
    fclose(fid);
    
    [~, file1 ext1] = fileparts(filename);
    [~, file2 ext2] = fileparts(info.Filename);
        % Check filename, modification date and file size  
    incomp_info = ~strcmpi(file1, file2) || ~strcmpi(ext1, ext2) || ...
                  ~strcmpi(info.FileModDate, datestr(d.datenum)) || ...
                   info.FileSize ~= d.bytes; 
    if incomp_info
        error(message('MATLAB:imagesci:fitsread:incompatibleInfoStruct'));
    end
end

switch lower(extension)
    case 'primary'
        data = readprimary(info,raw,pixelRegion);
    case 'ascii'
        data = readasciitable(info,index,raw,tableColumns, tableRows);
    case 'binary'
        data = readbinarytable(info,index,raw,tableColumns, tableRows);
    case 'image'
        data = readimage(info,index,raw,pixelRegion);
    case 'unknown'
        data = readunknown(info,index,raw);
end
%END FITSREAD

function [varargin] = identifyNames(varargin)

allStrings = {'primary','image','bintable','binarytable','asciitable',...
    'table','unknown','raw','info','pixelregion', 'tablecolumns', 'tablerows'};
for k = 2:length(varargin)
    if (ischar(varargin{k}))
        param = varargin{k};
        idx = find(strcmpi(param, allStrings));
        switch length(idx)
            case 0
                error(message('MATLAB:imagesci:fitsread:unknownInputArgument', varargin{ k }));
            case 1
                varargin{k} = allStrings{idx};
            otherwise
                error(message('MATLAB:imagesci:fitsread:ambiguousInputArgument', varargin{ k }));
        end
    end
end

function [i_ret, index] = readIndex(i, varargin)
    index = 1;
    i_ret = i;
    if (i+1)<=nargin-1 && isnumeric(varargin{i+1})
        i_ret = i + 1;
        index  = varargin{i_ret}; 
    end

function [filename,extension,index,raw,info, pixelRegion, tableColumns, tableRows] =...
    parseInputs(varargin)

%Verify inputs are correct
%error(nargchk(1,10,nargin, 'struct'));

varargin = identifyNames(varargin{:});

filename    = varargin{1};
extension   = [];
index       = 1;
raw         = 0;
info        = [];
pixelRegion = [];
tableColumns= [];
tableRows   = [];

is_mult_exts = false;
i = 2;
while i <= nargin
    switch varargin{i}
        case 'primary'
            is_mult_exts = ~isempty(extension);
            extension = 'primary';
            [i, index] = readIndex(i, varargin{:});
        case {'bintable', 'binarytable'}
            is_mult_exts = ~isempty(extension);
            extension = 'binary';
            [i, index] = readIndex(i, varargin{:});
        case 'image'
            is_mult_exts = ~isempty(extension);
            extension = 'image';
            [i, index] = readIndex(i, varargin{:});
        case {'table', 'asciitable'}
            is_mult_exts = ~isempty(extension);
            extension = 'ascii';
            [i, index] = readIndex(i, varargin{:});
        case 'unknown'
            is_mult_exts = ~isempty(extension);
            extension = 'unknown';
            [i, index] = readIndex(i, varargin{:});
        case 'raw'
            raw = 1;
        case 'info'
            if (i == nargin)
                error(message('MATLAB:imagesci:fitsread:missingInfoValue'));                
            end
            i = i + 1;
            info = varargin{i};
        case 'pixelregion'
            if (i == nargin)
                error(message('MATLAB:imagesci:fitsread:missingPixelRegionValue'));                
            end
            
            i = i + 1;            
            
            if(iscell(varargin{i}) && ...                    
                    all(cellfun(@(c)isnumeric(c), varargin{i})))
                %'region', {ROWS, COLS, ...}
                pixelRegion = varargin{i};
            else
                error(message('MATLAB:imagesci:fitsread:badPixelRegion'));
            end
            
        case 'tablecolumns'
            if(i == nargin)
                error(message('MATLAB:imagesci:fitsread:missingTableColumns'));
            end
            
            i = i + 1;
            
            if(isnumeric(varargin{i}))
                tableColumns = varargin{i};
            else
                error(message('MATLAB:imagesci:fitsread:badTableColumns'));
            end

        case 'tablerows'
            if(i == nargin)
                error(message('MATLAB:imagesci:fitsread:missingTableRows'));
            end
            
            i = i + 1;
            
            if(isnumeric(varargin{i}))
                tableRows = varargin{i};
            else
                error(message('MATLAB:imagesci:fitsread:badTableRows'));
            end
            
        otherwise
            if isnumeric(varargin{i})
                error(message('MATLAB:imagesci:fitsread:extensionIndex'));
            else
                error(message('MATLAB:imagesci:fitsread:expectedStringArgument'));
            end
    end    
    i = i + 1;
end

if isempty(extension)
    extension = 'primary';
elseif strcmp(extension, 'primary') && index ~= 1
   index = 1;
   warning(message('MATLAB:imagesci:fitsread:primaryIndex'));
end
if is_mult_exts
    arg_ext = extension;
    if strcmp(extension, 'ascii')
        arg_ext = 'asciitable';
    elseif strcmp(extension, 'binary')
        arg_ext = 'binarytable';
    end
    warning(message('MATLAB:imagesci:fitsread:multipleExtensions', arg_ext));
end

% Ensure that the subsetting parameters (if any) match the extension.

if(~isempty(pixelRegion) && ...
        ~( strcmpi(extension,'primary') || strcmpi(extension,'image') ))
    % pixelRegion is not empty, and extension is neither primary nor
    % image.
    error(message('MATLAB:imagesci:fitsread:pixelRegionNotSupported'));    
end
if( (~isempty(tableColumns) || ~isempty(tableRows) ) && ...
        (~( strcmpi(extension,'ascii') || strcmpi(extension,'binary')) ))
    % table rows/cols is not empty, and extension is neither binary nor
    % ascii table
    error(message('MATLAB:imagesci:fitsread:tableColsRowsNotSupported'));    
end



%END PARSEINPUTS

%--------------------------------------------------------------------------
function data = readprimary(info,raw,pixelRegion)
%Read data from primary data

data = [];


if (info.PrimaryData.DataSize == 0)
%     if(length(info.Contents) == 1)
%         %Only primary data exists in file.
%         warning(message('MATLAB:imagesci:fitsread:EmptyPrimaryData'));
%     else
%         %there are some extensions
%         warning(message('MATLAB:imagesci:fitsread:EmptyPrimaryDataWithOtherExt'));
%     end
    return;
end

startpoint = info.PrimaryData.Offset;

%Data will be scaled by scale values BZERO, BSCALE if they exist
bscale   = info.PrimaryData.Slope;
bzero    = info.PrimaryData.Intercept;
nullvals = info.PrimaryData.MissingDataValue;

fid              = fopen(info.Filename,'r','ieee-be');
fileIdCleanUpObj = onCleanup(@()fclose(fid));

if fid==-1
    error(message('MATLAB:imagesci:fitsread:fileOpenPrimary'));
end
status = fseek(fid,startpoint,'bof');
if status==-1
    error(message('MATLAB:imagesci:fitsread:corruptFilePrimary'))
end

if(~isempty(pixelRegion))
    
    [start stride stop] = parseRegion(pixelRegion, info.PrimaryData.Size);
        
    [data expCount count reshapeDims] = ...
        readImageRegion(fid,info.PrimaryData, start,stride,stop);
    if count<expCount
        warning(message('MATLAB:imagesci:fitsread:truncatedPrimaryImageRegion'));
        return;
    end
    
else
    
    expCount = prod(info.PrimaryData.Size);
    [data, count] = ...
        fread(fid,prod(info.PrimaryData.Size),['*' info.PrimaryData.DataType]);
    
    if count<expCount
        warning(message('MATLAB:imagesci:fitsread:truncatedPrimaryData'));
        return;
    else
        %Data is stored in column major order so the first two dimensions
        %must be permuted
        reshapeDims = info.PrimaryData.Size; %[NAXIS2 NAXIS1 ...]
        numDims     = length(reshapeDims);
        if(numDims>=2)
            %take care of the default flipping of first two dims in
            %FITSINFO. reshapeDims will be [NAXIS1 NAXIS2 ...]
         reshapeDims = [reshapeDims(2) reshapeDims(1) reshapeDims(3:end)];
        end

    end    
end

%Most FITS viewer's present AXIS1 as the x-axis, which is the second
%dimension in MATLAB.MATLAB reads in the data with a size [NAXIS1 NAXIS2..]
%Interchange the first MATLAB dimensions to ensure that the image data
%looks 'upright'. i.e Permute it to be [NAXIS2 NAXIS1 ...]
data = reshape(data,reshapeDims);
data = permute(data,[2 1 3:length(reshapeDims)]);



%Scale data and replace undefined data with NaN by default
if ~raw && ~isempty(nullvals)
    data(data==nullvals) = NaN;
end
if ~raw
    data = double(data)*bscale+bzero;
end
%END READFITSPRIMARY

%--------------------------------------------------------------------------
function data = readimage(info,index,raw,pixelRegion)
%Read data from image extension

data = [];

if ~isfield(info,'Image')
    error(message('MATLAB:imagesci:fitsread:noImageExtensions'));
elseif length(info.Image)<index
    error(message('MATLAB:imagesci:fitsread:extensionNumberImage', length( info.Image )));
end

if info.Image(index).DataSize==0
    %No data
    return;
end

%Data will be scaled by scale values BZERO, BSCALE if they exist
bscale = info.Image(index).Slope;
bzero = info.Image(index).Intercept;
nullvals = info.Image(index).MissingDataValue;

startpoint = info.Image(index).Offset;

fid = fopen(info.Filename,'r','ieee-be');
fileIdCleanUpObj = onCleanup(@()fclose(fid));

if fid==-1
    error(message('MATLAB:imagesci:fitsread:fileOpenImage'));
end
status = fseek(fid,startpoint,'bof');
if status==-1
    fclose(fid);
    error(message('MATLAB:imagesci:fitsread:corruptFileImage'))
end

if(~isempty(pixelRegion)) %subset read asked for
    
    [start stride stop] = parseRegion(pixelRegion, info.Image(index).Size);
    
    [data expCount count reshapeDims] = ...
        readImageRegion(fid,info.Image(index), start,stride,stop);
    if count<expCount
        warning(message('MATLAB:imagesci:fitsread:truncatedImageRegion'));
        return;
    end
    
else    
    expCount = prod(info.Image(index).Size);
    [data, count] = ...
        fread(fid,prod(info.Image(index).Size),['*' info.Image(index).DataType]);
    if count<expCount
        warning(message('MATLAB:imagesci:fitsread:truncatedData'));
        return;
    else
        %Data is stored in column major order so the first two dimensions
        %must be permuted
        reshapeDims = info.Image(index).Size;
        numDims     = length(reshapeDims);
        if(numDims>=2)
            %take care of the default flipping of first two dims in
            %FITSINFO.
         reshapeDims = [reshapeDims(2) reshapeDims(1) reshapeDims(3:end)];
        end                
        
    end
end

%Most FITS viewer's present AXIS1 as the x-axis, which is the second
%dimension in MATLAB. Interchange the first MATLAB dimensions to ensure
%that the image data looks 'upright'
data = reshape(data,reshapeDims);
data = permute(data,[2 1 3:length(reshapeDims)]);


%Scale data and replace undefined data with NaN by default
if ~raw && ~isempty(nullvals)
    data(data==nullvals) = NaN;
end
if ~raw
    data = double(data)*bscale+bzero;
end
%END READFITSIMAGE

%--------------------------------------------------------------------------
function data = readbinarytable(info,index,raw,tableColumns, tableRows)
%Read data from binary table


data = {};


% Verify correct number of Binary Table Extensions.
if (~isfield(info,'BinaryTable'))
    error(message('MATLAB:imagesci:fitsread:noBinaryExtensions'));
elseif (length(info.BinaryTable) < index)
    error(message('MATLAB:imagesci:fitsread:extensionNumberBintable', numel( info.BinaryTable )));
end
if (info.BinaryTable(index).DataSize == 0)
    %No data
    return
end

dataDims = [info.BinaryTable(index).Rows info.BinaryTable(index).NFields];

if(isempty(tableRows))
    %full table rows
    tableRows = 1:dataDims(1);    
else
    validateTableIndices(tableRows, dataDims(1));
end
if(isempty(tableColumns))
    %full table columns
    tableColumns = 1:dataDims(2);    
else
    validateTableIndices(tableColumns, dataDims(2));
end



tscal    = info.BinaryTable(index).Slope;
tzero    = info.BinaryTable(index).Intercept;
nullvals = info.BinaryTable(index).MissingDataValue;

startpoint = info.BinaryTable(index).Offset;

fid = fopen(info.Filename,'r','ieee-be');
if fid==-1
    error(message('MATLAB:imagesci:fitsread:fileOpenBintable'));
end
status = fseek(fid,startpoint,'bof');
if status==-1
    fclose(fid);
    error(message('MATLAB:imagesci:fitsread:corruptFileBintable'))
end


%Obtain the size of the subset data  (output variable)
numRows = length(tableRows);
numCols = length(tableColumns);    
  
%Initialize output. One cell array per column. 
data = cell(1, numCols);

% Read data. Take care of complex data and scaling.
% Don't scale null values or characters
% TZERO and TSCAL are not allowed to be used with TFORM = 'X' (bit
% fields but this code will not catch this and the data will get scaled if
% the file does not follow the standard).


fieldByteSizes = getSkipBytes(info.BinaryTable(index));
fieldOffsets   = [0 cumsum(fieldByteSizes(1:end-1))]; %in bytes

oneRowSize = info.BinaryTable(index).RowSize;

%index into the read/output/collecting variable
colIndx=0;

%Start of binary table data.
baseOffset = ftell(fid);

% For each selected field (column), read all of the selected records (rows)
for selectedCol=tableColumns
    colIndx = colIndx+1;
    
    %seek to the start of the first selected row.
    fseek(fid,baseOffset + oneRowSize * (tableRows(1)-1), 'bof');

    
    precision = sscanf(info.BinaryTable(index).FieldPrecision{selectedCol},'%s %*s');
    cmplx = sscanf(info.BinaryTable(index).FieldPrecision{selectedCol},'%*s %s');
    fieldSize = info.BinaryTable(index).FieldSize(selectedCol);
    
    
    % Compute that amount of bytes to skip between rows     
    if(length(tableRows)<2)
        %Single element. Nothing to skip
        skipBytes=0;
    elseif(~any(diff(diff(tableRows))))
        %uniform stride, skipBytes between rows are equal.
        skipBytes = oneRowSize-fieldByteSizes(selectedCol)...
            +oneRowSize*(tableRows(2)-tableRows(1)-1);       
    else
        %non-uniform stride. different skips between rows
        skipBytes = oneRowSize-fieldByteSizes(selectedCol)...
            +oneRowSize*(diff(tableRows)-1);     
        skipBytes =[skipBytes 0]; %#ok<AGROW>
    end
    
    
    if fieldSize == 0 % Field has no data if size is zero
        data{colIndx}(1:numRows,1) = repmat({zeros(0,1)}, numRows, 1);
    else
        
        % Seek to the selected column.
        fseek(fid, fieldOffsets(selectedCol), 'cof');
        
        % If the data is of character type, read into a cell array
        if strcmp(precision, 'char')
            if(numel(skipBytes)==1)
                %uniform stride, use skip bytes option in FREAD.
                fielddata = fread(fid, ...
                    fieldSize*numRows, ...
                    [num2str(fieldSize) '*' precision '=>' precision], ...
                    skipBytes);
                fields = reshape(fielddata, fieldSize, numRows)';
            else
                %non-uniform stride. Loop through.
                fields = repmat(repmat(' ',[1,fieldSize]),[numRows 1]);
                for rInd = 1:numRows
                    fields(rInd,:) = fread(fid, fieldSize, ...
                        [num2str(fieldSize) '*' precision '=>' precision]);
                    fseek(fid, skipBytes(rInd),'cof');
                end
            end
            
            for i=1:numRows
                data{colIndx}{i,1} = fields(i,:);
            end
        else % Numeric type
            precision = strrep(precision, 'bit', 'int');
            if isempty(cmplx) % Read real data
                if(numel(skipBytes)==1)
                    %uniform strides
                    fielddata = fread(fid, ...
                        fieldSize*numRows, ...
                        [num2str(fieldSize) '*' precision '=>' precision], ...
                        skipBytes);
                    fielddata = reshape(fielddata, fieldSize, numRows).';
                else
                    fielddata  = zeros(numRows,fieldSize,precision);
                    for rInd = 1:numRows
                        fielddata (rInd,:) = fread(fid, ...
                            fieldSize, ...
                            [num2str(fieldSize) '*' precision '=>' precision]);
                        fseek(fid, skipBytes(rInd),'cof');
                    end
                end
                
            else % Read complex data
                if(numel(skipBytes)==1)
                    fielddataT = fread(fid, ...
                        fieldSize*2*numRows, ...
                        [num2str(fieldSize*2) '*' precision '=>' precision], ...
                        skipBytes);
                    fielddataT = reshape(fielddataT, fieldSize*2, numRows);
                else
                    fielddataT  = zeros(fieldSize*2, numRows,precision);
                    for rInd = 1:numRows
                        fielddataT (:,rInd) = fread(fid, ...
                            fieldSize*2, ...
                            [num2str(fieldSize*2) '*' precision '=>' precision]);
                        fseek(fid, skipBytes(rInd),'cof');
                    end
                end
                
                fielddata = complex(fielddataT(1:fieldSize,:),...
                    fielddataT(1+fieldSize:end,:)).';
            end
            if ~raw %convert to double format
                data{colIndx}(1:numRows,1:fieldSize) = double(fielddata);
            else
                data{colIndx}(1:numRows,1:fieldSize) = fielddata;
            end
        end
        % Add NaN's
        if ~raw && ~isempty(nullvals{selectedCol})
            data{colIndx}(data{colIndx}(:,:)==nullvals{selectedCol}) = NaN;
        end
        if ~raw && ~strcmp(precision, 'char') % Offset and scale the data
            data{colIndx}(1:numRows, 1:fieldSize) = ...
                data{colIndx}(1:numRows, 1:fieldSize)*tscal(selectedCol)+tzero(selectedCol);
        end
    end
end
fclose(fid);
%End READFITSBINARYTABLE

%--------------------------------------------------------------------------
function sizeFields = getSkipBytes(binaryTable)
% Compute the size of each of the fields
sizeFields = zeros(1,binaryTable.NFields);
for j=1:binaryTable.NFields
    fieldSize = binaryTable.FieldSize(j);
    precision = sscanf(binaryTable.FieldPrecision{j},'%s %*s');
    cmplx = sscanf(binaryTable.FieldPrecision{j},'%*s %s');
    if isempty(cmplx)
        cFactor = 1;
    else
        cFactor = 2;
    end
    sizeFields(j) = cFactor*fieldSize*getSizeAndClass(precision);
end

%--------------------------------------------------------------------------
function [sz className] = getSizeAndClass(type)
% return the precision size, in bytes and the MATLAB class name.
switch type
    case 'uint8'
        sz = 1;
        className = 'uint8';
    case 'char'
        sz = 1;
        className = 'char';
    case 'bit8'
        sz = 1;
        className = 'int8';        
    case 'int16'
        sz = 2;
        className = 'int16';
    case 'bit16'
        sz = 2;
        className = 'uint16';
    case 'int32' 
        sz = 4;
        className = 'int32';
    case 'single'
        sz = 4;
        className = 'single';
    case 'bit32'
        sz = 4;
        className = 'uint32';
    case 'double'
        sz = 8;
        className = 'double';
    case {'bit64', 'int64'}           
        sz = 8;
        className = 'int64';
    otherwise
        error(message('MATLAB:imagesci:fitsread:invalidgetSizeAndClass', type));
end

%--------------------------------------------------------------------------
function data = readasciitable(info,index,raw,tableColumns, tableRows)
%Read data from ASCII table

data = {};



if ~isfield(info,'AsciiTable')
    error(message('MATLAB:imagesci:fitsread:noASCIIExtensions'));
elseif length(info.AsciiTable)<index
    error(message('MATLAB:imagesci:fitsread:extensionNumberAscii', length( info.AsciiTable )));
end

if info.AsciiTable(index).DataSize==0
    %No data
    return;
end

dataDims = [info.AsciiTable(index).Rows info.AsciiTable(index).NFields];

if(isempty(tableRows))
    %full table rows
    tableRows = 1:dataDims(1);    
else
    validateTableIndices(tableRows, dataDims(1));
end
if(isempty(tableColumns))
    %full table columns
    tableColumns = 1:dataDims(2);    
else
    validateTableIndices(tableColumns, dataDims(2));
end



%Scale factors: TSCALn TZEROn
tscal    = info.AsciiTable(index).Slope;
tzero    = info.AsciiTable(index).Intercept;
nullvals = info.AsciiTable(index).MissingDataValue;

startpoint = info.AsciiTable(index).Offset;

fid = fopen(info.Filename,'r','ieee-be');
if fid==-1
    error(message('MATLAB:imagesci:fitsread:fileOpenAscii'));
end
status = fseek(fid,startpoint,'bof');
if status==-1
    fclose(fid);
    error(message('MATLAB:imagesci:fitsread:corruptFileAscii'))
end

%Number of columns in region
numCols = length(tableColumns);



%For each field, determine data type, field width and implicit decimal point
%location from the FieldFormat.  The FieldFormat is a code defined by the
%FITS standard in the form of Tw.d, where T is a character representing the
%data type, w is the width of the field and d is the number of digits to the
%right of the decimal place (implied if not present in the read table data).
dataType = char(zeros(1, numCols));
decimal = zeros(1, numCols);
for selectedCol = tableColumns
    dataTypetemp = sscanf(info.AsciiTable(index).FieldFormat{selectedCol},' %c%*i',1);
    if isempty(dataTypetemp)
        warning(message('MATLAB:imagesci:fitsread:fieldFormat', selectedCol));
        dataType(selectedCol) = 'A';
    else
        dataType(selectedCol) = dataTypetemp;
    end
    decimaltemp = sscanf(info.AsciiTable(index).FieldFormat{selectedCol},' %*c%*i.%i',1);
    if isempty(decimaltemp)
        decimal(selectedCol) = 0;
    else
        decimal(selectedCol) = decimaltemp;
    end
end

%Initialize output. 
data = cell(1,numCols);

%Mark the start of table data
baseOffset = ftell(fid);

%index variable for row indices into the collecting (output) variable.
destRow=0;

%Loop through the rows
for selectedRow=tableRows
    destRow=destRow+1;     
    %These are col indices into the collecting (output) variable.
    destCol=0;
    
    %Seek to beginning of the row.
    fseek(fid,...
        baseOffset+info.AsciiTable(index).RowSize*(selectedRow-1),'bof');    
    if feof(fid)
        warning(message('MATLAB:imagesci:fitsread:truncatedASCIIDataTable'));
        break;
    end

    rowstart = ftell(fid);
    
    %Loop through the columns
    for selectedCol = tableColumns
        destCol=destCol+1;
        %Seek to start of each field and read data into char array
        fseek(fid,rowstart,'bof');
        fseek(fid,info.AsciiTable(index).FieldPos(selectedCol)-1,0);
        fielddatastr = fscanf(fid,'%c',info.AsciiTable(index).FieldWidth(selectedCol));

        %Check for undefined values
        if ((~isempty(nullvals{selectedCol})) && ...
            (~isempty(strfind(fielddatastr, nullvals{selectedCol}))))
          
            if (raw)

              fclose(fid);
              error(message('MATLAB:imagesci:fitsread:rawNullValues'));

            end

            if strcmp(dataType(selectedCol),'A')
                data{destCol}{destRow,1} = NaN;
            else
                data{destCol}(destRow,1) = NaN;
            end

            continue;
            
        end

        %Convert field Precision to format string
        fmtstr = prec2convstr(info.AsciiTable(index).FieldPrecision{selectedCol});

        if ~strcmp(dataType(selectedCol),'A')
            % Numeric fields that are blank have a value of 0 by default
            if all(fielddatastr==' ')  
                data{destCol}(destRow,1)=0;
                continue;    
            else
                %Remove all blanks
                fielddatastr(strfind(fielddatastr,' ')) = '';
                %Replace all D with E for SSCANF
                fielddatastr(strfind(lower(fielddatastr),'d')) = 'E';
                %Separate exponent from fraction
                k = strfind('E',fielddatastr);
                if isempty(k)
                    % Not exponential notation.
                    % Cases like 345 or 40-10.  40-10 means 40E-10
                    [~,~,~,nextidx] = sscanf(fielddatastr,fmtstr,1);   % Note - I think this needs to actually be used.
                    if (nextidx-1)~=length(fielddatastr)
                        %Character other than '.', or 'E' found. This will be a '-'
                        %or '+'.
                        %Case like 40-10
                        fraction = fielddatastr(1:(nextidx-1));
                        exponent = num2str(sscanf(fielddatastr(nextidx:end),'%i',1));
                    else
                        %Not exponential notation
                        %Case like 345
                        fraction = fielddatastr;
                        exponent = 0;
                    end
                else
                    %Exponential Notation
                    %Found an 'E'.  Case like 40E10
                    fraction = fielddatastr(1:(k-1));
                    exponent = fielddatastr((k+1):end);
                end

                %Insert implicit decimal point
                if decimal(selectedCol) && isempty(strfind(fraction,'.'))
                    if length(fraction)<decimal(selectedCol)
                        %Zero pad
                        fraction = ['.' repmat('0',1,decimal(selectedCol)-length(fraction)) fraction]; %#ok<AGROW>
                    else
                        fraction = [fraction(1:(length(fraction)-decimal(selectedCol))) '.' fraction((length(fraction)-decimal(selectedCol)+1):end)];
                    end
                end
                %Rebuild number as a string
                fielddatastr = [fraction 'E' exponent];
            end
        end

        %Convert to a number or string.
        fielddata = sscanf(fielddatastr,fmtstr);

        %Assign to output
        if strcmp(dataType(selectedCol),'A')
            data{destCol}{destRow,1} = char(fielddata);
        elseif ~raw
            %Scale data
            data{destCol}(destRow,1) = fielddata*tscal(selectedCol)+tzero(selectedCol);
        else
            data{destCol}(destRow,1) = fielddata;
        end
    end

end
fclose(fid);
%END READASCIITABLE

%--------------------------------------------------------------------------
function data = readunknown(info,index,raw)
%Read data from unknown data

data = [];


if ~isfield(info,'Unknown')
    error(message('MATLAB:imagesci:fitsread:noUnknownExtensions'));
elseif length(info.Unknown)<index
    error(message('MATLAB:imagesci:fitsread:extensionNumberUnknown', length( info.Unknown )));
end

if info.Unknown(index).DataSize==0
    return;
end

startpoint = info.Unknown(index).Offset;

%Data will be scaled by scale values BZERO, BSCALE if they exist
bscale = info.Unknown(index).Slope;
bzero = info.Unknown(index).Intercept;
nullvals = info.Unknown(index).MissingDataValue;

fid = fopen(info.Filename,'r','ieee-be');
if fid==-1
    error(message('MATLAB:imagesci:fitsread:fileOpenUnknown'));
end
status = fseek(fid,startpoint,'bof');
if status==-1
    fclose(fid);
    error(message('MATLAB:imagesci:fitsread:corruptFileUnknown'))
end
[data, count] = fread(fid,prod(info.Unknown(index).Size),['*' info.Unknown(index).DataType]);
fclose(fid);
if count<prod(info.Unknown(index).Size)
    warning(message('MATLAB:imagesci:fitsread:truncatedUnknownExtensionData'));
else
    reshapeDims = info.Unknown(index).Size;
    numDims     = length(reshapeDims);
    if(numDims>=2)
        %take care of the default flipping of first two dims in
        %FITSINFO.
        reshapeDims = [reshapeDims(2) reshapeDims(1) reshapeDims(3:end)];
    end
    data = permute(reshape(data,reshapeDims),...
        [2 1 3:length(reshapeDims)]);

    if ~raw && ~isempty(nullvals)
        data(data==nullvals) = NaN;
    end
    %Scale data
    if ~raw
        data = double(data)*bscale+bzero;
    end
end
%END READUNKNOWN

%--------------------------------------------------------------------------
function fmtstr = prec2convstr(format)
%convert precision string to format conversion string
switch format
    case {'Char','Unknown'}
        fmtstr = '%c';
    case {'Integer','Single','Double'}
        fmtstr = '%f';
end

%--------------------------------------------------------------------------
function [data expCount count reshapeDims] =...
    readImageRegion(fid,info, start,stride,stop)

%initialize
count    = 0;
dataSize = info.Size;



%FITSINFO reports size in [NAXIS2 NAXIS1..] order. Due to col-major
%ordering of MATLAB it is more efficient to read data in as [NAXIS1 NAXIS
%2] and then reshape later. So switch size reported by info and the
%indices given to [NAXIS2 NAXIS1..] order.
numDims = numel(dataSize);
if(numDims>=2)
    dataSize = [dataSize(2) dataSize(1) dataSize(3:end)];
end
start([1 2])  = start([2 1]);
stride([1 2]) = stride([2 1]);
stop([1 2])   = stop([2 1]);


%Size per pixel
[sz dataClass] = getSizeAndClass(info.DataType);


%Obtain the dimensions of the subsetted data
reshapeDims = zeros(1,length(start));
for dimIndx = 1:length(start)
    fullDimLength = (stop(dimIndx)-start(dimIndx));
    if(mod(fullDimLength, stride(dimIndx)))
        reshapeDims(dimIndx) = ceil(fullDimLength/stride(dimIndx));
    else
        reshapeDims(dimIndx) = fullDimLength/ stride(dimIndx) +1;
    end
end

expCount = prod(reshapeDims);
data = zeros([1 expCount],dataClass);

%Read from file one strip at a time.
stripLength = reshapeDims(1);
%Bytes to skip to account for stride along the first dimension
strideBytes = (stride(1)-1)*sz;

%index into the data array that we read in to.
dataInd=1;
%Subscripted index markers into the file
markerSub  = start;

currentOffset = 0;
%Loop through the number of strips (if data size is 3x4x5, we have 4*5 1x3
%strips)
for stripInd = 1:prod(reshapeDims(2:end))
    
    %Obtain linear index into the file for the start of this strip.
    %Equivalent of using sub2ind:
    k = [1 cumprod(dataSize(1:end-1))];
    markerOffsetInd = 0;
    for dimIndx = 1:length(dataSize)        
        markerOffsetInd = markerOffsetInd +...
            (markerSub(dimIndx)-1)*k(dimIndx);
    end
    
    %This is the offset in bytes from the start of the data
    markerSubOffsetInBytes  = markerOffsetInd * sz;       
    %Convert that to offset from where we are in the file now
    requiredOffset =  markerSubOffsetInBytes - currentOffset;
    fseek(fid,requiredOffset,'cof');
    
    %After the data is read, the offset will be:
    currentOffset  = currentOffset + ...
                     requiredOffset + ...
                     stripLength*sz+ (strideBytes*stripLength);
    
    if(fid==-1)
        %insufficient data
        return;
    end
    
    %Read one strip
    [ stripData stripCount] =...
        fread(fid, stripLength,['*' info.DataType],strideBytes);
    count = count + stripCount;
    
    %was enough data read?
    if(stripCount == stripLength)
        data(dataInd: dataInd+stripLength-1) = stripData;
    else
        %insufficient data
        return;
    end
    
    
    %increment the marker to start of next strip
    markerSub = incrementMarker(markerSub,start,stride,stop);
    %increament the index into the collection variable
    dataInd   = dataInd+stripLength;
end


%--------------------------------------------------------------------------
function nextStripSub = incrementMarker(currentStripSub, start,stride,stop)
%Moves currentStripSub (subscripts to a data of dataSize) to the next strip
%start location

nextStripSub = currentStripSub;

%Since we read one strip at a time, skip the first dimension
for dimInd = 2:length(nextStripSub)
    
    %increment the next dimension by its stride
    currentDimIncrement = currentStripSub(dimInd) + stride(dimInd);
    
    %Did we cross the specified stop boundary for this dimension?
    if(  currentDimIncrement  >    stop(dimInd) )
        %yes, reset this dimension to its start
        nextStripSub(dimInd) = start(dimInd);
    else
        %no, reset previous dimensions to start
        nextStripSub(1:dimInd-1) = start(1:dimInd-1);
        nextStripSub(dimInd) = currentDimIncrement;
        return;
    end
    
end

%--------------------------------------------------------------------------
function [start stride stop] = parseRegion(pixelRegion,dataDims)
% Convert {ROWS, COLS..} to {START STRIDE STOP} for the region parameter
% given for image or primary data subsetting. Validate extents.

numDims = numel(dataDims);

if(length(pixelRegion) ~= numDims)
    error(message('MATLAB:imagesci:fitsread:pixelRegionIncomplete', length( pixelRegion ), numel( dataDims )));
end

%numDims will at least be 2.
start  = ones(1,numDims);
stride = ones(1,numDims);
stop   = ones(1,numDims);

for dimInd = 1: numDims
    
    indices = pixelRegion{dimInd};
    
    switch length(indices)
        case 1 
            start(dimInd) = indices(1);
            stop(dimInd)  = indices(1);
        case 2
            start(dimInd) = indices(1);            
            stop(dimInd)  = indices(2);
        case 3
            start(dimInd)  = indices(1);
            stride(dimInd) = indices(2);
            stop(dimInd)   = indices(3);            
            
            if(indices(2)<=0)
                error(message('MATLAB:imagesci:fitsread:badIncrement', dimInd));
            end
            
        otherwise
            error(message('MATLAB:imagesci:fitsread:badIndex', dimInd));
    end
    
    if( (start(dimInd) ~= round(start(dimInd))) || ...
            (stride(dimInd) ~= round(stride(dimInd))) || ...
            (stop(dimInd) ~= round(stop(dimInd))) )
        error(message('MATLAB:imagesci:fitsread:wholeNumbersExpected', dimInd));
    end
    
    if(start(dimInd)<=0 || start(dimInd)>dataDims(dimInd))
        error(message('MATLAB:imagesci:fitsread:badStart', dimInd, dataDims( dimInd )));
    end
    if(stop(dimInd)<start(dimInd) || stop(dimInd)>dataDims(dimInd))
        error(message('MATLAB:imagesci:fitsread:badStop', dimInd, start( dimInd ), dataDims( dimInd )));
    end
    
    
end

%--------------------------------------------------------------------------
function validateTableIndices(indices, dataLength)
% Ensure that the indices for a table dimension are valid for give data
% dimension length


if(any(indices<1))
    error(message('MATLAB:imagesci:fitsread:indexLessThan1'));
end

if(any(indices>dataLength))
    error(message('MATLAB:imagesci:fitsread:indexGreaterThanData', dataLength));
    
end

%Should be unique
if(length(indices) ~= length(unique(indices)))
    error(message('MATLAB:imagesci:fitsread:nonUniqueIndices'));
end

%Should be increasing
if(~issorted(indices))
    error(message('MATLAB:imagesci:fitsread:nonIncreasingIndices'));
end

%Should be whole numbers
if(any(indices~=round(indices)))
    error(message('MATLAB:imagesci:fitsread:nonIntegerIndices'));
end




