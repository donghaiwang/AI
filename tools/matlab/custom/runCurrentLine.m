%% add comment for a script by press "Alt + 1"
% Home -> Favorites -> New Favorite -> 
% Label: runCurLine
% Code:  runCurrentLine
% select 'Add to quick access toolbar' and 'Show label on quick acces
% toolbar'.

% function runCurrentLine
activeEditor = matlab.desktop.editor.getActive;

selectionPosition = activeEditor.Selection;
selectLineIdx = selectionPosition(1);
scriptContents = activeEditor.Text;
contentsCell = splitlines(scriptContents);
eval(contentsCell{selectLineIdx});  % run the line at cursor

% end