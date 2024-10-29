#This is a short example showing the methods inside the class

#Import the class
from semianalyticResonance import semianalyticResonance

# Generate a pyton object called reso1
#                    (star_mass, a_pla, e_pla, pla_mass, kp, k, e, inc, argper, lonNod)
reso1 = semianalyticResonance(1.0, 5.0, 0.01, 5e-5, 1, 1, 0.2, 10.0, 0.0, 0.0)

#We can check what resonance are we working with
reso1.which_resonance()

#We can see what units the code uses
reso1.which_units()

#We can calculate stable width
reso1.width()

# We can calculate equilibrium points
reso1.sigmas()

# We can calculate libration period
reso1.period()

# We can plot the hamiltonian in the plane (a,sigma)
a_width = 0.5 #width plot in au
levels = 10 #number of level curves
reso1.hamiltonian(a_width, levels)
