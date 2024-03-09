#Creamos la funcion atlas

def patlas(star_mass, a_pla, e_pla, m_pla, max_kp, max_k, max_q, a_min, a_max, e, inc, argper, lonod):
    
    nombre_archivo = 'plasys.inp'
    with open(nombre_archivo, 'w') as archivo_txt:
        archivo_txt.write('STAR: mass of the star in solar masses\n')
        archivo_txt.write(str(star_mass)+'\n')
        archivo_txt.write('PLANETS: a e mass, put one line per planet and a comment line after the last one\n')
        archivo_txt.write(str(a_pla)+'\t'+str(e_pla)+'\t'+str(m_pla)+'\n')
        archivo_txt.write('cccccccccccccccccccccccccccccccccccccccccccccc comment line\n')

    import os
    file_path = "superatlasv2.out"
    if os.path.exists(file_path):
        os.remove(file_path)

    #Ahora corremos el programa
    import subprocess
    output = "Superatlasv2.exe"
    exe_path = "./" + output
    input_data = str(max_kp) +"\n"+ str(max_k) +"\n"+ str(max_q) +"\n"+ str(a_min) +"\n"+ str(a_max) +"\n"+ str(1) +"\n"+ str(1)+"\n"+ str(e)+"\n"+ str(inc)+"\n"+ str(argper)+"\n"+ str(lonod)
    result = subprocess.run([exe_path], stdout=subprocess.PIPE , text = True, input=input_data)
    
    import numpy as np
    data = np.loadtxt('superatlasv2.out',skiprows=3)
    a = data[:,3]
    ancho = data[:,10]
    a_a = a - (ancho/2)
    a_d = a + (ancho/2)
    exc = np.ones(len(a_a))*e
    
    return [a_a,a_d,exc]

#%%

# salida = patlas(1.0, 5.2, 0.05, 5e-4, 5, 5, 5, 0, 10, 0.1, 20, 0.0, 0.0)
# a_a = salida[0]
# a_d = salida[1]
# exc = salida[2]

# #%%
# import matplotlib.pyplot as plt
# import numpy as np

# plt.figure(dpi=300)
# for j in range(len(a_a)):
#     col = np.random.rand(len(a_a),3)
#     plt.scatter(a_a,exc,c=col)
#     plt.scatter(a_d,exc,c=col)
# plt.xlabel('a [au]')
# plt.ylabel('e')
# plt.show()