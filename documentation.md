ConicHedging
============

## Binomial tree 

### scripts

conic_delta_hedging_bin_tree.m : delta hedging in binomial trees

### functions

states_bin_tree.m : calculates the Cox-Ross-Rubinstein up and down states of the binom. tree 

bid_bin_tree.m : bid price calculation in binomial tree

ask_bin_tree.m : ask price calculation in binomial tree

## Trinomial tree 

### scripts

conic_delta_hedging_tri_tree.m : delta hedging in trinomial trees

conic_delta__gamma_hedging_tri_tree.m : delta gamma hedging in trinomial trees

conic_dynamic_hedging_tri_tree.m : conic dynamic delta-gamma hedging of trinomial trees

### functions

states_tri_tree.m : calculates up, middle and down state for a trinomial tree

risk_neutral_tri.m : risk neutral pricing of option in trinomial tree

bid_tri_tree.m : bid price calculation in trinomial tree

ask_tri_tree.m : ask price calculation in trinomial tree

## Black-Scholes 

### scripts

conic_delta_hedging_B_S.m : delta hedging in Black-Scholes

### functions

risk_neutral_EC_B_S.m : risk neutral price of European call under Black-Scholes

B_S_d1.m : calculates d1 of the Black-Scholes model

B_S_d2.m : calculates d2 of the Black-Scholes model

B_S.m : simulation of N stock prices S_T under Black-Scholes

bid_B_S.m : bid price calculation under Black-Scholes

ask_B_S.m : ask price calculation under Black-Scholes

## Variance-Gamma

### scripts

multinomial_approx_VG.m : approximating the VG process with a multinomial tree

conic_delta_hedging_VG_stock.m : conic delta hedging under VG stock model

conic_dynamic_hedging.m : dynamic hedging 

### functions

VG_param.m : change variance gamma parametrisation

cond_prob_multinomial.m : conditional jump probabilities for multinomial tree approximation of VG process

char_function_VG.m : characteristic function of VG process

char_function_multinomial.m : characteristic function of multinomial tree

fit_multinomial_VG.m : fit multinomial tree to VG process by matching characteristic functions

VG_stock.m : Simulation of N stock prices S_T under VG stock model

risk_neutral_EC_VG.m : risk neutral pricing of european call under VG using fft

risk_neutral_EC_VG_delta.m : risk neutral pricing delta of european call under VG using fft

## distortion functions

distortion.m : calling the different distortions

WangTrans.m : Wang transformation function

MinVar.m    : MINVAR distortion function

MaxVar.m    : MAXVAR distortion function

MinMaxVar.m : MINMAXVAR distortion function

MaxMinVar.m : MAXMINVAR distortion function 

## payoff of financial derivatives

payoff.m : calling different payoff functions

payoff_call.m : payoff of European call option

payoff_put.m : payoff of European put option

payoff_callspread : payoff of callspread option	

payoff_straddle : payoff of straddle option

## characteristic functions

char_function_multinomial.m : characteristic function for multinomial tree

char_function_VG.m : characteristic function for VG process

## test functions

isprobabilty.m : check if input is  numeric and between zero and one

ispositive.m : check if input is  numeric and positive

## extra scripts

Example5_3.m : example 5.3 in ACF<sup>[1](#myfootnote1)</sup>

<sup><a name="myfootnote1">1</a></sup> ACF: Applied Conic Finance by D. Madan and W. Schoutens 