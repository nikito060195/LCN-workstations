#!/bin/bash
#SBATCH --job-name=lammps_hibrido
#SBATCH --partition=pesquisa
#SBATCH --nodes=1
#SBATCH --ntasks=4                  # 4 processos MPI totais (2 para Sim A + 2 para Sim B)
#SBATCH --cpus-per-task=4           # 4 threads OpenMP por processo MPI
#SBATCH --time=30:00:00
#SBATCH --output=lammps_%j.log

cd "$SLURM_SUBMIT_DIR"
echo "Iniciando simulacoes paralelas de LAMMPS (MPI + OpenMP)..."

# Repassa as variaveis alocadas pelo Slurm para o ambiente
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# --- SIMULACAO A (2 tarefas MPI x 4 threads OpenMP = 8 núcleos isolados) ---
apptainer exec /home/nome_de_usuario/meus_ambientes/lammps_cpu.sif \
mpirun --bind-to none -np 2 lmp -sf omp -pk omp $OMP_NUM_THREADS -in in.sistemaA > log_simulacaoA.txt 2>&1 &

# --- SIMULACAO B (2 tarefas MPI x 4 threads OpenMP = 8 núcleos isolados) ---
apptainer exec /home/nome_de_usuario/meus_ambientes/lammps_cpu.sif \
mpirun --bind-to none -np 2 lmp -sf omp -pk omp $OMP_NUM_THREADS -in in.sistemaB > log_simulacaoB.txt 2>&1 &

# Impede que o script feche antes das simulacoes terminarem
wait

echo "Simulacoes do LAMMPS concluidas com sucesso!"
