ConicHedging
============

## scripts

Example5_3.m : script for example 5.3 in ACF<sup>[1](#myfootnote1)</sup>

conic_delta_hedging_bin_tree.m : script for delta hedging in binomial trees

conic_delta_hedging_tri_tree.m : script for delta hedging in trinomial trees

conic_delta_hedging_B_S.m : script for delta hedging in Black-Scholes

multinomial_approx_VG.m : script for approximating the VG process with a multinomial tree

conic_dynamic_hedging.m : script for dynamic hedging 

## distortion functions

distortion.m : calling the different distortions

WangTrans.m : Wang transformation function

MinVar.m    : MINVAR distortion function

MaxVar.m    : MAXVAR distortion function

MinMAxVar.m : MINMAXVAR distortion function

MaxMinVar.m : MAXMINVAR distortion function 

## pricing functions

***_bin_tree.m : ask and bid price calculation functions in binomial tree

***_tri_tree.m : ask and bid price calculation functions in trinomial tree

***_B_S.m : ask and bid price calculation functions under Black-Scholes

## payoff functions

payoff.m : calling different payoff functions

payoff_call.m : payoff of European call option

payoff_put.m : payoff of European put option

## characteristic functions

char_function_multinomial.m : characteristic function for multinomial tree

char_function_VG.m : characteristic function for VG process

## test functions

isprobabilty.m : check if input is  numeric and between zero and one

ispositive.m : check if input is  numeric and positive

## other functions

cond_prob_multinomial.m : determine conditional jump probabilities for multinomial tree when approximating a VG process

states_tri_tree.m : calculate the states u, m and d for a trinomial tree

<a name="myfootnote1">1</a> ACF: Applied Conic Finance by D. Madan and W. Schoutens 