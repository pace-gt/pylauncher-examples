#!/usr/bin/env bash
#SBATCH --job-name=constant_decomp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=00:10:00
#SBATCH --output=%x_%j.out

module load gcc
make -B multi_thread

module load pylauncher
python3 constant_decomp.py
