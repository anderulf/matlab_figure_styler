%% ------ Add style to figure ----- %%
clear legend % legend must be cleared for it to be added from cell of strings later

%% -- Data -- %%
% Change this array to the values you want to plot ie. voltage to plot
% out.voltage
% Input should be a timeseries from simulink with Data and Time values. 
input_data = [out.I_C, out.I_rogC]; 

%% -- Settings -- %%
% Set index of store_at such that:
% store_at = 'current folder': store in current folder (same folder as this script)
% store_at = 'above folder': store in one folder above current folder
% store_at = 'directory': store in directory inputted, ue cd in command
% window to print the directory of the current folder
store_at = 'directory';
% File settings
filename = 'rog_vs_ideal_phase_C'; % filename of output in output_type format
output_type = '.png';

% Formatting
figure_title = 'Rogowski Coil and Ideal Current Measurements on phase C'; % String for title
x_label = 'Time [t]';
y_label = 'Current [A]';
label_font_size = 16; % text size for labels, ticks, legend
title_font_size = 20; % text size for title above plot
line_width = 1; % thichkness of lines in plot
overlapping_lines = 1; % adds dashed to ? lines
% Situational
custom_xlim = [0, 0.05]; % Native: 0, Custom: [x0, xn]
directory = '/Users/AUlfsnes/Documents/Skole/Prosjektoppgave/Simulink/images/'; % The folder where the figure is stored if store_at=='directroy'

%% -- Initial setup -- %
if strcmp(output_type, '.png')
    formattype = '-dpng';
elseif strcmp(output_type, '.eps')
    formattype = '-depsc';
elseif strcmp(output_type, '.jpg')
    formattype = '-djpeg'
else
    disp(append('Error: File type : ', output_type, ' is not supported.'))
end
if strcmp(store_at, 'current folder')
    directory = '';
elseif strcmp(store_at, 'above folder')
    current_directory = cd;
    folders = strfind(current_directory,'/');
    directory = append(current_directory(1:folders(end)-1), '/');
elseif ~strcmp(store_at, 'directory')
    disp('store_at setting is not correct')
end

output_file = append(directory, filename, output_type);

disp('Creating plot from workshop data')
fig = gcf;
hold on
for i = 1:length(input_data)
    plot(input_data(i).Time, input_data(i).Data, 'DisplayName', input_data(i).Name)
end
% Open filename
% disp(append('Styling figure: ', input_file))
% for importing figure
% input_type = '.fig';
% input_file = append(directory, filename, input_type);
% fig = openfig(input_file, 'invisible');
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
for i = i:length(lines)
    lines(i).LineWidth = line_width;
    if overlapping_lines == 1
        lines(i).LineStyle = ':';
    end
end

%% -- Finalizing -- %%
disp('Styling finished sucessfully!')
%fig.Visible = 'On'; % show changed figure
fig.PaperPositionMode = 'auto'; % Supress resizing
fig.InvertHardcopy = 'off'; % setting 'grid color reset' off
print(output_file, formattype,'-r0')
%saveas(fig, output_file) % save to file
disp(append('Figure saved as: ', output_file))
