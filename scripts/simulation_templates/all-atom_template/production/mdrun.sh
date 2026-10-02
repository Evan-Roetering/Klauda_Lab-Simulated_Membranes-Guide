#!/bin/bash
# import slurm control variables
cores=$(<./stored_parameters/cores.txt)
nodes=$(( (cores + 127) / 128 ))
partition=$(<./stored_parameters/partition.txt)
account=$(<./stored_parameters/account.txt)
email_address=$(<./stored_parameters/email_address.txt)
email_info=$(<./stored_parameters/email_info.txt)
system_name=$(<./stored_parameters/system_name.txt)

# import simulation control variables
sim_steps=$(<./stored_parameters/sim_steps.txt)
chunk_steps=$(<./stored_parameters/chunk_steps.txt)
remainder_steps=$(<./stored_parameters/remainder_steps.txt)
completed_steps=$(<./stored_parameters/completed_steps.txt)
dt=$(<./stored_parameters/step_size.txt)
inc_steps=$(<./stored_parameters/chunk_steps.txt)
write_freq=$(<./stored_parameters/write_freq.txt)

# import chain iteration information
this_chunk=$(<./stored_parameters/next_chunk.txt)
last_chunk=$(<./stored_parameters/last_chunk.txt)
prev_chunk=$(( this_chunk - 1 ))
next_chunk=$(( this_chunk + 1 ))
if (( this_chunk == last_chunk )); then
		steps_when_finished=$(( completed_steps + remainder_steps ))
else
		steps_when_finished=$(( completed_steps + chunk_steps ))
fi

if (( this_chunk != last_chunk )); then
		add_ps=$(echo "$chunk_steps * $dt" | bc -l)
else
		add_ps=$(echo "$remainder_steps * $dt" | bc -l)
fi

sbatch << MDRUN
#!/bin/bash
#SBATCH --job-name=${system_name}_7.${this_chunk}
#SBATCH --open-mode=append
#SBATCH -o ./slurmlogs/7.${this_chunk}_production.out
#SBATCH -e ./slurmlogs/7.${this_chunk}_production.err
#SBATCH -A ${account}
#SBATCH -t 5-00:00:00
#SBATCH -n ${cores}
#SBATCH -N ${nodes}
#SBATCH -p ${partition}
#SBATCH --mail-user=${email_address}
#SBATCH --mail-type=${email_info}

module load gromacs
echo "Running simulation for step ${this_chunk} of ${last_chunk} in the production run"
if [[ "${this_chunk}" == 0 ]]; then
		if [[ ! -f step7.0_production.tpr ]]; then
				echo "Generating .tpr file for step7.0_production"
				gmx_mpi grompp -f step7.0_production.mdp -o step7.0_production.tpr -c step6.6_equilibration.gro -r step5_input.pdb -p topol.top -n index.ndx -maxwarn 1
		fi
		if [[ -f step7.0_production.cpt ]]; then
				echo "Restarting simulation for step7.0_production"
				mpirun -np ${cores} gmx_mpi mdrun -deffnm step7.0_production -s step7.0_production.tpr -cpi step7.0_production.cpt -noappend
		else
				echo "Starting simulation for step7.0_production"
				mpirun -np ${cores} gmx_mpi mdrun -deffnm step7.0_production -noappend
		fi
else
		if [[ ! -f "step7.${prev_chunk}_production.gro" ]]; then
				echo "ERROR: Previous chunk step7.${prev_chunk}_production.gro not found"
				exit 1
		fi
		if [[ ! -f "step7.${this_chunk}_production.tpr" ]]; then
				echo "Extending .tpr file from step7.${prev_chunk}_production to step7.${this_chunk}_production"
				gmx_mpi convert-tpr -s step7.${prev_chunk}_production.tpr -o step7.${this_chunk}_production.tpr -extend ${add_ps}
		fi
		if [[ -f "step7.${this_chunk}_production.cpt" ]]; then
				echo "Restarting simulation for step7.${this_chunk}_production"
				mpirun -np ${cores} gmx_mpi mdrun -deffnm step7.${this_chunk}_production -s step7.${this_chunk}_production.tpr -cpi step7.${this_chunk}_production.cpt -noappend
		else
				echo "Starting simulation for step7.${this_chunk}_production"
				mpirun -np ${cores} gmx_mpi mdrun -deffnm step7.${this_chunk}_production -s step7.${this_chunk}_production.tpr -cpi step7.${prev_chunk}_production.cpt -noappend
		fi
fi

if [[ "${this_chunk}" == "${last_chunk}" ]]; then
		if [[ -f "step7.${this_chunk}_production.gro" ]]; then
				echo "Final chunk step7.${this_chunk}_production completed successfully"
				echo "Moving to cleanup.sh for final cleanup"
				echo "$steps_when_finished" > ./stored_parameters/completed_steps.txt
				./cleanup.sh
		else
				echo "ERROR: Final chunk step7.${this_chunk}_production failed" >&2
		fi
else
		if [[ -f "step7.${this_chunk}_production.gro" ]]; then
				echo "Chunk step7.${this_chunk}_production completed successfully"
				echo "${next_chunk}" > ./stored_parameters/next_chunk.txt
				echo "$steps_when_finished" > ./stored_parameters/completed_steps.txt
				./mdrun.sh
		else
				echo "ERROR: Chunk step7.${this_chunk}_production failed" >&2
		fi
fi
