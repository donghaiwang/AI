function associateFiles(action, userExtList, fileStr)

% associateFiles(action, extList, fileStr)
%
% Makes a registry files that can be used to set correct file associantions on
% a windows platform. The following MATLAB file extensions are supported:
% .m, .mat, .fig, .mexw32, .mexw64, .p, .mdl, .mdlp, .slx, .mldatx, .req,
% .sldd, .slddc, .slxp, .sltx, .mn, .mu, .muphlp, .xvc, .xvz, .ssc, .mlapp,
% .mlappinstall, .mltbx, .mlpkginstall, .mlprj
%
% INPUT:
% action  - optional string. 
%           * 'add' (default) adds/rewrites the MATLAB file association registry
%              keys for this version.
%           * 'delete' deletes the MATLAB file association registry entries for
%              ALL versions of MATLAB (including "old style" ones)
%           * 'deleteadd' is the same as 'delete' followed by 'add'  
% extList - optional string or cell array of strings containing the file
%           extensions that should be associated with this version. Default is
%           all MATLAB file extension (see above).
% fileStr - optional string with the name of the registry file to be written 
%           (possibly including path). Default is the file
%           'MatlabFileAssocFix.reg' in the current directory.
%
% USAGE:
% 1) Run with desired options (see above). A registry file should have been 
%    created. 
% 2) Exit all running instances of MATLAB.
% 3) Make a backup copy of the windows registry if you need to restore the 
%    changes, see https://support.microsoft.com/en-us/kb/322756
% 4) Double click on the created file (possibly need to enter a password) and
%    confirm.
% 5) Restart Windows (or explorer.exe).
% 6) The MATLAB files should now be associated with the MATLAB version that the
%    registry file was created in and e.g. m-files should be opened in an
%    already running instance of MATLAB.
%
% EXAMPLES:
% * associateFiles('deleteadd') - Makes a registry files that deletes all
%   previous MATLAB file association registry keys and write new ones that
%   associates all MATLAB files with the MATLAB version that the registry file
%   was created in.
% * associateFiles('', {'.m', '.mat', '.fig'}, 'myFile') - Makes a registry file
%   "myFile.reg" that associates m-, mat- and fig-files with the MATLAB version
%   that the registry file was created in. 
%
% VERSION 1.0

% Defualt input
if (nargin < 1 || isempty(action))
  action      = 'add';
end
if (nargin < 2)
  userExtList = {};
end
if (nargin < 3)
  fileStr = '';
end
if (~iscell(userExtList))
  if (isempty(userExtList))
    userExtList = {};
  else
    userExtList = {userExtList};
  end
end

% Sanity check
if (~ischar(action) || (~strcmpi(action, 'add') && ...
    ~strcmpi(action, 'delete') && ~strcmpi(action, 'deleteadd')))
  error('The action to perform must be ''add'', ''delete'' or ''deleteadd''!')
end
if (~isempty(userExtList) && ~min(cellfun(@ischar, userExtList)))
  error('The file extension list must be a string or a cell array of strings!')
end
if (~ischar(fileStr))
  error('The file to write to must be a string!')
end


% Get the currently running MATLAB version
verStr = regexp(version, '(\d*?\.\d*?\.\d*?)\.', 'tokens');
verStr = verStr{1}{1};
verNum = str2double(regexprep(verStr, '(\d*?\.\d*)[\x0000-\xffff]*', '$1'));
verHex = sprintf('%04x', str2double(regexprep(verStr, ...
  '(\d*?)\.[\x0000-\xffff]*', '$1')), str2double(regexprep(verStr, ...
  '\d*?\.(\d*?)\.[\x0000-\xffff]*', '$1')));

% Get 32/64-bit
arch = computer;
switch arch
  case 'PCWIN'
    binFolder = 'win32';
  case 'PCWIN64'
    binFolder = 'win64';
end
binPath = fullfile(matlabroot, 'bin', binFolder);


% Known MATLAB files with possible DDE actions
fileExtCell = {...
  'fig' ,   'MATLAB Figure'              , '-62'                       , ...
  {'Open', 'uiopen(''%1'',1)'}           , []                          ; ...
  'm'     , 'MATLAB Code'                , '-58'                       , ...
  {'Open', 'uiopen(''%1'',1)'}           , {'Run', 'run(''%1'')'}      ; ...
  'mat'   , 'MATLAB Data'                , '-59'                       , ...
  {'Load', 'load(''%1'')'    }           , {'Open', 'uiimport(''%1'')'}; ...
  'mdl'   , 'Simulink Model'             , '-61'                       , ...
  {'Load', 'uiopen(''%1'',1)'}           , []                          ; ...
  'mdlp'  , 'Simulink Protected Model'   , '-72'                       , ...
  []                                     , []                          ; ...
  'mexw32', 'MATLAB MEX'                 , '-63'                       , ...
  []                                     , []                          ; ...
  'mexw64', 'MATLAB MEX'                 , '-63'                       , ...
  []                                     , []                          ; ...
  'mn'    , 'MuPAD Notebook'             , '-66'                       , ...
  {'Open', 'mupad(''%1'')'}              , []                          ; ...
  'mu'    , 'MuPAD Code'                 , '-67'                       , ...
  {'Open', 'uiopen(''%1'',1)'}           , []                          ; ...
  'muphlp', 'MuPAD Help'                 , '-68'                       , ...
  {'Open', 'doc(symengine, ''%1'')'}     , []                          ; ...
  'p'     , 'MATLAB P-code'              , '-60'                       , ...
  []                                     , []                          ; ...
  'slx'   , 'Simulink Model (SLX format)', '-73'                       , ...
  {'Open', 'uiopen(''%1'',1)'}           , []                          ; ...
  'ssc'   , 'Simscape Model'             , '-65'                       , ...
  {'Open', 'uiopen(''%1'',1)'}           , []                          ; ...
  'xvc'   , 'MuPAD Graphics'             , '-69'                       , ...
  {'Open', 'mupad(''%1'')'}              , []                          ; ...
  'xvz'   , 'MuPAD Graphics'             , '-70'                       , ...
  {'Open', 'mupad(''%1'')'}              , []                          ; ...
  'mlapp'       , 'MATLAB Application'              , [] , [], []      ; ... 
  'mltbx'       , 'MATLAB Toolbox'                  , [] , [], []      ; ... 
  'mldatx'      , 'Simulink Scenario'               , [] , [], []      ; ...  
  'req'         , 'Simulink Requirements Link'      , [] , [], []      ; ... 
  'sldd'        , 'Simulink Dictionary'             , [] , [], []      ; ... 
  'slddc'       , 'Simulink Dictionary'             , [] , [], []      ; ...      
  'mlappinstall', 'MATLAB Application'              , [] , [], []      ; ...  
  'mlpkginstall', 'MATLAB Support Package'          , [] , [], []      ; ... 
  'slxp'        , 'Simulink Protected Model Package', [] , [], []      ; ... 
  'sltx'        , 'Simulink Template'               , [] , [], []      ; ... 
  'mlprj'       , 'MATLAB Project'                  , [] , [], []};

% Possibly trim list
if (~isempty(userExtList))
  fileExtCell = fileExtCell(ismember(fileExtCell(:, 1), ...
    regexprep(userExtList, '\.', '')), :);
end

% Make registry file
if (~isempty(fileStr))
  % Possibly add file extension
  [~, ~, tmp] = fileparts(fileStr);
  if (isempty(tmp))
    fileStr = [fileStr, '.reg'];
  end
  fid = fopen(fileStr, 'w');
else
  fid = fopen('MatlabFileAssocFix.reg', 'w');
end
if (fid == -1)
  error('Failed to create registry file')
end
% Write intial lines
fprintf(fid, '%s\r\n\r\n', 'Windows Registry Editor Version 5.00');
fprintf(fid, '%s\r\n\r\n', ';FIXES MATLAB FILE ASSOCIATIONS');


% REMOVE OLD KEYS
explorerKey = ['HKEY_CURRENT_USER\Software\Microsoft\Windows\', ...
  'CurrentVersion\Explorer\FileExts'];
% Iterate over file extensions
for fileExtNo = 1 : size(fileExtCell, 1)
  rmKeys  = {};
  fileExt = fileExtCell{fileExtNo, 1};
  
  % File extension keys
  [status, result] = dos(['reg query HKEY_CLASSES_ROOT /f .', fileExt, ...
    ' /k /e']);
  if (~status)
    keys = regexp(result, '(HKEY_CLASSES_ROOT[\x0000-\xffff]*?)\n', 'tokens');
    rmKeys = [rmKeys, keys{:}];
  end
  
  % Old style keys without version numbers
  if (~strcmpi(fileExt, 'mexw64'))
    % Uses single DDE key for mex files
    if (strcmpi(fileExt, 'mexw32'))
      fileExtTmp = 'mex';
    else
      fileExtTmp = fileExt;
    end
    [status, result] = dos(['reg query HKEY_CLASSES_ROOT /f ', ...
      fileExtTmp, 'file /k /e']);
    if (~status)
      keys = regexp(result, '(HKEY_CLASSES_ROOT[\x0000-\xffff]*?)\n', ...
        'tokens');
      rmKeys = [rmKeys, keys{:}];
    end
  end
  
  % New style keys with version number
  if (strcmpi(action, 'add'))
    % Only remove keys related to this version
    [status, result] = dos(['reg query HKEY_CLASSES_ROOT /f MATLAB.', ...
      fileExt, '.', verStr ' /k']);
  else
    % Remove keys related to ALL version
    [status, result] = dos(['reg query HKEY_CLASSES_ROOT /f MATLAB.', ...
      fileExt, '. /k']);
  end
  if (~status)
    keys = regexp(result, '(HKEY_CLASSES_ROOT[\x0000-\xffff]*?)\n', 'tokens');
    rmKeys = [rmKeys, keys{:}];
  end
  
  % Explorer keys
  [status, result] = dos(['reg query ', explorerKey, ' /f .', fileExt, ...
    ' /k /e']);
  if (~status)
    keys = regexp(result, '(HKEY_CURRENT_USER[\x0000-\xffff]*?)\n', 'tokens');
    rmKeys = [rmKeys, keys{:}];
  end
  
  % Write to file
  if (~isempty(rmKeys))
    fprintf(fid, '%s\r\n\r\n', [';REMOVES ', upper(fileExt), ...
      ' FILE ASSOCIATIONS']);
    for keyNo = 1 : length(rmKeys)
      key = rmKeys{keyNo};
      fprintf(fid, '%s\r\n\r\n', ['[-', key, ']']);
    end
  end
end

% ADD KEYS
if (~strcmpi(action, 'delete'))
  % Get text Persistent Handler
  [status, result] = dos(...
    'reg query HKEY_CLASSES_ROOT\.txt\PersistentHandler /ve');
  if (~status)
    PersistentHandler = regexp(result, '\{[\x0000-\xffff]*?\}', 'match');
    PersistentHandler = PersistentHandler{1};
  else
    PersistentHandler = '';
  end
  % DDE call
  ddeCall = 'ShellVerbs.Matlab';
  if (verNum > 8)
    % Changed from R2013a
    ddeCall = [ddeCall, '.', verStr];
  end
  % Default icon
  defIcon = 'm';
  if (~exist(fullfile(binPath, 'm.ico'), 'file'))
    defIcon = '';
  end
  % Path to MATLAB binary directory with \\
  binPathStr = regexprep(binPath, '\\', '\\\\');
  
  % Write Shell Open key
  key = ['[HKEY_CLASSES_ROOT\Applications\MATLAB.exe\shell\open', ...
    '\command]%r', '@="\"', binPathStr, '\\MATLAB.exe\" \"%1\""%r%r'];
  fprintf(fid, '%s\r\n\r\n', ';ADD SHELL OPEN');
  lines = regexp(key, '([\x0000-\xffff]*?)%r', 'tokens');
  for lineNo = 1 : length(lines)
    fprintf(fid, '%s\r\n', lines{lineNo}{1});
  end
  
  % Iterate over file types
  for fileExtNo = 1 : size(fileExtCell, 1)
    fileExt = fileExtCell{fileExtNo, 1};
    
    % File extension keys
    key  = ['[HKEY_CLASSES_ROOT\.', fileExt, ']%r@="MATLAB.', fileExt, '.', ...
      verStr, '"%r'];
    if (strcmpi(fileExt, 'm') && ~isempty(PersistentHandler))
      % Add some values
      key = [key, '"Content Type"="text/plain"%r', ...
        '"PerceivedType"="Text"%r'];
    end
    key = [key, '%r'];
    key = [key, '[HKEY_CLASSES_ROOT\.', fileExt, ...
      '\OpenWithProgids]%r"MATLAB.', fileExt, '.', verStr, '"=""%r%r'];
    if (strcmpi(fileExt, 'm') && ~isempty(PersistentHandler))
      key = [key, '[HKEY_CLASSES_ROOT\.', fileExt, ...
        '\PersistentHandler]%r@="', PersistentHandler, '"%r%r'];
    end
    key  = [key, '[HKEY_CLASSES_ROOT\.', fileExt, ...
      '\Versions\MATLAB.', fileExt, '.' verStr, ']%r"FileVersionMS"=dword:', ...
      verHex, '%r"FileVersionLS"=dword:00000000%r%r'];
    
    % DDE keys
    ddeData = fileExtCell(ismember(fileExtCell(:, 1), fileExt), :);
    key = [key, '[HKEY_CLASSES_ROOT\MATLAB.', fileExt, '.' verStr, ...
      ']%r@="', ddeData{2}, '"%r'];
    if (~isempty(ddeData{3}))
      key = [key, '"FriendlyTypeName"="@', binPathStr, '\\matlab.exe', ...
        ',', ddeData{3}, '"%r'];
    end
    key = [key, '%r'];
    % Icon
    icon = fileExt;
    if (~exist(fullfile(binPath, [icon, '.ico']), 'file'))
      icon = defIcon;
    end
    if (~isempty(icon))
      key = [key, '[HKEY_CLASSES_ROOT\MATLAB.', fileExt, '.' verStr, ...
        '\DefaultIcon]%r@="', binPathStr, '\\', icon, '.ico,0"%r%r'];
    end
    % Shell actions
    for shellActionNo = 4:5
      ddePar = ddeData{shellActionNo};
      if (~isempty(ddePar))
        key = [key, '[HKEY_CLASSES_ROOT\MATLAB.', fileExt, '.' verStr, ...
          '\Shell\', ddePar{1}, ']%r@="', ddePar{1}, '"%r%r'];
        key = [key, '[HKEY_CLASSES_ROOT\MATLAB.', fileExt, '.' verStr, ...
          '\Shell\', ddePar{1}, '\command]%r@="\"', binPathStr, ...
          '\\matlab.exe\""%r%r'];
        key = [key, '[HKEY_CLASSES_ROOT\MATLAB.', fileExt, '.' verStr, ...
          '\Shell\', ddePar{1}, '\ddeexec]%r@="', ddePar{2}, '"%r%r'];
        key = [key, '[HKEY_CLASSES_ROOT\MATLAB.', fileExt, '.' verStr, ...
          '\Shell\', ddePar{1},'\ddeexec\application]%r@="', ...
          ddeCall, '"%r%r'];
        key = [key, '[HKEY_CLASSES_ROOT\MATLAB.', fileExt, '.' verStr, ...
          '\Shell\', ddePar{1},'\ddeexec\topic]%r@="system"%r%r'];
      end
    end
    
    % Explorer keys
    key = [key, '[', explorerKey, '\.', fileExt, '\OpenWithProgids]%r'];
    if (strcmpi(fileExt, 'm'))
      key = [key, '"m_auto_file"=hex(0):%r'];
    end
    key = [key, '"MATLAB.', fileExt, '.',  verStr, '"=hex(0):%r%r'];
    if (~isempty(ddeData{4}))
      % Add key
      key = [key, '[', explorerKey, '\.', fileExt, ...
        '\OpenWithList]%r"a"="MATLAB.exe"%r"MRUList"="a"%r%r'];
    else
      key = [key, '[', explorerKey, '\.', fileExt, '\OpenWithList]%r%r'];
    end
    % Write to file
    fprintf(fid, '%s\r\n\r\n', [';ADD ', upper(fileExt), ...
      ' FILE ASSOCIATIONS']);
    lines = regexp(key, '([\x0000-\xffff]*?)%r', 'tokens');
    for lineNo = 1 : length(lines)
      fprintf(fid, '%s\r\n', lines{lineNo}{1});
    end
  end
  
end

% Cloese file
fclose(fid);