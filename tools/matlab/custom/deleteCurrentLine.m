%% add comment for a script by press "Alt + 2"
% Home -> Favorites -> New Favorite -> 
% Label: delLine
% Code:  delLine
% select 'Add to quick access toolbar' and 'Show label on quick acces
% toolbar'.

activeEditor = matlab.desktop.editor.getActive;

selectionPosition = activeEditor.Selection;
selectLineIdx = selectionPosition(1);
scriptContents = activeEditor.Text;
contentsCell = splitlines(scriptContents);

modifiedContents = '';
for i = 1 : size(contentsCell, 1)
    if i == selectLineIdx, continue; end
    if i == size(contentsCell, 1)  % In the last line, don't add new line.
        modifiedContents = [modifiedContents contentsCell{i}];
    else
        modifiedContents = [modifiedContents contentsCell{i} newline];
    end
    
end

activeEditor.Text = modifiedContents;
activeEditor.Selection = [selectLineIdx, 1, selectLineIdx, 1];  % move cursor to modified line start
