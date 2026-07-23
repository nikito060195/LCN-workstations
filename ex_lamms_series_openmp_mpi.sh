#!/bin/bash
#SBATCH --job-name=lammps_serial_hibrido
#SBATCH --partition=pesquisa
#SBATCH --nodes=1
#SBATCH --ntasks=4                  # 4 processos MPI autorizados
#SBATCH --cpus-per-task=4           # 4 threads OpenMP por processo
#SBATCH --time=30:00:00
#SBATCH --output=lammps_%j.log

cd "$SLURM_SUBMIT_DIR"
echo "Iniciando simulacoes sequenciais de LAMMPS (Hibrido: 4 MPI x 4 OMP = 16 Threads)..."

# --- SIMULACAO A ---
echo "Rodando simulacao A..."
srun -n4 --cpus-per-task=4 \
apptainer exec /home/nome_usuario/meus_ambientes/lammps_cpu.sif \
lmp -sf omp -pk omp 4 -in in.sistemaA > log_simulacaoA.txt 2>&1

# Opcional, mas altamente recomendado devido ao historico do seu NVMe
echo "Pausa para resfriamento do SSD..."
sleep 120

# --- SIMULACAO B ---
echo "Rodando simulacao B..."
srun -n4 --cpus-per-task=4 \
apptainer exec /home/nome_usuario/meus_ambientes/lammps_cpu.sif \
lmp -sf omp -pk omp 4 -in in.sistemaB > log_simulacaoB.txt 2>&1

echo "Todas as simulacoes do LAMMPS foram concluidas." 
