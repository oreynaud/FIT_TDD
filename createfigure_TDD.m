function createfigure_TDD(parm_list)
%CREATEFIGURE(XDATA1, YDATA1, ZDATA1)
%  XDATA1:  surface xdata
%  YDATA1:  surface ydata
%  ZDATA1:  surface zdata

% 2D histogram
[h,xy]=hist3([parm_list(1,:); parm_list(2,:)].',[40 40]);

% convert to percents (and invert for easy color mapping)
h=100*h./sum(h(:));
[X,Y] = meshgrid(xy{1},xy{2});

% Create figure
figure1 = figure('Renderer','zbuffer');
colormap('hot');
% Create axes
axes1 = axes('Parent',figure1,'CLim',[-max(h(:)) 0]);
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0.367450811879945 1.02484185876884]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[5.147860413685 12.2672357858625]);
view(axes1,[-0.5 90]);
grid(axes1,'on');
hold(axes1,'on');
% Create ylabel
ylabel({'Cell radius R [um]'});
% Create xlabel
xlabel({'Intracellular volume fraction f'});
% Create title
title({'HCT116'});

% plot
surf(X,Y,-h.');axis square
colorbar;

