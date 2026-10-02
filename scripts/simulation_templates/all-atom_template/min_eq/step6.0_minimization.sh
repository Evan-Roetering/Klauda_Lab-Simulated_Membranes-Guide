#!/bin/bash

step_cpus=4
max_cpus=$(<./stored_parameters/max_cpus.txt)
partition=$(<./stored_parameters/partition.txt)
account=$(<./stored_parameters/account.txt)
email_address=$(<./stored_parameters/email_address.txt)
email_info=$(<./stored_parameters/email_info.txt)
system_name=$(<./stored_parameters/system_name.txt)

if (( $max_cpus < $step_cpus )); then
        cpus=$max_cpus
else
        cpus=$step_cpus
fi

nodes=$(( (cpus + 127) / 128 ))

sbatch << MINIMIZATION
#!/bin/bash
#SBATCH --job-name=${system_name}-6.0_min
#SBATCH -o slurmlogs/step6.0_minimization.out
#SBATCH -e slurmlogs/step6.0_minimization.err
#SBATCH -A ${account}
#SBATCH -t 01:00:00
#SBATCH -n ${cpus}
#SBATCH -N ${nodes}
#SBATCH -p ${partition}
#SBATCH --mail-user=${email_address}
#SBATCH --mail-type=${email_info}

if [[ ! -f "step6.0_minimization.mdp" ]]; then
        echo "ERROR: step6.0_minimization.mdp not found" >&2
        echo "Check filenames from charmm-gui files" >&2
        exit 1
fi
if [[ ! -f "step5_input.gro" ]]; then
        echo "ERROR: step5_input.gro not found" >&2
        echo "Check filenames from charmm-gui files" >&2
        exit 1
fi
if [[ ! -f "step5_input.pdb" ]]; then
        echo "ERROR: step5_input.pdb not found" >&2
        echo "Check filenames from charmm-gui files" >&2
        exit 1
fi
if [[ ! -f "topol.top" ]]; then
        echo "ERROR: topol.top not found" >&2
        echo "Check filenames from charmm-gui files" >&2
        exit 1
fi
if [[ ! -f "index.ndx" ]]; then
        echo "ERROR: index.ndx not found" >&2
        echo "Check filenames from charmm-gui files" >&2
        exit 1
fi

module load gromacs

if [[ ! -f "step6.0_minimization.tpr" ]]; then
        gmx_mpi grompp -f step6.0_minimization.mdp -o step6.0_minimization.tpr -c step5_input.gro -r step5_input.pdb -p topol.top -n index.ndx -maxwarn 1
fi

if [[ -f "step6.0_minimization.cpt" ]]; then
        mpirun -np ${cpus} gmx_mpi mdrun -deffnm step6.0_minimization -s step6.0_minimization.tpr -cpi step6.0_minimization.cpt
else
        mpirun -np ${cpus} gmx_mpi mdrun -deffnm step6.0_minimization
fi

if [[ -f step6.0_minimization.gro ]]; then
        ./step6.1_equilibration.sh
else
        echo "ERROR: step6.0_minimization failed, adjust and retry" >&2
fi
MINIMIZATION

