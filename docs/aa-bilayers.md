# All-Atom Bilayer Simulations
  
## CHARMM-GUI
CHARMM-GUI (with GUI pronounced as "gooey") is the primary tool that we use for generating inputs for all atom molecular simulations. It provides a wide range of tools for building model systems including tools for viewing .pdb files, ways to customize individual molecules, and builders for membrane and non-membrane systems. We will be using their Membrane Builder tool, so having an account will be necessary. One can be made for free by visiting [the CHARMM-GUI website](https://www.charmm-gui.org/), selecting login, then selecting register and registering with your @umd.edu email.

## Symmetrical Lipid-Only Bilayers
#### Build the System
Navigate to [CHARMM-GUI's membrane builder](https://charmm-gui.org/?doc=input/membrane.bilayer) and follow the steps to build your system
1. Select "Membrane Only System" and click "Next Step"
2. You can usually leave box type and length of z as the default, but Length of XY should be changed to Numbers of lipid components
3. From the drop down lipid menu, find the lipids you plan to add and include your desired numbers of each. Make sure an equal number of each is added to the upper and lower leaflet
4. Click the "Show the system info" button, then if CHARMM-GUI doesn't give you a warning and the number of lipids is correct click the "next step" button
5. Leave the default system building options
6. Use KCl with the concentration set to 0 and neutralizing selected, then click "Next Step"
7. Once the membrane lipids have been generated, click "Next Step"
8. Once the water box has been generated, click "Next Step"
9. Select the CHARMM36m force field
10. Under "Input Generation Options", select "More CHARMM minimization during input generation", "NAMD", and "GROMACS". We will not be using GROMACS for simulating the system, but NAMD is used commonly, so having both can be helpful.
11. Leave the default equilibration options except for temperature, which should be physiological temperature for the organism being studied (310 K for humans). Then click "Next Steps"
12. Download the .tgz file

#### Minimization and Equilibration
Coming Soon

#### Simulation
Coming Soon

#### Visualization
Coming Soon

#### Analysis
Coming Soon

## Asymmetrical Lipid-Only Bilayers
#### Get Area Per Lipid from Symmetric System
Coming Soon

#### Build the System
Coming Soon

#### Minimization and Equilibration
Coming Soon

#### Simulation
Coming Soon

#### Visualization
Coming Soon

#### Analysis
Coming Soon