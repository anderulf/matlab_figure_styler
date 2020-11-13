%% ------ Add style to figure ----- %%
clear legend % legend must be cleared for it to be added from cell of strings later

%% -- Data -- %%
% Change this array to the values you want to plot ie. voltage to plot
% out.voltage
% Input should be a timeseries from simulink with Data and Time values. 
input_data = [out.I_C, out.I_rog]; 

%% -- Settings -- %%
% Set index of store_at such that:
% store_at = 'current folder': store in current folder (same folder as this script)
% store_at = 'above folder': store in one folder above current folder
% store_at = 'prefix folder': store in new folder under folder where this script is
store_at = 'above folder';
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
prefix = 'images/'; % The folder where the figure is stored if store_at=3

%% -- Initial setup -- %
if strcmp(store_at, 'current folder')
    prefix = '';
elseif strcmp(store_at, 'above folder')
    directory = cd;
    folders = strfind(directory,'/');
    prefix = append(directory(1:folders(end)-1), '/');
elseif ~strcmp(store_at, 'prefix folder')
    disp('store_at setting is not correct')
end

output_file = append(prefix, filename, output_type);

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
% input_file = append(prefix, filename, input_type);
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
print('ScreenSizeFigure','-dpng','-r600')
saveas(fig, output_file) % save to file
disp(append('Figure saved as: ', output_file))
