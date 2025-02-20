#!/usr/bin/env bash
#SBATCH --job-name=mpi_job
#SBATCH --account=YOUR_ACCOUNT
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=00:10:00
#SBATCH --output=%x-%j.out
#SBATCH --mem-per-cpu=200M

module load pylauncher
module load gcc mvapich2

make -B mpi_hello

python3 mpi_launcher.py
