close all;
%% conic delta hedging under VG stock model

S_0 = 100;                       % init. stock price
q = 0;                           % dividend 
s = 0.2;                         % volatility
v = 0.75;                        % param 2 of VG
th = -0.3;                       % param 3 of VG
r = 0.01;                        % interest
T = 1/12;                        % maturity
K = S_0;                         % strike ATM
N = 10000;                       % # monte carlo simulations (WARNING: bigger=slower)
dist_type = 'MinMaxVar';         % distortion function
lambda = 0.10;                   % parameter for distortion               
delta_range = [-2,2];            % [delta_min, delta_max]
delta_precision = 0.01;          % step between deltas
option = 'call';                 % type of option considered

if true
%% hedging
% stock process
S_T = VG_stock(S_0,q,s,v,th,r,T,N);

% bid
[bid,bids,delta_b,deltas] = bid_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision);
[u_bid,~,~,~] = bid_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,'hedged',false);
display(delta_b)
figure()
plot(deltas, bids,'LineWidth',2)
hold on 
plot(deltas, u_bid*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('bid portfolio','FontSize',15)
leg = legend('\Delta hedged','unhedged');
set(gca,'fontsize',12)
set(leg,'fontsize',12)

% ask 
[ask,asks,delta_a,deltas] = ask_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision);
[u_ask,~,~,~] = ask_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,'hedged',false);
display(delta_a)
figure()
plot(deltas, asks,'LineWidth',2)
hold on 
plot(deltas, u_ask*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('ask portfolio','FontSize',15)
leg = legend('\Delta hedged','unhedged');
set(gca,'fontsize',12)
set(leg,'fontsize',12)

% capital 
figure();
capital = asks-bids;
u_cap = u_ask-u_bid;
[M,I] = min(capital);
plot(deltas,capital,'LineWidth',2)
hold on 
plot(deltas, u_cap*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('capital portfolio','FontSize',15)
leg = legend('\Delta hedged','unhedged');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
end

if false
%% stock process
% exact
[C_VG,G_VG,M_VG] = VG_param(s,v,th);
dt = 0.02;
steps = 50;
N_samples = 100;
t = linspace(0,steps*dt,steps+1);
X_t = zeros([steps+1,N_samples]);
figure()
for i=1:(N_samples)
    Xs = gamrnd(dt*C_VG,1/M_VG,[steps,1]);
    Ys = gamrnd(dt*C_VG,1/G_VG,[steps,1]);
    X_t(:,i) = [0; cumsum(Xs-Ys)];
    if (i<=20)
        plot(t,X_t(:,i));
    end
    hold on
end
S = mean(X_t,2);
plot(t,S,'LineWidth',2,'Color','r')
xlabel('t','FontSize',15)
ylabel('X_t','FontSize',15)
set(gca,'fontsize',12)
figure()
omega = 1/v*log(1-s^2/2*v-th*v);
S_t = zeros(steps+1,N_samples);
for i=1:N_samples
    S_t(:,i) = S_0*exp(X_t(:,i)+(r+omega)*transpose(t));
    if (i<=20)
        plot(t,S_t(:,i))
    end
    hold on
end
S = mean(S_t,2);
plot(t,S,'LineWidth',2,'Color','r')
xlabel('t','FontSize',15)
ylabel('S_t','FontSize',15)
set(gca,'fontsize',12)
display(S(steps)-S(1))

% 2M+1 tree approx
M = 10;
delta = 0.0763;
p0 = 0.9492;
ps = cond_prob_multinomial(M,delta,C_VG,G_VG,M_VG);
p_j = ps(1,:);
q_j = ps(2,:);
ps = [(1-p0)*p_j,p0,(1-p0)*q_j];
cdf = cumsum(ps);
x = -(1:M)*delta;
y = (1:M)*delta;
jumps = [x 0 y];
path = zeros(N);
X_t = zeros(steps+1,N_samples);
jump = zeros(steps,1);
indices = 1:(2*M+1);
figure()
for i=1:N_samples
    p = rand(1,steps);
    for j=1:steps
        index = min(indices(cdf >= p(j)));
        jump(j) = jumps(index);
    end
    path = cumsum(jump);
    X_t(:,i) = [0 ; path];
    if (i < 20)
        plot(t, X_t(:,i))
    end
    hold on
end
S = mean(X_t,2);
plot(t,S,'LineWidth',2,'Color','r')
xlabel('t','FontSize',15)
ylabel('X_t','FontSize',15)
set(gca,'fontsize',12)
figure()
S_t = zeros(steps+1,N_samples);
for i=1:N_samples
    S_t(:,i) = S_0*exp(X_t(:,i)+(r+omega)*transpose(t));
    if (i<=20)
        plot(t,S_t(:,i))
    end
    hold on
end
S = mean(S_t,2);
plot(t,S,'LineWidth',2,'Color','r')
xlabel('t','FontSize',15)
ylabel('S_t','FontSize',15)
set(gca,'fontsize',12)
display(S(steps)-S(1))
end