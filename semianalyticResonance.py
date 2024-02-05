# Code developed in 2024 by N. Pan (nicolas.pan@fcien.edu.uy) using
# Fortran codes developed by T. Gallardo (gallardo@fisica.edu.uy).
# References: 

# We define a class that will contain every method that the semianalytic
# model provides such as hamiltonian and resonance width
class semianalyticResonance: #Podriamos hacer dos clases, una para el caso restricto y otra para el problema completo
    
    # First we initialice the object with the 9 variables given
    def __init__(self,star_mass, a_pla, e_pla, pla_mass, k, kp, e, inc, argper, lonNod):
        self.star_mass = star_mass
        self.a_pla = a_pla
        self.e_pla = e_pla
        self.pla_mass = pla_mass
        self.k = k
        self.kp = kp
        self.e = e
        self.inc = inc
        self.argper = argper
        self.lonNod = lonNod

    # This method shows the user what resonance is he working with
    def which_resonance(self):
        print(f"You are working with the resonance {self.k} : {self.kp}")
        
    # This method prints the units used in the code
    def which_units(self):
        print("The code uses the following units:")
        print("star_mass in solar masses")
        print("a_pla in astronomical units")
        print("e_pla is unitless")
        print("pla_mass in solar masses")
        print("k as an integer")
        print("kp as an integer")
        print("e is unitless")
        print("inc in degrees")
        print("argper in degrees")
        print("lonNod in degrees")
        
    # This method calculates and plots Hamiltonian level curves
    def hamiltonian(self, a_width, num_levels):
        print("hamiltonian is a Work in progress")
        
        # First compile the Fortran code
        import subprocess
        source = "Hsigma.f"
        output = "Hamilt.exe"
        subprocess.run(["gfortran", source, "-o", output])
        exe_path = "./" + output
        
        # Then write the initial file
        with open("planet.inp","w") as file:
            lines=["mass of central star in solar masses (do not remove this line)\n",str(self.star_mass)+"\n",
                    "a (au)    e     mass for planet (do not remove this line)\n",
                    str(self.a_pla)+" "+str(self.e_pla)+" "+str(self.pla_mass)]
            file.writelines(lines)
        lonPer = self.lonNod + self.argper
        input_data = str(self.k) +"\n"+ str(self.kp) +"\n"+ str(self.e) +"\n" + str(self.inc) +"\n"+ str(self.lonNod) +"\n"+ str(lonPer) +"\n"+ str(a_width)
        
        # Run the code and save the results
        import os
        file_path = 'hamilto.dat'
        if os.path.exists(file_path):
            os.remove(file_path)
        result = subprocess.run([exe_path], stdout=subprocess.PIPE , text = True, input=input_data)
        
        # Plot
        import matplotlib.pyplot as plt
        import numpy as np
        data = np.loadtxt('hamilto.dat')
        x = data[:, 1]
        y = data[:, 0]
        z = data[:, 2]
        nx = len(np.unique(x))
        ny = len(np.unique(y))
        X = x.reshape((ny, nx))
        Y = y.reshape((ny, nx))
        Z = z.reshape((ny, nx))
        fig, ax = plt.subplots(dpi=300,figsize=(7,5))
        h=ax.contour(X, Y, Z, levels=num_levels, cmap='plasma')
        fmt = '%1.12f'
        # cbar = plt.colorbar(h, format = fmt)
        ax.ticklabel_format(useOffset=False)
        ax.set_xlabel(r'$\sigma [º]$')
        ax.set_ylabel('a [au]')
        ax.set_xticks([0,45,90,135,180,225,270,315,360])
        plt.show()
        
    # This method calculates equilibrium points (sigma)
    def sigmas(self):
        print("sigmas is a Work in progress")
        
        # El primer paso es compilar el fortran desde python
        import subprocess
        source = "ResoGen.f"
        output = "reso.exe"
        subprocess.run(["gfortran", source, "-o", output])
        exe_path = "./" + output
        
        # We write the initial file
        with open("plasys.inp","w") as file:
            lines=["STAR: mass of the star in solar masses\n",str(self.star_mass)+"\n",
                    "PLANETS: a e mass, put one line per planet and a comment line after the last one\n",
                    str(self.a_pla)+" "+str(self.e_pla)+" "+str(self.pla_mass)+"\n","ccccccccccccccccccccccccccccccccc comment line"]
            file.writelines(lines)
        input_data = str(1) +"\n"+ str(self.k) +"\n"+ str(self.kp) +"\n"+ str(self.e) +"\n"+ str(self.inc) +"\n"+ str(self.argper) +"\n"+ str(self.lonNod)
        
        # Run the code
        result = subprocess.run([exe_path], stdout=subprocess.PIPE , text = True, input=input_data)
        
        import numpy as np
        file_path = 'resoGenSalida.sal'
        with open(file_path, 'r') as file:
            sig = np.array([float(line.strip()) for line in file])
        print('Equilibrium points are in sigma = ',sig)
        
        # This method returns the sigma values
        # print(sig)
        return sig 

    # This method gives the width of the resonant configuration
    def width(self):
        print("width is a Work in progress")
        
    # Podemos añadir mas metodos como por ejemplo el año maximo o el 
    # periodo de libracion de cada objeto
    #La idea es poder unir esta clase con REBOUND para poder hacer un git commit
    #Tambien podriamos hacer que se agregue un metodo que usando rebound
    # y el nombre del objeto integrar por cierto tiempo y con cierta
    # cantidad de clones. Ademas podriamos integrar REBOUNDx agregando
    # distintas fuerzas
        
#%%
# As an example we initialize a resonance
reso1 = semianalyticResonance(1.0, 5.0, 0.01, 5e-5, 1, 1, 0.2, 10.0, 0.0, 0.0)

ancho = 0.1
niveles = 10

reso1.sigmas()