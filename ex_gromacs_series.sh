#!/bin/bash
#SBATCH --job-name=gmx_serial
#SBATCH --partition=pesquisa
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16          # Aloca todas as 16 threads logicas
#SBATCH --time=30:00:00
#SBATCH --output=serial_%j.log

cd "$SLURM_SUBMIT_DIR"
echo "Iniciando simulacoes sequenciais em capacidade maxima..."

# Simulacao 1 usa todas as 16 threads do no
echo "Rodando simulacao 1..."
apptainer exec /home/nome_usuario/meus_ambientes/gromacs_cpu.sif \
gmx mdrun -v -deffnm producao_pesada_1 -nt 16 > producao_1.log 2>&1

# Simulacao 2 assume o no inteiro logo em seguida
echo "Rodando simulacao 2..."
apptainer exec /home/nome_usuario/meus_ambientes/gromacs_cpu.sif \
gmx mdrun -v -deffnm producao_pesada_2 -nt 16 > producao_2.log 2>&1

echo "Simulacoes concluidas."
