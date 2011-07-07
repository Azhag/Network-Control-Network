function H = RNNAnimation(E,H,network,x,t_step)

    if ~isstruct(H)
        H.fig=findobj(0,'name','Net Simulation');
        
        if isempty(H.fig)
            H.fig = figure();
        else
            H.fig = figure(2);
        end
        figure(H.fig);
        clf;
        
        set(H.fig,'NumberTitle','off','DoubleBuffer','on',...
            'BackingStore','on','Renderer','OpenGL',...
            'Name','Net Simulation','MenuBar','none','Position',[600, 100, 500, 500]);
        title('Net Simulation');

        H.UserData = zeros(E.NHid+2*E.NOut,1000);
        for i=1:E.NHid
            subplot(E.NHid+E.NOut,1,i);
            H.rateplot(i) = line('Xdata',1:t_step,'Ydata',H.UserData(i,1:t_step),'Color','b','LineWidth',2);
        end
        
        for i=1:E.NOut
            subplot(E.NHid+E.NOut,1,i+E.NHid);
            H.outputplot(i,1) = line('Xdata',1:t_step,'Ydata',H.UserData(i+E.NHid,1:t_step),'Color','r','LineWidth',2);
            hold on;
            H.outputplot(i,2) = line('Xdata',1:t_step,'Ydata',H.UserData(i+E.NHid+E.NOut,1:t_step),'Color','g','LineWidth',2);
            hold off;
        end
        
    else
        H.UserData(1:E.NHid,t_step) = network.r(1:E.NHid);
        H.UserData(E.NHid+1:E.NHid+E.NOut,t_step) = network.z(1:E.NOut);
        H.UserData(E.NHid+E.NOut+1:E.NHid+2*E.NOut,t_step) = x(1:E.NOut);
        for i=1:E.NHid
            set(H.rateplot(i),'Xdata',1:t_step,'Ydata',H.UserData(i,1:t_step));
        end
        
        for i=1:E.NOut 
            set(H.outputplot(i,1),'Xdata',1:t_step,'Ydata',H.UserData(i+E.NHid,1:t_step));
            set(H.outputplot(i,2),'Xdata',1:t_step,'Ydata',H.UserData(i+E.NHid+E.NOut,1:t_step));
        end
        
    end
end