function asuMLPathUpd()

proj = 'S:\Projects\MATLAB';

if ~exist('rootN', 'var') || isempty(rootN)
    asuOwnPaths(proj);
else
    curr = cd;
    if strcmp(curr, proj)
        l_docsSave(curr, true);
    end
    l_MDSwitchPath(['S:\DeltaJS\DELTAware_' rootN]);
    savepath;
    if strcmp(curr, proj)
        l_docsRestore(fileparts(fileparts(fileparts(which('md3')))));
    end
    cd('C:\');
    asuStartup_cd();
    disp(['cd = <' cd '>']);
end
    
end

%--------------------------------------------------------------------------
function asuOwnPaths(proj)

fltr = 'matlab\DJSGlobalRoutines\MATLAB';

genp = path;
newp = '';
while (~isempty(genp))
    [s, genp] = strtok(genp, ';');
    if isempty(strfind(s, fltr))
        if ~isempty(newp)
            newp = [newp ';'];
        end
        newp = [newp s];
    else
        stophere = 1;
    end
end

path(newp);

md3root = fileparts(fileparts(fileparts(which('md3'))));
l_docsSave(md3root, true);

l_docsRestore(proj);
cd(proj);

end

% %--------------------------------------------------------------------------
% function l_docsRemove()
%     docs = matlab.desktop.editor.getAll();
%     arrayfun( @(doc)doc.close(), docs);
% end

%--------------------------------------------------------------------------
function l_docsRestore(newRoot)
    
    fn = fullfile(newRoot, 'matlab.desktop.editor.OpenFiles.txt');
    if matlab.desktop.editor.isEditorAvailable && exist(fn, 'file') && exist('table', 'class')
     	T = readtable(fn, 'ReadVariableNames', true, 'Delimiter', ',');
        
        for i = 1:size(T,1)
            matlab.desktop.editor.openAndGoToLine( char(T{i, 'Filename'}), T{i, 'Line'});
        end
    end
end

%--------------------------------------------------------------------------
function l_docsSave(currRoot, isAllDelete)
    if matlab.desktop.editor.isEditorAvailable && exist('table', 'class')
        
        docs = matlab.desktop.editor.getAll();
        if isAllDelete
            bToClose = true(1, length(docs));
        else
            bToClose = arrayfun(@(doc)strncmpi(doc.Filename, currRoot, length(currRoot)), docs);
        end
        
        if any(bToClose)
            Filename = vecColumn({docs(bToClose).Filename});
            %Selection= vertcat(   docs(bToClose).Selection);
            Line = ones(size(Filename, 1), 1);
            
            T = table(Filename, Line);
            writetable(T, fullfile(currRoot, 'matlab.desktop.editor.OpenFiles.txt') );
            
            % Close editor
            arrayfun( @(doc)doc.close(), docs(bToClose));
        end
    end
end

%--------------------------------------------------------------------------
function l_MDSwitchPath(newRoot)
    
    currRoot = fileparts(fileparts(fileparts(which('md3'))));
    newPath = path;
    
    if isempty(currRoot)
        warning('MD3:Utils:SwitchPath', 'Cannot find current version of MD3 in path - not removing anything');
        
        isInPath = @(s)true;
    else
        
        hFigures = findall(0, 'Type', 'figure', 'Visible', 'on');
        if ~isempty(hFigures)
            figure(min(hFigures));    % focus older window
            
            % Globals, including MADYN2000 memory will get corrupt otherwise!!!
            error('MD3:Utils:SwitchPath', 'Some windows are currently open. Please close all windows before changing path');
        end
        
        % remove old root from path
        disp(['Removing old root from the path: ' currRoot]);
        
        if ~strcmp(newRoot, currRoot)
            l_docsSave(currRoot, false);
        end
        
        isInPath = @(s)strncmpi(s, currRoot, length(currRoot));
        newPath = cleanupOldPath( isInPath, newPath);
    end
    
    if strcmp('win64', computer('arch'))
        cppbin = 'bin64';
    else
        cppbin = 'bin';
    end
    
    newPath  = [ genpath([newRoot '\matlab']) ';', ...
        fullfile(newRoot,'cpp',cppbin) ';', ...
        fullfile(newRoot,'cpp',cppbin, 'MESYS') ';', ...
        fullfile(newRoot,'cpp',cppbin, 'OpenCascade') ';', ...
        [newRoot '\java\bin'] ';', ...
        [newRoot '\dotnet\bin'] ';', ...
        genpath([newRoot '\setup\Files\Demo_Examples\Extensions']) ';', ...
        newPath ];
    
        path(newPath);
        
    function clearJavaPath(s)
        if feval(isInPath, s)
            javarmpath(s);
        end
    end
    
    cellfun(@clearJavaPath, javaclasspath);
    
    clear global
    disp(['Updated path starting from:      ' newRoot]);
    cd(fullfile(newRoot, 'matlab'));
    
    if ~strcmp(newRoot, currRoot) && ~isempty(currRoot)
        l_docsRestore(newRoot);
    end
    
    if isTeamCity
        % print the resulting path
        matlabpath;
    end
end

function newp = cleanupOldPath(fltr, genp)
    newp = '';
    while (~isempty(genp))
        [s, genp] = strtok(genp, ';');
        if ~feval(fltr, s)
            newp = [ newp ';' s];
        end
    end
end
