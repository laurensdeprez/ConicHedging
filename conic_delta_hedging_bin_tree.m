clear;
close all;
%% conic delta hedging in binomial tree
S_0 = 100;                      % init. stock price
s = 0.2;                        % volatility
r = 0.01;                       % interest
T = 1;                          % maturity
K = S_0;                        % strike ATM
delta_range = [-2,2];           % [delta_min, delta_max]
delta_precision = 4000;         % step between deltas
type = 'call';                  % option type
%% up and down state
[u,d] = states_bin_tree(s,T);
%% risk neutral
f_u = payoff(u*S_0,K,type);         % option payout up
f_d = payoff(d*S_0,K,type);         % option payout down
delta_tree = (f_u-f_d)/(S_0*(u-d));
[price,~,~,~] = bid_bin_tree(S_0,s,r,T,K,type,delta_range,delta_precision,'lambda',0,'hedged',false);
disp(['risk neutral price ',num2str(price)])
%% bid 
[bid,bids,delta,deltas] = bid_bin_tree(S_0,s,r,T,K,type,delta_range,delta_precision);
disp(['bid (d) ',num2str(bid)])
disp(['bid delta (d) ',num2str(delta)])
[bid_u,~,~,~] = bid_bin_tree(S_0,s,r,T,K,type,delta_range,delta_precision,'hedged',false);
disp(['bid ',num2str(bid_u)])
figure()
plot(deltas, bids,'LineWidth',2)
hold on
scatter(-delta_tree,bid,80,'r','LineWidth',2)
plot(deltas, bid_u*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('bid portfolio','FontSize',15)
leg = legend('\Delta line','-\Delta_{tree}','unhedged');
set(leg,'FontSize',12)
set(gca,'fontsize',12)

%% ask 
[ask,asks,delta,deltas] = ask_bin_tree(S_0,s,r,T,K,type,delta_range,delta_precision);
disp(['ask (d) ',num2str(ask)])
disp(['ask delta (d) ',num2str(delta)])
[ask_u,~,~,~] = ask_bin_tree(S_0,s,r,T,K,type,delta_range,delta_precision,'hedged',false);
disp(['ask ',num2str(ask_u)])
figure()
plot(deltas, asks,'LineWidth',2)
hold on
scatter(-delta_tree,ask,80,'r','LineWidth',2)
plot(deltas, ask_u*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('ask portfolio','FontSize',15)
leg = legend('\Delta line','-\Delta_{tree}','unhedged');
set(leg,'FontSize',12)
set(gca,'fontsize',12)
