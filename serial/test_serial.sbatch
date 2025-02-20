#!/usr/bin/env bash
#SBATCH --job-name=test_serial
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --time=00:05:00
#SBATCH --output=%x-%j.out

module load pylauncher
python3 test_serial.py
