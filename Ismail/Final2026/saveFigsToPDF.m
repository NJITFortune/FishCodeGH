% saveFigsToPDF.m
%
% Saves every open figure window as a PDF.
% The filename is derived from the page-title annotation (the textbox
% placed near the top of the figure by smitaPlot, etc.).
% All characters that are not letters or digits are stripped.
% Falls back to the figure Name, then to "FigureN", if no title is found.
%
% PDFs are written to the current working directory.

figs = findall(0, 'Type', 'figure');

if isempty(figs)
    disp('No open figures found.');
    return
end

fprintf('Saving %d figure(s)...\n', numel(figs));

for k = 1:numel(figs)
    fh = figs(k);

    titleStr = '';

    % Search all objects in the figure for text near the top of the page.
    % annotation('textbox') objects have a normalised Position; we look for
    % any object with Position(2) > 0.85 and a non-empty String.
    all_objs = findall(fh);
    for a = 1:numel(all_objs)
        try
            pos = get(all_objs(a), 'Position');
            str = get(all_objs(a), 'String');
            if ~isempty(str) && isnumeric(pos) && numel(pos) == 4 && pos(2) > 0.85
                if iscell(str)
                    str = strjoin(str, ' ');
                end
                titleStr = strtrim(str);
                break
            end
        catch
            % object lacks Position or String — skip
        end
    end

    % Fallbacks
    if isempty(titleStr)
        titleStr = strtrim(get(fh, 'Name'));
    end
    if isempty(titleStr)
        titleStr = sprintf('Figure%d', fh.Number);
    end

    % Strip everything except letters and digits
    fname = regexprep(titleStr, '[^a-zA-Z0-9]', '');
    if isempty(fname)
        fname = sprintf('Figure%d', fh.Number);
    end

    pdfFile = [fname '.pdf'];
    exportgraphics(fh, pdfFile, 'ContentType', 'vector');
    fprintf('  Saved: %-40s  (title: "%s")\n', pdfFile, titleStr);
end

fprintf('Done.\n');
