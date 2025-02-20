#!/usr/bin/env bash
#SBATCH --job-name=variable_sn
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=00:10:00
#SBATCH --output=%x_%j.out

module load gcc
make -B pth_hello

module load pylauncher
python3 variable_sn.py
