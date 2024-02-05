# semianalyticResonance
This python class provides resonance information using semianalytic methods developed in Gallardo (2020, CMDA 132:9)

Only restricted case has been developed yet

User must initialize a resonance as follows:
reso1 = semianalyticResonance(star_mass, a_pla, e_pla, pla_mass, k, kp, e, inc, argper, lonNod)

The class semianalyticResonance() currently has two methods
  1) hamiltonian(a_width, levels) which plots hamiltonian level curves of the theory
  2) sigmas() which gives equilibrium points

Further methods, documentation and examples are in development
