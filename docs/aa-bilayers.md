# All-Atom Bilayer Simulations
  
## CHARMM-GUI
CHARMM-GUI (GUI is pronounced as "gooey" not "gee-you-eye") is the primary tool that we use for generating inputs for all atom molecular simulations. It provides a wide range of tools for building model systems including tools for viewing .pdb files, ways to customize individual molecules, and builders for membrane and non-membrane systems. We will be using their Membrane Builder tool, so having an account will be necessary. One can be made for free by visiting [the CHARMM-GUI website](https://www.charmm-gui.org/), selecting login, then selecting register and registering with your @umd.edu email.

## All-Atom Simulation Template for Zaratan
1. Download the [new_simulation.all_atom](/scripts/zt-bin/new_simulation.all_atom) script for this repository, transfer it to zaratan and place it in your `~/scratch.energybio/bin` directory.
2. If you do not already have a `~/scratch.energybio/simulation_templates` directory, create one.
3. Download the [new_simulation.all_atom](/scripts/simulation_templates/all-atom_template) directory from this repository
4. Transfer it to zaratan and place it in your `~/scratch.energybio/simulation_templates` directory
5. Edit `~/scratch.energybio/simulation_templates/all-atom_template/production.start` and `~/scratch.energybio/simulation_templates/all-atom_template/min_eq.start` with your email address
6. Make sure that `~/scratch.energybio/bin/new_simulation.all_atom` is executable with `chmod +x ~/scratch.energybio/bin/new_simulation.all_atom`
7. Make sure that the template scripts are executable with:
```
chmod +x ~/scratch.energybio/simulation_templates/all-atom_template/*
chmod +x ~/scratch.energybio/simulation_templates/all-atom_template/min_eq/*
chmod +x ~/scratch.energybio/simulation_templates/all-atom_template/production/*
```
8. You can now set up a ready to use template system by running `new_simulation.all_atom <system_name>`

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
1. On Zaratan and in `~/scratch.energybio` make a new simulation template for your system with `new_simulation.all_atom <system_name>`
2. Move the .tgz file from charmm-gui onto the cluster and into your `~/scratch.energybio/<system_name>` directory with either WinSCP or with the `to-zt` command from [WSL and SSH setup](/docs/zaratan-setup.md)
3. Navigate to `~/scratch.energybio/<system_name>` and extract the contents with `tar -xzvf charmm-gui.tgz`, it will extract the contents into `./charmm-gui-<job number>`
4. Choose a system name and edit any relevant input variables in min_eq.start
5. execute min_eq.start to proceed through the minimization and equilibration chain automatically

#### Simulation
1. Once your minimization and equilibration steps are complete you will be ready to conduct a production run.
2. Configure your system including the system name, number of time steps, and number of steps for each simulation iteration by editing production.start
3. Begin the simulation chain by executing production.start
4. Once it has completed, there will be a copy of the finished trajectory and other files necessary for visualization in `~/scratch.energybio/<system_name>/visualization`

#### Visualization
To visualize, download the files written to the visualization directory at the end of the production simulation. Then open the .gro file in VMD as a new molecule. Then just read the simulation trajectory by loading the .xtc file into the same molecule.  
You can download and install VMD [here](https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD). Make sure to use version 1.9.4

#### Analysis
See [Dr. Klauda's Wiki](https://user.eng.umd.edu/~jbklauda/wiki/doku.php?id=surface_area_of_lipid)

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

# [Click Here to Go Back to Overview](/README.md)