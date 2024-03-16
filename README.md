# Get insight in your Opponent's Rock-Paper-Scissors Strategy

![Immagine 15-03-24 alle 23 19](https://github.com/frederikpanse/rock-paper-scissors_mpt/assets/81534893/3bd43ebe-22d0-459d-b803-f7b0901b7fcc)

Our multinomial processing tree (MPT) model produces Bayesian estimates for relevant cognitive processes during the rock-paper-scissors game. This group project was developed in the 2024 [Quantitative Thinking](https://quantitative-thinking.eu/seminar-2024/) seminar in Balatonföldvár. The data was provided [here](https://github.com/hrgodmann/BayesianBalaton/tree/master).

### Simulated data with added biases

#### Distribution of the samples for parameters
<img width="1136" alt="simulated_g" src="https://github.com/frederikpanse/rock-paper-scissors_mpt/assets/81534893/df82b2b1-f157-4810-957b-7250c652fafb">

- $s = p(stay)$ &rarr; the probability to **stay** at the previous shape
  - probability to choose paper again if you used paper in the previous trial
- $b = p(beat)$ &rarr; if you switch, the probability to choose the shape that **beats** your previous shape
  - probability to switch to rock if you switch from using scissors in the previous trial

We use a tree for each condition: (1) lose, (2) win, or (3) draw in the previous trial.

#### Densities and Bayes Factor

Player_A:

<img width="1361" alt="s_Player_A_g" src="https://github.com/frederikpanse/rock-paper-scissors_mpt/assets/81534893/37e66511-639a-44e4-9878-817c190d6cc1">

- BF = NA &rarr; very high evidence for the alternative hypothesis because there is no density overlap at $\frac{1}{3}$

<img width="1362" alt="b_Player_A_g" src="https://github.com/frederikpanse/rock-paper-scissors_mpt/assets/81534893/bb91c5d6-de9c-4884-b661-48b4205a5b18">

Player_B:

<img width="1360" alt="s_Player_B_g" src="https://github.com/frederikpanse/rock-paper-scissors_mpt/assets/81534893/ef0aeb25-d225-4480-8c2e-89627bc3e50e">

<img width="1359" alt="b_Player_B_g" src="https://github.com/frederikpanse/rock-paper-scissors_mpt/assets/81534893/4c2636dc-22e6-4f98-8e0f-1191c5d545a2">


## What else you can find in this repo

In the [doc](/doc) directory you will find the slides for the presentation at the seminar and in [doc/fig](/doc/fig) you will find a bunch of figures.

The stan code for our model is in [src](/src).

If you want to replicate our data analysis, you will find our code in [exp](/exp).

And in [dat](/dat) we stored the provided datasets.
