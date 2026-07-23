#!/bin/bash
#SBATCH --job-name=lammps_omp_puro
#SBATCH --partition=pesquisa
#SBATCH --nodes=1
#SBATCH --ntasks=2                  # 2 processos principais (1 para Sim A, 1 para Sim B)
#SBATCH --cpus-per-task=8           # 8 threads OpenMP por processo
#SBATCH --time=30:00:00
#SBATCH --output=lammps_%j.log

cd "$SLURM_SUBMIT_DIR"
echo "Iniciando simulacoes paralelas de LAMMPS (Apenas OpenMP)..."

# --- SIMULACAO A (1 tarefa x 8 threads) ---
srun --exclusive -N1 -n1 --cpus-per-task=8 \
apptainer exec /home/nome_usuario/meus_ambientes/lammps_cpu.sif \
lmp -sf omp -pk omp 8 -in in.sistemaA > log_simulacaoA.txt 2>&1 &

# --- SIMULACAO B (1 tarefa x 8 threads) ---
srun --exclusive -N1 -n1 --cpus-per-task=8 \
apptainer exec /home/nome_usuario/meus_ambientes/lammps_cpu.sif \
lmp -sf omp -pk omp 8 -in in.sistemaB > log_simulacaoB.txt 2>&1 &

# Impede que o script feche antes das simulacoes terminarem
wait

echo "Simulacoes do LAMMPS concluidas."
