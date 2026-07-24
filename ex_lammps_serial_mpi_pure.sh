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
# O mpirun vai utilizar as 16 vagas do nó inteiro de uma vez.
# Sem o '&' no final, o script aguarda aqui ate a simulação acabar.
echo "Rodando Simulacao A..."
apptainer exec /home/nome_de_usuario/meus_ambientes/lammps_cpu.sif \
mpirun -np $SLURM_NTASKS lmp -in in.sistemaA > log_simulacaoA.txt 2>&1

# --- SIMULACAO B ---
# A Simulação B assume controle total da máquina assim que a A terminar.
echo "Rodando Simulacao B..."
apptainer exec /home/nome_de_usuario/meus_ambientes/lammps_cpu.sif \
mpirun -np $SLURM_NTASKS lmp -in in.sistemaB > log_simulacaoB.txt 2>&1

echo "Todas as simulacoes foram concluidas com sucesso!"
