#!/bin/bash
#SBATCH --job-name=lammps_mpi_serial
#SBATCH --partition=pesquisa
#SBATCH --nodes=1
#SBATCH --ntasks=16                 # Aloca todas as 16 vagas MPI da máquina
#SBATCH --cpus-per-task=1           # 1 thread isolada para cada processo MPI
#SBATCH --time=30:00:00
#SBATCH --output=lammps_%j.log

cd "$SLURM_SUBMIT_DIR"
echo "Iniciando simulacoes em serie (Puro MPI: 16 processos usando todo o no)..."

# --- SIMULACAO A ---
# O srun vai engolir as 16 vagas do nó inteiro de uma vez (-n16).
# Sem o '&' no final, o script congela aqui ate a simulação acabar.
echo "Rodando Simulacao A..."
srun --exclusive -N1 -n16 --cpus-per-task=1 \
apptainer exec /home/nome_usuario/meus_ambientes/lammps_cpu.sif \
lmp -in in.sistemaA > log_simulacaoA.txt 2>&1

# --- SIMULACAO B ---
# O Processo B assume controle total da máquina assim que a A terminar.
echo "Rodando Simulacao B..."
srun --exclusive -N1 -n16 --cpus-per-task=1 \
apptainer exec /home/nome_usuario/meus_ambientes/lammps_cpu.sif \
lmp -in in.sistemaB > log_simulacaoB.txt 2>&1

echo "Todas as simulacoes foram concluidas."
