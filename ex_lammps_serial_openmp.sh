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

# Exporta a variavel de ambiente para o limite correto de threads
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# --- SIMULACAO A ---
echo "Rodando simulacao A..."
apptainer exec /home/nome_de_usuario/meus_ambientes/lammps_cpu.sif \
lmp -sf omp -pk omp $OMP_NUM_THREADS -in in.sistemaA > log_simulacaoA.txt 2>&1

# Opcional, mas altamente recomendado
echo "Pausa para resfriamento do SSD..."
sleep 120

# --- SIMULACAO B ---
echo "Rodando simulacao B..."
apptainer exec /home/nome_de_usuario/meus_ambientes/lammps_cpu.sif \
lmp -sf omp -pk omp $OMP_NUM_THREADS -in in.sistemaB > log_simulacaoB.txt 2>&1

echo "Todas as simulacoes do LAMMPS foram concluidas com sucesso!"
