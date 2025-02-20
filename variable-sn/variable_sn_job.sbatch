#!/usr/bin/env bash
#SBATCH --job-name=variable_sn_job
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --time=00:10:00
#SBATCH --output=%x-%j.out

module load pylauncher
python3 variable_sn_launcher.py
