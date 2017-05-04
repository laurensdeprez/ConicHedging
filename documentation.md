ConicHedging
============

## binomial tree 

### scripts

conic_delta_hedging_bin_tree.m : script for delta hedging in binomial trees

### functions

## trinomial tree 

### scripts

### functions

## Black-Scholes scripts and functions

### scripts

conic_delta_hedging_B_S.m : script for delta hedging in Black-Scholes

### functions

B_S.m: simulation of N stock prices S_T under Black-Scholes

B_S_d1.m : calculates d1 of the Black-Scholes model

B_S_d2.m : calculates d2 of the Black-Scholes model

## Variance-Gamma scripts and functions

## extra scripts

Example5_3.m : script for example 5.3 in ACF<sup>[1](#myfootnote1)</sup>

conic_delta_hedging_tri_tree.m : script for delta hedging in trinomial trees

multinomial_approx_VG.m : script for approximating the VG process with a multinomial tree

conic_dynamic_hedging.m : script for dynamic hedging 

## distortion functions

distortion.m : calling the different distortions

WangTrans.m : Wang transformation function

MinVar.m    : MINVAR distortion function

MaxVar.m    : MAXVAR distortion function

MinMaxVar.m : MINMAXVAR distortion function

MaxMinVar.m : MAXMINVAR distortion function 

## pricing functions

bid_bin_tree.m : bid price calculation functions in binomial tree

ask_bin_tree.m : ask price calculation functions in binomial tree

bid_tri_tree.m : bid price calculation functions in trinomial tree

ask_tri_tree.m : ask price calculation functions in trinomial tree

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