#!/bin/bash
#SBATCH --job-name=lammps_omp_puro
#SBATCH --partition=pesquisa
#SBATCH --nodes=1
#SBATCH --ntasks=2                  # 2 tarefas no total (1 para Sim A, 1 para Sim B)
#SBATCH --cpus-per-task=8           # 8 threads OpenMP por tarefa
#SBATCH --time=30:00:00
#SBATCH --output=lammps_%j.log

cd "$SLURM_SUBMIT_DIR"
echo "Iniciando simulacoes paralelas de LAMMPS (Apenas OpenMP)..."

# Garante que o ambiente exporte o limite correto de threads
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# --- SIMULACAO A (1 processo principal x 8 threads OpenMP = 8 núcleos) ---
apptainer exec /home/lcn02/meus_ambientes/lammps_cpu.sif \
lmp -sf omp -pk omp $OMP_NUM_THREADS -in in.sistemaA > log_simulacaoA.txt 2>&1 &

# --- SIMULACAO B (1 processo principal x 8 threads OpenMP = 8 núcleos) ---
apptainer exec /home/lcn02/meus_ambientes/lammps_cpu.sif \
lmp -sf omp -pk omp $OMP_NUM_THREADS -in in.sistemaB > log_simulacaoB.txt 2>&1 &

# Impede que o script feche antes das simulacoes terminarem
wait

echo "Simulacoes do LAMMPS concluidas com sucesso!"
