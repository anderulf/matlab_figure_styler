%% ------ Add style to figure ----- %%
clc
clear all;
warning('off') % disabled warning messages from importing .fig created by simulink scope

%% -- Settings -- %%
figure_title = 'Rogowski coil and current transformer measurements'; % String for title
filename = 'rog_vs_ideal'; % filename of inputfile in .fig format
prefix = 'images/'; % The folder where the figure is stored, and where output is saved
x_label = 'Time [t]';
y_label = 'Current [A]';
output_type = '.png';
label_font_size = 18;
title_font_size = 24;

%% -- Initial setup -- %
input_type = '.fig';

input_file = append(prefix, filename, input_type);
output_file = append(prefix, filename, output_type);

% Open filename
disp(append('Styling figure: ', input_file))
fig = openfig(input_file, 'invisible');
axes = fig.CurrentAxes;
legend = axes.Legend;
%% Set basic data
fig.Name = append('Figure Styling for: ', output_file); % name of window 

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
