#!/usr/bin/env bash
#SBATCH --job-name=multi_process
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=00:10:00
#SBATCH --output=%x_%j.out
#SBATCH --mem-per-cpu=200M

module load gcc mvapich2
make -B multi_process

module load pylauncher
python3 multi_process.py
