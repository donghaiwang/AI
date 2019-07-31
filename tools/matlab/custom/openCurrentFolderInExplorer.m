%% open current folder in explorer(only support in Windows)
% Home -> Favorites -> New Favorite -> 
% Label: OpenFolder
% Code:  openCurrentFolderInExplorer
% select 'Add to quick access toolbar' and 'Show label on quick acces
% toolbar'.

winopen(fileparts( matlab.desktop.editor.getActiveFilename));
