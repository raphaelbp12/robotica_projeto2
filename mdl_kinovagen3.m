
d1 = 0*(0.1564 + 0.1284);
d2 = 0.0054 + 0.0064;
d3 = 0.2104 + 0.2104;
d4 = 0.0064 + 0.0064;
d5 = 0.2084 + 0.1059;
d7 = 0*(0.1059 + 0.0615);

%All link lengths and offsets are measured in m
clear links
%            theta    d           a       alpha
links = [
	    Link([0        -d1           0       pi/2 0 ], 'standard')
		Link([0        0           0       pi/2 0 pi], 'standard')
		Link([0        -d3           0       pi/2 0 pi], 'standard')
		Link([0        0           0       pi/2 0 pi], 'standard')
		Link([0        -d5           0       pi/2 0 pi], 'standard')
		Link([0        0             0       pi/2 0 pi], 'standard')
        Link([0        -d7            0       pi   0 pi], 'standard')

	];


gen3=SerialLink(links, 'name', 'Kinova Gen3');
gen3.base=trotx(pi);

qz = [0 0 0 0 0 0 0];
qd = [0 41.4 0 90 0 -41.4 0]*pi/180;
qr = [0 0  0 90 180 0 0]*pi/180;



save_figure = true;
plot_figures = true;

if plot_figures
    figure(1);
    close(1);
    gen3.plot(qr, 'floorlevel', -0.1, 'noname', 'notiles');
    if save_figure
        export_fig('./latex/figs/ex1_ready', '-pdf', '-painters', '-transparent');
    end
end

traj_num = 2;
control_num = 1;

%jacob_max = 5.229;
%jacob_max = 4.277;
%xd_ponto_max = 0.2356;
%e_max = 0.1417;

%K = ((3/jacob_max) - xd_ponto_max)/e_max

%K = 1;

        switch traj_num
            case 1 % trajetória a
            traj_s = 'a_';
            case 2 % trajetória b
            traj_s = 'b_';
            case 3 % trajetória c
            traj_s = 'c_';
        end
        switch control_num
            case 1 % controle 1
                ctrl = 1;
                ctrl_s = '1';
                alpha = 1;
                if traj_num == 1
                    K = 7.24;
                elseif traj_num == 2
                    K = 8.57;
                else
                    K = 8.57;
                end
            case 2 % controle 2a
                ctrl = -1;
                ctrl_s = '2';
                alpha = 0;
                if traj_num == 1
                    K = 8.91;
                elseif traj_num == 2
                    K = 8.91;
                else
                    K = 8.91;
                end
        end

sim('kinctrlkinova');
if plot_figures
            close(1);
            figure(1);
            close(1);
            %figure(1);
            %jFrame = get(handle(figure(1)), 'JavaFrame');
            %pause(1);
            %jFrame.setMaximized(1);
            %antro.plot(q0', 'floorlevel', -0.1, 'noname', 'notiles', 'trail', 'b', 'delay', 0, 'noraise')
            %sq = size(q.signals.values);
            %for k = 1:sq(3)
            %   antro.animate(q.Data(:,:,k)');
            %end


            % preparando plots
            stime = size(x_sist.time);
            xplot = zeros(1, stime(1));
            yplot = zeros(1, stime(1));
            zplot = zeros(1, stime(1));

            % plot x
            plot3(x_desejado.Data(:,1)', x_desejado.Data(:,2)', x_desejado.Data(:,3)', 'r');
            hold on;
            for k = 1:stime(1)
                xplot(k) = x_sist.signals.values(k, 1);
                yplot(k) = x_sist.signals.values(k, 2);
                zplot(k) = x_sist.signals.values(k, 3);
            end
            plot3(xplot, yplot, zplot);
            
            axis([0.2 0.7 -1.5 1.5 -0.1 0.5])
            grid on;
            xlabel('x'); ylabel('y'); zlabel('z');
            hold off;
            legend({'$x_d$', '$x$'},'Interpreter','latex');

            if traj_num == 3
                axis manual;
                hold on;
                [X,Y] = meshgrid(-10:.1:10);
                a=1; b=-1; c=1; d=(0.456 + 0.2);
                Z=(d- a * X - b * Y)/c;
                surf(X,Y,Z, 'LineStyle', 'none', 'FaceAlpha', 0.5, 'EdgeAlpha', 0.5)
                colormap summer
                xlabel('x'); ylabel('y'); zlabel('z');
                hold off;
                if save_figure
                    export_fig(['latex/figs/ex1_' traj_s ctrl_s '_x'], '-png', '-opengl');
                end
            elseif save_figure
                export_fig(['latex/figs/ex1_' traj_s ctrl_s '_x'], '-pdf', '-painters', '-transparent');
            end
            
            close(1);
            axis auto;
        
            % plot erro
            x1plot = zeros(1, stime(1));
            x2plot = zeros(1, stime(1));
            x3plot = zeros(1, stime(1));
            for k = 1:stime(1)
                x1plot(k) = e.signals.values(k, 1);
                x2plot(k) = e.signals.values(k, 2);
                x3plot(k) = e.signals.values(k, 3);
            end
            plot(e.time, x1plot, e.time, x2plot, e.time, x3plot);
            xlabel('time (s)'); ylabel('e (m)');
            legend('e_1', 'e_2', 'e_3');
            if save_figure
                export_fig(['latex/figs/ex1_' traj_s ctrl_s '_e'], '-pdf', '-painters', '-transparent');
            end

            % plot u
            u1plot = zeros(1, stime(1));
            u2plot = zeros(1, stime(1));
            u3plot = zeros(1, stime(1));
            u4plot = zeros(1, stime(1));
            for k = 1:stime(1)
                u1plot(k) = u.signals.values(k, 1);
                u2plot(k) = u.signals.values(k, 2);
                u3plot(k) = u.signals.values(k, 3);
                u4plot(k) = u.signals.values(k, 4);
            end
            plot(e.time, u1plot, e.time, u2plot, e.time, u3plot, e.time, u4plot);
            xlabel('time (s)'); ylabel('u = $\dot{\theta}$','Interpreter','latex');
            legend({'$\dot{\theta}_1$', '$\dot{\theta}_2$', '$\dot{\theta}_3$', '$\dot{\theta}_4$'},'Interpreter','latex');
            
            if save_figure
                export_fig(['latex/figs/ex1_' traj_s ctrl_s '_dq'], '-pdf', '-painters', '-transparent');
            end
end