# MATLAB-LEO-propagator
MATLAB LEO propagator for the implementation and study of the Exponential Atmospheric, the NRLMSISE-00 and HWM14 models. 
Additionally, the J2 perturbation is implemented.
Made as my Bachelor's Thesis


---- INSTRUCIONES USO CÓDIGO: PROPAGADOR ORBITAL ----

+ La función principal del código es main.m
	
	- Una vez iniciado el código se pedirá si se quiere o no borrar la consola y el Workspace de MATLAB.
	- A continuación se le pedirá al usuario escoger el modelo atmosférico, de velocidad, la duración de la simulación y si quiere guardar los datos obtenidos en un documento .txt y si 	  quiere realizar una simulación con COE personalizados o si desea usar TLE.
	- Se ha de proceder con precaución al seleccionar el modelo NRLMSISE-00 en conjunto con el HWM14 ya que si los tiempos de simulación son elevados, el tiempo real para MATLAB rondará 	  los 10/20 minutos. (se puede usar, si se desea el ode113 que reduce bastante los tiempos de simulación, aunque estos siguen siendo largos)

+ En el caso de seleccionar una simulación personalizada se han de introducir los datos en la función simData.m

+ En el caso de seleccionar TLE se ha de introducir este en la carpeta correspondiente en un archivo .txt con el siguiente formato:

		1 27371U 02004B   26147.49252629  .00040681  00000-0  54531-3 0  9995
		2 27371  38.0154 293.8144 0004984 100.5584 259.5756 15.57033590338339

Se adjunta TLE para que se pueda comprobar mejor el formato.

+ Si se selecciona que se quieren guardar los datos, estos se guardan en la carpeta OUTPUT, en esta se guardarán los archivos .txt con el nombre Exponential_Run o NRLMSISE-00_Run en función del modelo atmosférico elegido.

	- El formato de guardado de los datos será el siguiente (en columnas):
		[T(s), X(km), Y(km), Z(km), VX(km/s), VY(km/s), VZ(km/s), DENSIDAD(kg/m^3)]

