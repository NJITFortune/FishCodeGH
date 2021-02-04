%% Yasmine tracked data h5 format deeplabcut deep lab cut dlc 
filename = 'C:\Users\eric_fortune\Desktop\Herzog_Vought\BG2\170721gTANKA\170721gTANKA bx\1lDLC_resnet50_BG2Nov7shuffle1_200000_bx.h5';


foo = h5info(filename, '/df_with_missing/table');
field = h5read(filename,'/df_with_missing/table');
%%
figure(1); clf; hold on;
plot(field.values_block_0(1,:), field.values_block_0(2,:))
plot(field.values_block_0(4,:), field.values_block_0(5,:))
plot(field.values_block_0(7,:), field.values_block_0(8,:))

figure(2); clf; hold on;
plot(field.values_block_0(10,:), field.values_block_0(11,:))
plot(field.values_block_0(13,:), field.values_block_0(14,:))
plot(field.values_block_0(16,:), field.values_block_0(17,:))

figure(3); clf; hold on;

plot(field.values_block_0(1,:), field.values_block_0(2,:), 'o-', 'MarkerSize', 2)
plot(field.values_block_0(10,:), field.values_block_0(11,:), 'o-', 'MarkerSize', 2)

%%
figure(4); clf; hold on;

len = length(field.values_block_0(1,:));

    for j=1:10:len
        
       plot([field.values_block_0(4,j), field.values_block_0(7,j)], ...
           [field.values_block_0(5,j), field.values_block_0(8,j)], 'm-', 'LineWidth', 1');
       plot([field.values_block_0(1,j), field.values_block_0(4,j)], ...
           [field.values_block_0(2,j), field.values_block_0(5,j)], 'r-', 'LineWidth', 3');
        
    end
figure(5); clf; hold on;

len = length(field.values_block_0(1,:));

    for j=1:10:len
        
       plot([field.values_block_0(10,j), field.values_block_0(13,j)], ...
           [field.values_block_0(11,j), field.values_block_0(14,j)], 'c-', 'LineWidth', 1');
       plot([field.values_block_0(13,j), field.values_block_0(16,j)], ...
           [field.values_block_0(14,j), field.values_block_0(17,j)], 'b-', 'LineWidth', 3');
        
    end


%%
%           info = h5info(filename);
%           groups = info.Groups;
%           nGroups = length(groups);
%           
%           %%
%           for i=1:nGroups
%               groupname = groups(i).Name;
%               cleanname = regexprep(groupname,'[/]','');
% 
%               field = h5read(filename,strcat(groupname,'/data'));
%               
%               if ~isfield(h5data, cleanname)
%                   h5data.(cleanname) = field;
%               else
%                   existingfields = fieldnames(h5data.(cleanname));
%                   for j=1:length(existingfields)
%                       entryname = existingfields{j};
%                       h5data.(cleanname).(entryname) = ...
%                           [h5data.(cleanname).(entryname); field.(entryname)];
%                   end
%               end
%               
%               
%           end