cnet = RNN(1,1500,5,1.0,1.5,0.1,1e-3);

t_max = 10000; 
E = {};
E.NOut = 3;
E.NHid = 2;
H = RNNAnimation(E,[],cnet,zeros(5,1),1);

delta = 0;
ddelta_dt = 0;

idxs = 2:1500;
for t_step=1:t_max
    
    cnet    = cnet.FProp(delta,idxs);
    
    %W1z     = cnet.Wfb(1,:)';
    f = 0.5*sin(t_step/15.);
    delta_old = delta;
    delta   = ((f - cnet.r(1)))^2.;
    ddelta_dt = 1.*(delta-delta_old) + 0.4*delta;
    
    if t_step > 20
        cnet    = cnet.NaturalLearn(-ddelta_dt);
    end

    
    H = RNNAnimation(E,H,cnet,[delta, f, ddelta_dt],t_step);
    drawnow;
end