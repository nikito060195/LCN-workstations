#!/bin/bash
#SBATCH --job-name=lammps_mpi_puro
#SBATCH --partition=pesquisa
#SBATCH --nodes=1
#SBATCH --ntasks=16                 # 16 processos MPI totais (8 para Sim A + 8 para Sim B)
#SBATCH --cpus-per-task=1           # Exatamente 1 thread alocada para cada processo MPI
#SBATCH --time=30:00:00
#SBATCH --output=lammps_%j.log

cd "$SLURM_SUBMIT_DIR"
echo "Iniciando simulacoes paralelas (Puro MPI: 8 processos por sistema)..."

# --- SIMULACAO A (8 tarefas MPI x 1 thread = 8 núcleos isolados) ---
srun --exclusive -N1 -n8 --cpus-per-task=1 \
apptainer exec /home/nome_usuario/meus_ambientes/lammps_cpu.sif \
lmp -in in.sistemaA > log_simulacaoA.txt 2>&1 &

# --- SIMULACAO B (8 tarefas MPI x 1 thread = 8 núcleos isolados) ---
srun --exclusive -N1 -n8 --cpus-per-task=1 \
apptainer exec /home/nome_usuario/meus_ambientes/lammps_cpu.sif \
lmp -in in.sistemaB > log_simulacaoB.txt 2>&1 &

wait
