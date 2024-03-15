data {
  array[9] int<lower=0> y;
}
parameters {
  real<lower=0, upper=1> c1;
  real<lower=0, upper=1> b1;
  real<lower=0, upper=1> c2;
  real<lower=0, upper=1> b2;
  real<lower=0, upper=1> c3;
  real<lower=0, upper=1> b3;

}
transformed parameters { 
  vector[9] pcat = [c1,                   // losing condition
		    (1 - c1) * b1,
		    (1 - c1) * (1 - b1),
		    c2,                   // winning condition
		    (1 - c2) * b2,
		    (1 - c2) * (1 - b2), 
		    c3,                   // draw condition
		    (1 - c3) * b3,
		    (1 - c3) * (1 - b3)
		    ]';
}
model {
  // change priors to c around 1/3 and b around 1/2
  [c1, b1, c2, b2, c3, b3]' ~ beta(1, 1);
      y[1:3] ~ multinomial(pcat[1:3]);  // losing
      y[4:6] ~ multinomial(pcat[4:6]);  // winning
      y[7:9] ~ multinomial(pcat[7:9]);  // draw
}
