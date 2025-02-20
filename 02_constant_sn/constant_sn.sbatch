#!/usr/bin/env bash
#SBATCH --job-name=constant_sn
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=00:10:00
#SBATCH --output=%x_%j.out

make -B pth_hello

module load pylauncher
python3 constant_sn.py
