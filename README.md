# semianalyticResonance
This python class provides resonance information using semianalytic methods developed in Gallardo (2020, CMDA 132:9)

Only restricted case has been developed yet.
Only works in linux systems for now.
User must have installed numpy, matplotlib and gfortran compiler as the core code was written in FORTRAN <3 

User must initialize a resonance as follows:

reso1 = semianalyticResonance(star_mass, a_pla, e_pla, pla_mass, k, kp, e, inc, argper, lonNod)

The class semianalyticResonance() currently has six methods
  1) which_resonance() prints the resonance
  2) which_units() prints the units used in the code
  3) width() wich gives stable width
  4) sigmas() which gives equilibrium points
  5) period() which gives libration period for each equilibrium point
  6) hamiltonian(a_width, levels) which plots hamiltonian level curves of the theory

¡Check the example!

Further detailed documentation and examples are in development.
