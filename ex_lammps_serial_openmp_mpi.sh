#!/bin/bash
#SBATCH --job-name=lammps_serial_hibrido
#SBATCH --partition=pesquisa
#SBATCH --nodes=1
#SBATCH --ntasks=4                  # 4 processos MPI autorizados
#SBATCH --cpus-per-task=4           # 4 threads OpenMP por processo MPI
#SBATCH --time=30:00:00
#SBATCH --output=lammps_%j.log

cd "$SLURM_SUBMIT_DIR"
echo "Iniciando simulacoes sequenciais de LAMMPS (Hibrido: 4 MPI x 4 OMP = 16 Threads)..."

# Exporta a variavel de ambiente para o limite correto de threads OpenMP
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# --- SIMULACAO A ---
# O mpirun assume os 4 processos e passa 4 threads para cada um (16 cpus)
echo "Rodando simulacao A..."
apptainer exec /home/nome_de_usuario/meus_ambientes/lammps_cpu.sif \
mpirun -np $SLURM_NTASKS lmp -sf omp -pk omp $OMP_NUM_THREADS -in in.sistemaA > log_simulacaoA.txt 2>&1

# Opcional, mas altamente recomendado devido ao historico do seu NVMe
echo "Pausa para resfriamento do SSD..."
sleep 120

# --- SIMULACAO B ---
# A Simulação B assume as mesmas 16 cpus apenas quando a A terminar
echo "Rodando simulacao B..."
apptainer exec /home/nome_de_usuario/meus_ambientes/lammps_cpu.sif \
mpirun -np $SLURM_NTASKS lmp -sf omp -pk omp $OMP_NUM_THREADS -in in.sistemaB > log_simulacaoB.txt 2>&1

echo "Todas as simulacoes do LAMMPS foram concluidas com sucesso!"
