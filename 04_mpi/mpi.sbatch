#!/usr/bin/env bash
#SBATCH --job-name=mpi
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=00:10:00
#SBATCH --output=%x_%j.out
#SBATCH --mem-per-cpu=200M

module load gcc mvapich2
make -B mpi_hello

module load pylauncher
python3 mpi.py
