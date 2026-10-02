#!/bin/bash

# ============================ Cleanup After Completing Simulation ============================
# import variables
cores=$(<./stored_parameters/cores.txt)
nodes=$(( (cores + 127) / 128 ))
partition=$(<./stored_parameters/partition.txt)
account=$(<./stored_parameters/account.txt)
email_address=$(<./stored_parameters/email_address.txt)
email_info=$(<./stored_parameters/email_info.txt)
last_chunk=$(<./stored_parameters/last_chunk.txt)
system_name=$(<./stored_parameters/system_name.txt)
charmm_gui_dir=$(<./stored_parameters/charmm_gui_dir.txt)

sbatch << CLEANUP
#!/bin/bash
#SBATCH --job-name=${system_name}_cleanup
#SBATCH --open-mode=append
#SBATCH -o ./slurmlogs/cleanup.out
#SBATCH -e ./slurmlogs/cleanup.err
#SBATCH -A ${account}
#SBATCH -p ${partition}
#SBATCH -t 2-00:00:00
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mail-user=${email_address}
#SBATCH --mail-type=${email_info}

module load gromacs

# ================================== Combine .xtc Files =======================================
echo "Concatenating trajectories in the following order:"
ls step7*production.*xtc | sort -V
gmx_mpi trjcat -f \$(ls step7*production.*xtc | sort -V) -o step7_production.xtc

# ======================== Make and Populate Visualization Directory ==========================
mkdir -p ../visualization
cp -r toppar ../visualization/
cp topol.top ../visualization/system.top
cp step7_production.xtc ../visualization/trajectory.xtc
cp step6.6_equilibration.gro ../visualization/topology.gro
cp step7.${last_chunk}_production.tpr ../visualization/input.tpr
cp "$charmm_gui_dir/step5_input.psf" ../visualization/bonds.psf

cd ../visualization
# ================ Remove Periodic Boundary Conditions for Visualization ======================
gmx_mpi trjconv -s input.tpr -f trajectory.xtc -o trajectory.xtc -pbc whole <<< "0"
gmx_mpi trjconv -s input.tpr -f trajectory.xtc -o trajectory.xtc -pbc mol -ur compact << "MOL"
0
MOL

CLEANUP