#!/bin/bash

step_cpus=128
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

sbatch << EQUILIBRATION
#!/bin/bash
#SBATCH --job-name=${system_name}-6.6_eq
#SBATCH -o slurmlogs/step6.6_equilibration.out
#SBATCH -e slurmlogs/step6.6_equilibration.err
#SBATCH -A ${account}
#SBATCH -t 01:00:00
#SBATCH -n ${cpus}
#SBATCH -N ${nodes}
#SBATCH -p ${partition}
#SBATCH --mail-user=${email_address}
#SBATCH --mail-type=${email_info}

if [[ ! -f "step6.6_equilibration.mdp" ]]; then
        echo "ERROR: step6.6_equilibration.mdp not found" >&2
        echo "Check filenames from charmm-gui files" >&2
        exit 1
fi
if [[ ! -f "step6.5_equilibration.gro" ]]; then
        echo "ERROR: step6.5_equilibration.gro not found" >&2
        echo "Check output from step6.5_equilibration" >&2
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

if [[ ! -f "step6.6_equilibration.tpr" ]]; then
        gmx_mpi grompp -f step6.6_equilibration.mdp -o step6.6_equilibration.tpr -c step6.5_equilibration.gro -r step5_input.pdb -p topol.top -n index.ndx -maxwarn 1
fi

if [[ -f "step6.6_equilibration.cpt" ]]; then
        mpirun -np ${cpus} gmx_mpi mdrun -deffnm step6.6_equilibration -s step6.6_equilibration.tpr -cpi step6.6_equilibration.cpt
else
        mpirun -np ${cpus} gmx_mpi mdrun -deffnm step6.6_equilibration
fi

if [[ -f step6.6_equilibration.gro ]]; then
        echo "step6.6_equilibration completed successfully, ready for production run"
else
        echo "ERROR: step6.6_equilibration failed, adjust and retry" >&2
fi
EQUILIBRATION
