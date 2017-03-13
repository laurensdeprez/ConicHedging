close all;
%% conic delta hedging in trinomial tree
S_0 = 100;                       % init. stock price
s = 0.2;                         % volatility
r = 0.01;                        % interest
T = 1;                           % maturity
K = S_0;                         % strike ATM
delta_range = [-2,2];            % [delta_min, delta_max]
delta_precision = 4000;          % number of deltas
option_type = 'call';            % option type
%% risk neutral
price = risk_neutral_tri(S_0,s,r,T,K,option_type);
disp(['risk neutral price ',num2str(price)])
%% bid
[bid_h,bids,delta_bid,deltas] = bid_tri_tree(S_0,s,r,T,K,option_type,delta_range,delta_precision);
disp(['bid (d) ',num2str(bid_h)])
disp(['bid delta (d) ',num2str(delta)])
[bid,~,~,~] = bid_tri_tree(S_0,s,r,T,K,option_type,delta_range,delta_precision,'hedged',false);
disp(['bid ',num2str(bid)])
figure()
plot(deltas, bids,'LineWidth',2)
hold on
plot(deltas, bid*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('bid portfolio','FontSize',15)
leg = legend('\Delta hedged','unhedged');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
%% ask
[ask_h,asks,delta_ask,deltas] = ask_tri_tree(S_0,s,r,T,K,option_type,delta_range,delta_precision);
disp(['ask (d) ',num2str(ask_h)])
disp(['ask delta (d) ',num2str(delta)])
[ask,~,~,~] = ask_tri_tree(S_0,s,r,T,K,option_type,delta_range,delta_precision,'hedged',false);
disp(['ask ',num2str(ask)])
figure()
plot(deltas, asks,'LineWidth',2)
hold on
plot(deltas, ask*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('ask portfolio','FontSize',15)
leg = legend('\Delta hedged','unhedged');
set(gca,'fontsize',12)
set(leg,'fontsize',12)