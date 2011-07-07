classdef RNN
    
    properties
        
        nIn;
        nHid;
        nOut;
        
        dt;
        t;
        
        x;
        r;
        z;
        
        W;
        Win;
        Wfb;
        Wz;
        
        F;
        Fr;
        eta;
        sigma;
        noise;
        
        eOut;
        
    end
    
    methods

        function obj = RNN(nIn,nHid,nOut,gff,gfb,sigma,eta)
           
            obj.nIn     = nIn;
            obj.nHid    = nHid;
            obj.nOut    = nOut;
            
            obj.dt      = 0.1;
            
            obj.x       = randn(nHid,1);
            obj.r       = tanh(obj.x);
            obj.z       = zeros(nOut,1);
            
            obj.W       = gfb*randn(nHid,nHid)/sqrt(nHid);
            obj.Win     = gff*randn(nHid,nIn)/sqrt(nIn);
            obj.Wfb     = gfb*randn(nHid,nOut)/sqrt(nOut);
            obj.Wz      = zeros(nOut,nHid);
            
            obj.t       = 2;
            obj.F       = eye(nHid,nHid);
            obj.Fr      = zeros(nHid,1);
            obj.eta     = eta;
            obj.sigma   = sigma;
            obj.noise   = zeros(nOut,1);
            
            obj.eOut    = zeros(nOut,nHid);   
            
        end
         
        function obj = FProp(obj,xin,idxs)
            
            dt          = obj.dt;   
            
            obj.x       = (1.0-dt)*obj.x + dt*(obj.W*obj.r + [0;obj.Win(idxs,:)*xin] + obj.Wfb*obj.z);
            obj.r       = tanh(obj.x);                                    
            
            obj.noise   = obj.sigma*randn(obj.nOut,1);
            obj.eOut    = 0.5*obj.eOut + 0.5*obj.noise*(obj.F*obj.r)';
            obj.z       = obj.Wz*obj.r + obj.noise;
            
        end
               
        function obj = Fisher(obj)
           
            eps_t       = 1/obj.t;
            meps_t      = 1-eps_t;
            
            obj.t       = obj.t + 1;
            F           = obj.F;
            r           = obj.r;
            Fr          = F*r;
            obj.Fr      = Fr;
            
            obj.F       = (meps_t)^(-1)*(F - eps_t*Fr*Fr'/(meps_t + eps_t*r'*Fr));            
            obj.t       = obj.t + 1;

        end        
        
        function obj = NaturalLearn(obj,R)
            
            obj.Wz      = obj.Wz + obj.eta*R*obj.eOut;
            
        end
            
        function obj = Learn(obj,R)
           
            obj         = obj.Fisher();
            obj         = obj.NaturalLearn(R);
            
        end
        
        function obj = ErrorLearn(obj,delta)
           
            obj         = obj.Fisher();
            obj.Wz      = obj.Wz + obj.eta*delta*obj.Fr';
            
        end
        
        function obj = Reset(obj,gain,t_steps)
            
            for i=1:t_steps
                
                obj     = obj.FProp(gain*ones(obj.nIn,1));
                
            end
            
        end
                
    end
    
end

