%% ------ Add style to figure ----- %%
clc
clear all;
warning('off') % disabled warning messages from importing .fig created by simulink scope
store_choices = ['current folder', 'one folder above', 'in prefix folder'];

%% -- Settings -- %%
% Set index of store_at such that:
% store_at = 1: store in current folder (same folder as this script)
% store_at = 2: store in above folder
% store_at = 3: store in new folder under folder where this script is
store_at = 2;
figure_title = 'Rogowski coil and current transformer measurements'; % String for title
filename = 'rog_vs_ideal'; % filename of inputfile in .fig format
prefix = 'images/'; % The folder where the figure is stored if store_at=3
x_label = 'Time [t]';
y_label = 'Current [A]';
output_type = '.png';
label_font_size = 18;
title_font_size = 24;

%% -- Initial setup -- %
if strcmp(store_choices(store_at), 'current folder')
    prefix = '';
elseif strcmp(store_choices(store_at), 'one folder above')
    directory = cd;
    folders = strfind(directory,'/');
    prefix = append(directory(1:folders(end)-1), '/');
elseif strcmp(store_choices(store_at), 'in prefix folder')
    prefix = prefix
else
    disp('Store at setting is not correct')
end

input_type = '.fig';

input_file = append(prefix, filename, input_type);
output_file = append(prefix, filename, output_type);

% Open filename
disp(append('Styling figure: ', input_file))
fig = openfig(input_file, 'invisible');
axes = fig.CurrentAxes;
legend = axes.Legend;
%% Set basic data
fig.Name = append('Figure Styling for: ', filename); % name of window 

%% -- Set labels -- %%
xlabel(x_label);
ylabel(y_label);

%% -- Set background color -- %%
fig.Children.Children.Children.BackgroundColor = 'white'; % Color for area outside plot
fig.Children.BackgroundColor = 'white'; % Color for shadow of plot window
axes.Color = 'white'; % Color for plot area
axes.GridColor = [0.15, 0.15, 0.15]; % Color for grids, gray

%% -- Set grid properties -- %%
axes.XColor = 'black';
axes.YColor = 'black';
axes.FontSize = label_font_size;

%% -- Set title -- %%
axes.Title.FontSize = title_font_size;
axes.Title.String = figure_title;
axes.Title.Color = 'black';

%% -- Set legends -- %%
legend.FontSize = label_font_size;
legend.Color = 'white';
legend.TextColor = 'black';
legend.EdgeColor = 'black';
legend.Location = 'northeast';

%% -- Finalizing -- %%
disp('Styling finished sucessfully!')
fig.Visible = 'On'; % show changed figure
set(fig, 'PaperPositionMode', 'auto') % Supress resizing
set(fig, 'InvertHardCopy', 'off'); % setting 'grid color reset' off
saveas(fig, output_file) % save to file
disp(append('Figure saved as: ', cd, output_file))
