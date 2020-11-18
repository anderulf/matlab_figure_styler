%% ------ Add style to figure ----- %%
clear legend % legend must be cleared for it to be added from cell of strings later
close all

%% -- Data -- %%
% Change this array to the values you want to plot ie. voltage to plot
% out.voltage
% Input should be a timeseries from simulink with Data and Time values. 
input_data = [ideal_current, R10e2, R50e2, R10e3, R10e4]; 

%% -- Settings -- %%
% Set index of store_at such that:
% store_at = 'current folder': store in current folder (same folder as this script)
% store_at = 'above folder': store in one folder above current folder
% store_at = 'directory': store in directory inputted, ue cd in command
% window to print the directory of the current folder
store_at = 'directory';
% File settings
filename = 'rc_output_load_test'; % filename of output in output_type format
output_type = '.eps'; % '.png', '.eps' or '.jpg'

% Formatting
figure_title = 'Rogowski Coil Measurements for Different Output Loads'; % String for title
x_label = 'Time [t]';
y_label = 'Current [A]';
label_font_size = 16; % text size for labels, ticks, legend
title_font_size = 20; % text size for title above plot
line_width = 1; % thickness of lines in plot
overlapping_lines = 1; % adds dashed to ? lines
overlap_line = 5; % Set which should be dashed, 0 every other. 1-> last line
% Situational
custom_xlim = [0, 0.05];%0; % Native: 0, Custom: [x0, xn]
directory = '/Users/AUlfsnes/Documents/Skole/Prosjektoppgave/Simulink/images/'; % The folder where the figure is stored if store_at=='directroy'
unit_change = 1; % Change units with this value to get the unit in the labels ie 10e-3 to get kV, 1 for none

%% -- Initial setup -- %
% Set output format type
if strcmp(output_type, '.png')
    formattype = '-dpng';
elseif strcmp(output_type, '.eps')
    formattype = '-depsc';
elseif strcmp(output_type, '.jpg')
    formattype = '-djpeg'
else
    disp(append('Error: File type : ', output_type, ' is not supported.'))
end
% Set directory
if strcmp(store_at, 'current folder')
    directory = '';
elseif strcmp(store_at, 'above folder')
    current_directory = cd;
    folders = strfind(current_directory,'/');
    directory = append(current_directory(1:folders(end)-1), '/');
elseif ~strcmp(store_at, 'directory')
    disp('store_at setting is not correct')
end

disp('Creating plot from workshop data')
fig = gcf;
fig.Visible = 'off'; % Do not show figure before it has been styled
hold on
% Plot data from input_data
for i = 1:length(input_data)
    plot(input_data(i).Time, input_data(i).Data*unit_change, 'DisplayName', input_data(i).Name)
end
% Extract axes from get current axis
axes = gca;

%% Set basic data
fig.Name = filename; % name of window
if length(custom_xlim) ~= 1
    disp('Note: Custom XLim was used')
    axes.XLim = custom_xlim;
else
    axes.XLim = [input_data(1).Time(1), input_data(1).Time(end)];
end
%% -- Set labels -- %%
xlabel(x_label);
ylabel(y_label);

%% -- Set plot colors -- %%
%fig.Children.Children.Children.BackgroundColor = 'white'; % Color for area outside plot
%fig.Children.BackgroundColor = 'white'; % Color for shadow of plot window
axes.Color = 'white'; % Color for plot area
fig.Color = 'white'; % Color for rest of figure (outside plot area)
grid on % add grid lines to plot
axes.GridColor = [0.15, 0.15, 0.15]; % Paint grid gray

%% -- Set grid properties -- %%
axes.XColor = 'black';
axes.YColor = 'black';
axes.FontSize = label_font_size;

%% -- Set title -- %%
axes.Title.FontSize = title_font_size;
if length(figure_title) >= 40
    spaces = strfind(figure_title, ' ');
    possible_indices = find(spaces >= (length(figure_title)/2));
    index = spaces(possible_indices(1));
    first_sub = extractBefore(figure_title, index);
    second_sub = extractAfter(figure_title, index);
    axes.Title.String = append(first_sub, newline, second_sub);
else
    axes.Title.String = figure_title;
end
axes.Title.Color = 'black';

%% -- Set legends -- %%
for i = 1:length(input_data)
    legendCell{i} = input_data(i).Name;
end
legend(legendCell);
axes.Legend.FontSize = label_font_size;
axes.Legend.Color = 'white';
axes.Legend.TextColor = 'black';
axes.Legend.EdgeColor = 'black';
axes.Legend.Location = 'northeast';

%% -- Line properties -- %%
lines = findobj(fig, 'Type', 'Line');
for i = 1:length(lines)
    lines(i).LineWidth = line_width;
    if overlap_line ~= 0 && i == overlap_line
        lines(i).LineStyle = ':';
        lines(i).LineWidth = 2*line_width; % compensate for visibility¨
    end
    if overlapping_lines == 1 && rem(i,2) == 0 && overlap_line == 0
        lines(i).LineStyle = ':';
        lines(i).LineWidth = 2*line_width; % compensate for visibility
    end
end

%% -- Finalizing -- %%
disp('Styling finished sucessfully!')
fig.Visible = 'on'; % show changed figure
fig.PaperPositionMode = 'auto'; % Supress resizing
fig.Renderer = 'painters'; % Use painter rendering mode for better 2D rendering
fig.InvertHardcopy = 'off'; % setting 'grid color reset' off
duplicate = 1;
saved_duplicate = 0;
while 1
    if isfile(append(directory, filename, output_type))
        if duplicate > 1 % Remove the last duplicate label
            indices = strfind(filename, '_'); % Find underscores
            index = indices(end); % Extract last element
            filename = extractBefore(filename, index);
        end
        filename = append(filename, '_', num2str(duplicate)) ;
        duplicate = duplicate + 1;
        saved_duplicate = 1;
    else
        break
    end
end 
if saved_duplicate == 1
    disp('Note: file already exists, saving duplicate')
end
% Create output file name with resulting filename
output_file = append(directory, filename, output_type);
print(fig, output_file, formattype) % save to file
disp(append('Figure saved as: ', output_file))
