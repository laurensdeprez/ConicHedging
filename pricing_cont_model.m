function [bid,bids,delta_b,ask,asks,delta_a,deltas,u_ask,u_bid] = pricing_cont_model(S_0,S_T,q,s,r,T,N,K,option,dist_type,lambda,varargin)
    p = inputParser;
    addRequired(p,'S_0',@ispositive);
    addRequired(p,'S_T',@ispositive);
    addRequired(p,'q',@isnumeric);
    addRequired(p,'s',@ispositive);
    addRequired(p,'r',@ispositive);
    addRequired(p,'T',@ispositive);
    addRequired(p,'N',@ispositive);
    addRequired(p,'K');
    addRequired(p,'option');
    addRequired(p,'dist_type')
    addRequired(p,'lambda')
    defaultDelta_range = [-2,2];
    addOptional(p,'delta_range',defaultDelta_range,@(x)validateattributes(x,{'numeric'},{'numel',2,'increasing'}));
    defaultDelta_precision = 0.01;
    addOptional(p,'delta_precision',defaultDelta_precision,@ispositive);
    parse(p,S_0,S_T,q,s,r,T,N,K,option,dist_type,lambda,varargin{:});
    S_0 = p.Results.S_0;
    S_T = p.Results.S_T;
    r = p.Results.r;
    T = p.Results.T;
    N = p.Results.N;
    K = p.Results.K;
    option = p.Results.option;
    dist_type = p.Results.dist_type;
    lambda = p.Results.lambda;
    delta_range = p.Results.delta_range;
    delta_precision = p.Results.delta_precision;
    % hedged
    hedged = true;
    [ask,asks,delta_a,deltas] = ask_cont_model(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,hedged);
    [bid,bids,delta_b,~] = bid_cont_model(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,hedged);
    % unhedged
    hedged = false;
    [u_ask,~,~,~] = ask_cont_model(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,hedged);
    [u_bid,~,~,~] = bid_cont_model(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,hedged);
end

