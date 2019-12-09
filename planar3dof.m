clear;
clear L

save_figure = true;
plot_figures = true;

L(1) = Link([ 0 0 0.5	0	0], 'standard');
L(2) = Link([ 0 0 0.5	0	0], 'standard');
L(3) = Link([ 0 0 0.5	0	0], 'standard');


%syms t1 t2 t3;

%x = [1 0 0]';
%y = [0 1 0]';
%z = [0 0 1]';


%h1 = z;
%h2 = z;
%h3 = z;


%R01 = rotz(t1);
%R12 = rotz(t2);
%R23 = rotz(t3);

%R02 = R01 * R12;
%R03 = R02 * R23;

%p01 = 0;
%p12 = 0.5*x;
%p23 = 0.5*x;
%p3E = 0.5*x;

%p3E_0 = R03 * p3E;
%p2E_0 = R02 * p23 + p3E_0;
%p1E_0 = R01 * p12 + p2E_0;

%JE_0 = [ cross(h1, p1E_0) cross(h2, p2E_0) cross(h3, p3E_0); h1 h2 h3 ];


%
% some useful poses
%
qz = [0 0 0]; % zero angles, L shaped pose
qr = [0 pi/2 -pi]; % ready pose, arm up
qstretch = [0 0 -pi/2];
q0 = [pi -pi/2 -pi/2];


%ex2_func = matlabFunction(JE_0);
%JA = ex2_func(qstretch(1), qstretch(2), qstretch(3));


planar = SerialLink(L);

clear L
planar.name = 'Plannar 3DOF';



% trajetória
syms t real;
xd = [0.25*(1 - cos(pi*t)) 0.25*(2 + sin(pi*t)) 0 0 0 sin(t*pi/24)]';
dxd = diff(xd, t);
matlabFunction(xd, 'File', 'xdFunc');
matlabFunction(dxd,  'File', 'dxdFunc');

% manipulabilidade
syms t1 t2 t3 real;
manip = 0.5*(sin(t2)^2 + sin(t3)^2);
manipParc = [diff(manip, t1); diff(manip, t2); diff(manip, t3)];
matlabFunction(manip, manipParc, 'File', 'manipFunc','Vars', [t1 t2 t3]);


% limite das juntas
tm = [-2*pi -pi/2  -3*pi/2];
tM = [2*pi pi/2 -pi/2];
limJun = 0;
ts = [t1 t2 t3];
n = 3;
for i = 1:n
    limJun = limJun + ((ts(i) - (tM(i) + tm(i))/2)/(tM(i) - tm(i)))^2;
end
limJun = -limJun/(2*n);
limJunParc = [diff(limJun, t1); diff(limJun, t2); diff(limJun, t3)];
matlabFunction(limJun, limJunParc, 'File', 'limJunFunc','Vars', [t1 t2 t3]);


% plot q0
if plot_figures
    figure(1);
    close(1);
    planar.plot(qz, 'floorlevel', -0.3, 'noname', 'notiles', 'zoom', 0.6);
    if save_figure
        export_fig(['latex/figs/ex2_planar_0'], '-pdf', '-painters', '-transparent');
    end
    figure(1);
    close(1);
    planar.plot(q0, 'floorlevel', -0.3, 'noname', 'notiles');
    if save_figure
        export_fig(['latex/figs/ex2_planar_tetha0'], '-pdf', '-painters', '-transparent');
    end
end

for i = 1:3 % controle 1, 2, 2a1, 2a100 e 2b1
    figure(1);
    close(1);
    K0 = 0;
    switch i
        case 1 % controle 1
            ctrl = 1
            ctrl_s = '1';
            K = 50;
            sim('planar3dof_sim');
        case 2 % controle 2
            ctrl = 2
            ctrl_s = '2a';
            K = 50;
            sim('planar3dof_sim2a');
        case 3 % controle 2a1
            ctrl = 3
            ctrl_s = '2b';
            K = 50;
            K0 = 1;
            sim('planar3dof_sim2b');
    end
    
    if plot_figures
        figure(1);
        close(1);
        
        % preparando plots
        stime = size(x.time);
        xplot = zeros(1, stime(1));
        yplot = zeros(1, stime(1));
        zplot = zeros(1, stime(1));
        
        % plot trajetória
        %planar.plot(q.signals.values(:,:,:)', 'floorlevel', -0.3, 'noname', 'notiles');
        %planar.plot(q.signals.values(1,:));
        %plot3(q.signals.values(:,1)', q.signals.values(:,2)', q.signals.values(:,3)', 'r');

        % plot x
        qsize = size(q.signals.values);
        planar.plot(q.signals.values(qsize(1),:));
        hold on;
        plot3(x_desejado.Data(:,1)', x_desejado.Data(:,2)', x_desejado.Data(:,3)', 'r');
        hold on;
        for k = 1:stime(1)
            xplot(k) = x.signals.values(1, k);
            yplot(k) = x.signals.values(2, k);
            zplot(k) = x.signals.values(3, k);
        end
        plot3(xplot, yplot, zplot);
        if save_figure
            export_fig(['latex/figs/ex2_' ctrl_s '_traj'], '-pdf', '-painters', '-transparent');
        end
        
        figure(1);
        close(1);
        
        % plot erro
        estime = size(e.time);
        x1plot = zeros(1, stime(1));
        x2plot = zeros(1, stime(1));
        x3plot = zeros(1, stime(1));
        if ctrl == 1
            x6plot = zeros(1, stime(1));
        end
        for j = 1:stime(1)
            x1plot(j) = e.signals.values(j, 1);
            x2plot(j) = e.signals.values(j, 2);
            x3plot(j) = e.signals.values(j, 3);
        end
        plot(e.time, x1plot, e.time, x2plot, e.time, x3plot);
        legend('e x_1 (m)', 'e x_2 (m)', 'e x_3 (m)');
        xlabel('time (s)'); ylabel('erro');
        if save_figure
            export_fig(['latex/figs/ex2_' ctrl_s '_e'], '-pdf', '-painters', '-transparent');
        end
        
        % plot q
        q1plot = zeros(1, stime(1));
        q2plot = zeros(1, stime(1));
        q3plot = zeros(1, stime(1));
        for k = 1:stime(1)
            q1plot(k) = q.signals.values(k, 1);
            q2plot(k) = q.signals.values(k, 2);
            q3plot(k) = q.signals.values(k, 3);
        end
        plot(e.time, q1plot, e.time, q2plot, e.time, q3plot);
        xlabel('time (s)'); ylabel('u = $\dot{\theta}$','Interpreter','latex');
        legend({'$\theta_1$', '$\theta_2$', '$\theta_3$'},'Interpreter','latex');
        if save_figure
            export_fig(['latex/figs/ex2_' ctrl_s '_q'], '-pdf', '-painters', '-transparent');
        end
        
        % plot dq
        dq1plot = zeros(1, stime(1));
        dq2plot = zeros(1, stime(1));
        dq3plot = zeros(1, stime(1));
        for k = 1:stime(1)
            dq1plot(k) = dq.signals.values(k, 1);
            dq2plot(k) = dq.signals.values(k, 2);
            dq3plot(k) = dq.signals.values(k, 3);
        end
        plot(e.time, dq1plot, e.time, dq2plot, e.time, dq3plot);
        xlabel('time (s)'); ylabel('u = $\dot{\theta}$','Interpreter','latex');
        legend({'$\dot{\theta}_1$', '$\dot{\theta}_2$', '$\dot{\theta}_3$'},'Interpreter','latex');
        if save_figure
            export_fig(['latex/figs/ex2_' ctrl_s '_dq'], '-pdf', '-painters', '-transparent');
        end
        
        % plot manip
        if i < 3
            plot(e.time, manip_val.signals.values);
            xlabel('time (s)'); ylabel('$\omega(\theta)$','Interpreter','latex');
            if save_figure
                export_fig(['latex/figs/ex2_' ctrl_s '_manip'], '-pdf', '-painters', '-transparent');
            end
        end
        
        % plot limJun
        if (i > 2)
            plot(e.time, limJun_val.signals.values);
            xlabel('time (s)'); ylabel('$\omega(\theta)$','Interpreter','latex');
            if save_figure
                export_fig(['latex/figs/ex2_' ctrl_s '_lim_jun'], '-pdf', '-painters', '-transparent');
            end
        end
    end
end
