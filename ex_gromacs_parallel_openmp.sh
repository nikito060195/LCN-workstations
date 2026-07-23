#!/bin/bash
#SBATCH --job-name=paralelo_max
#SBATCH --partition=pesquisa
#SBATCH --nodes=1
#SBATCH --ntasks=2       # 2 processos principais do script
#SBATCH --cpus-per-task=8          # Aloca todas as 16 threads do no para o job
#SBATCH --mem=0           # Bloqueia TODA a RAM para este job. Exclua essa linha para gerenciamento interno de memoria
#SBATCH --time=72:00:00
#SBATCH --output=saida_geral_%j.log

cd "$SLURM_SUBMIT_DIR"

echo "Iniciando calculo em paralelo: 2 sistemas dividindo o no..."

# SISTEMA 1:
# srun: Ponteiro para que o operador gerencie o processo
# --exclusive: Garante que os recursos alocados para este passo especifico do job sejam de uso unico e exclusivo dele
# -N1: Define o numero de nos que este passo vai usar
# -n: Define a quantidade de tarefas ou processos principais que serao disparados (ex.: um unico processo com X threads)
# --cpus-per-task: Determina quantas CPUs (nucleos logicos/threads) serao dedicadas exclusivamente para as tarefas definidas no -n
# Usa 8 threads (-nt 8 - comando exclusivo do Gromacs), redireciona a saida para seu proprio log e vai para o background (&). Embora este comando e o anterior parecam redundantes, nao sao. O --cpus-per-task=8 avisa ao operador quantos threads reservar e o -nt injeta nas configuracoes do software o numero de threads desejado, dentro do que foi reservado para o processo.

srun --exclusive -N1 -n1 --cpus-per-task=8 apptainer exec \
    /home/nome_usuario/meus_ambientes/gromacs_cpu.sif gmx \
    mdrun -v -deffnm producao_pesada_1 -nt 8 > producao_1.log 2>&1 &

# SISTEMA 2:
# Usa os 8 threads restantes (-nt 8), tem seu proprio log e vai para o background (&)

srun --exclusive -N1 -n1 --cpus-per-task=8 apptainer exec \
    /home/nome_usuario/meus_ambientes/gromacs_cpu.sif gmx \
    mdrun -v -deffnm producao_pesada_2 -nt 8 > producao_2.log 2>&1 &

echo "Simulacoes em andamento. O no ficara bloqueado ate a conclusao..."

# O comando magico de sincronizacao:
# Faz o Slurm esperar ate que as tarefas 1 e 2 terminem antes de encerrar o job
wait

echo "Todas as simulacoes foram concluidas com sucesso!" 
