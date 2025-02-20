#!/usr/bin/env bash
#SBATCH --job-name=test_serial
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --time=00:05:00
#SBATCH --output=%x_%j.out

module load pylauncher
python3 test_serial.py
