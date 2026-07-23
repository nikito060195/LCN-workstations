#!/bin/bash
#SBATCH --job-name=lammps_serial_omp
#SBATCH --partition=pesquisa
#SBATCH --nodes=1
#SBATCH --ntasks=1                  # 1 unico processo principal
#SBATCH --cpus-per-task=16          # 16 threads alocadas para este processo
#SBATCH --time=30:00:00
#SBATCH --output=lammps_%j.log

cd "$SLURM_SUBMIT_DIR"
echo "Iniciando simulacoes sequenciais de LAMMPS (OpenMP Puro: 16 threads)..."

# --- SIMULACAO A ---
echo "Rodando simulacao A..."
srun -n1 --cpus-per-task=16 \
apptainer exec /home/nome_usuario/meus_ambientes/lammps_cpu.sif \
lmp -sf omp -pk omp 16 -in in.sistemaA > log_simulacaoA.txt 2>&1

# Opcional, mas altamente recomendado
echo "Pausa para resfriamento do SSD..."
sleep 120

# --- SIMULACAO B ---
echo "Rodando simulacao B..."
srun -n1 --cpus-per-task=16 \
apptainer exec /home/nome_usuario/meus_ambientes/lammps_cpu.sif \
lmp -sf omp -pk omp 16 -in in.sistemaB > log_simulacaoB.txt 2>&1

echo "Todas as simulacoes do LAMMPS foram concluidas."
