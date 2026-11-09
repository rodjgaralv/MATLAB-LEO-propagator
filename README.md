# MATLAB-LEO-propagator
MATLAB LEO propagator for the implementation and study of the Exponential Atmospheric, the NRLMSISE-00 and HWM14 models. 
Additionally, the J2 perturbation is implemented.
Made as a complement to my Bachelor's Thesis: Influence of the Exponential and NRLMSISE-00 density models and the HWM14 wind model on the orbital propagation of space debris in low earth orbit.


---- USE INSTRUCTIONS: ORBITAL PROPAGATOR ----

+ The starting function of the code is main.m
	- It will be asked to the user the different options and configurations available: atmos. model, velocity, sim. runtime, the initial position (TLE/COE) and whether it's wanted to save the end efemeris as a .txt.

+ The code uses ode45 to propagate although it works quicker using ode113. Validation results are of similar order but I decided to keep the code as it is because it's the one presented in my thesis.
  
+ Customized COE will be introduced in the simData.m function

+ If using a TLE, it will be needed that a .tle archive is introduced in the TLEFolder using the following format:

		1 27371U 02004B   26147.49252629  .00040681  00000-0  54531-3 0  9995
		2 27371  38.0154 293.8144 0004984 100.5584 259.5756 15.57033590338339

	- If needed, one is attached.

+ If selected the option to save the results, they will be in the OUTPUT folder.
	- Save format will be the following (for each colum):
		[T(s), X(km), Y(km), Z(km), VX(km/s), VY(km/s), VZ(km/s), DENSITY(kg/m^3)]
	- T(s) is the runtime

+ Constants used: WGS84 & EGM2008 as recomended by the National Geospatial-Intelligence Agency (NGA)


---- VALIDATION ----

This propagator was validated against GMAT simulations after 24 hours. The same initial conditions were introduced. For reference, the own GMAT validation against STK was used as to compare whether the differences were in order or not, they were.
Next, I will add the different graphics obtained from the validation process.

- Keplerian Propagation (No perturbations included):
<img width="995" height="566" alt="image" src="https://github.com/user-attachments/assets/7c5e9872-fed0-4864-b466-99eaec433ee5" />


- Perturbated Propagation (J2 included):
<img width="858" height="541" alt="image" src="https://github.com/user-attachments/assets/809ef3c7-fafb-4b3b-8e8a-f00f282dbfbc" />

 
- Perturbated Propagation (Exponential Model included):
<img width="942" height="563" alt="image" src="https://github.com/user-attachments/assets/f761d90d-8e36-4e42-a29c-5dc6218eff38" />


- Exponential Model. Density Relative Differences:
<img width="852" height="566" alt="image" src="https://github.com/user-attachments/assets/49ba7e38-539d-4a24-80f0-dbe77f0bd364" />


- Perturbated Propagation (NRLMSISE-00 Model included):
<img width="917" height="566" alt="image" src="https://github.com/user-attachments/assets/070e341e-fa75-4a6c-b03d-2ee5a3cf4ec3" />


- NRLMSISE-00 Model. Density Relative Differences:
<img width="726" height="483" alt="image" src="https://github.com/user-attachments/assets/758e28aa-9d9d-416e-92a3-bcaf35ce0ab2" />

