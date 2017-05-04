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

conic_delta__gamma_hedging_bin_tree.m : delta gamma hedging in binomial trees

conic_dynamic_hedging_tri_tree.m : conic dynamic delta-gamma hedging of trinom. tree

### functions

risk_neutral_tri.m : risk neutral pricing of option in trinomial tree

bid_tri_tree.m : bid price calculation in trinomial tree

ask_tri_tree.m : ask price calculation in trinomial tree

## Black-Scholes 

### scripts

conic_delta_hedging_B_S.m : delta hedging in Black-Scholes

### functions

B_S.m: simulation of N stock prices S_T under Black-Scholes

B_S_d1.m : calculates d1 of the Black-Scholes model

B_S_d2.m : calculates d2 of the Black-Scholes model

## Variance-Gamma

### scripts

multinomial_approx_VG.m : approximating the VG process with a multinomial tree

conic_dynamic_hedging.m : dynamic hedging 

### functions

## extra scripts

Example5_3.m : example 5.3 in ACF<sup>[1](#myfootnote1)</sup>

## distortion functions

distortion.m : calling the different distortions

WangTrans.m : Wang transformation function

MinVar.m    : MINVAR distortion function

MaxVar.m    : MAXVAR distortion function

MinMaxVar.m : MINMAXVAR distortion function

MaxMinVar.m : MAXMINVAR distortion function 

## pricing functions





bid_B_S.m : bid price calculation functions under Black-Scholes

ask_B_S.m : ask price calculation functions under Black-Scholes

## payoff of different financial derivatives

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

## other functions

cond_prob_multinomial.m : determine conditional jump probabilities for multinomial tree when approximating a VG process

states_tri_tree.m : calculate the states u, m and d for a trinomial tree

<sup><a name="myfootnote1">1</a></sup> ACF: Applied Conic Finance by D. Madan and W. Schoutens 