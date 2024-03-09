#Ahora corremos varios atlas
# variando otro parametro

#Por ejemplo la excentricidad
#Esto reproduce el superatlasv3

from funcion_atlas import patlas

salida = patlas(1.0, 5.2, 0.05, 5e-4, 5, 5, 5, 1.0, 10.0, 0.2, 20, 0.0, 0.0)
a_a = salida[0]
a_d = salida[1]
exc = salida[2]

import matplotlib.pyplot as plt
import numpy as np

rango_e = np.linspace(0,0.99,num=30)
plt.figure(dpi=300)

colos=[]
for j in range(len(a_a)):
        colos.append(np.random.rand(len(a_a),3))

for ee in rango_e:
    print(ee)
    salida = patlas(1.0, 5.2, 0.05, 5e-4, 5, 5, 5, 1.0, 10.0, ee, 20, 0.0, 0.0)
    a_a = salida[0]
    a_d = salida[1]
    exc = salida[2]
    
    for j in range(len(a_a)):
        # col = np.random.rand(len(a_a),3)
        col = colos[j]
        plt.scatter(a_a,exc,c=col,marker='|')
        plt.scatter(a_d,exc,c=col,marker='|')
       
plt.ylim([0.0,1.0])
plt.xlim([1.0,10.0])
plt.xlabel('a [au]')
plt.ylabel('e')
plt.show()
