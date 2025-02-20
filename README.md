## Motivation

[PyLauncher](https://github.com/TACC/pylauncher) is a Python library that allows
you to flexibly schedule parallel tasks on an HPC cluster.  It has similar use
cases to [GNU parallel](https://www.gnu.org/software/parallel/) and [Slurm job
arrays](https://slurm.schedmd.com/job_array.html).  In general, we encourage
users to consider Slurm job arrays, but PyLauncher can be a better fit for
some use cases.

PyLauncher is developed at the 
[Texas Advanced Supercomputing Center](https://tacc.utexas.edu/) 
and is available on [TACC's GitHub organization](https://github.com/TACC/pylauncher).  
A helpful tutorial is available in the 
[TACC docs](https://docs.tacc.utexas.edu/software/pylauncher/).

Support for `srun` was added by PACE and is available in PACE's [fork of
PyLauncher](https://github.com/pace-gt/pylauncher).  This document presents
examples with sbatch scripts that will work at PACE.  The examples can be found
in [this GitHub repo](https://github.com/pace-gt/pylauncher-examples).  

## Cloning the examples repo

The example repo is publicly available can be cloned with:

    git clone https://github.com/pace-gt/pylauncher-examples.git

## Example 1: Running multi-threaded programs with constant decomposition

Suppose you want to run hundreds or even thousands of instances of a
multi-threaded program in a single Slurm job.  You could attempt to reserve
enough CPUs to run all tasks simultaneously, but this could spend a long time on
the job queue.  In many cases, a better alternative is to request enough
resources to run only a subset of tasks simultaneously; and then run a remaining
task as soon as a previous task is completed.  

We demonstrate this workflow with a simple multi-threaded program called
`multi_thread`, located in the `01_constant_decomp` directory of the exmaples
repo.  `multi_thread` take one argument for the number of threads, and each
thread performs some busy-work (a large summation).  For example, a single
instance of `multi_thread` with 6 threads would be executed like:

    ./multi_thread 6

Suppose you want to run many instances of `multi_thread`, each with a different
number of threads.  To schedule these tasks with PyLauncher, you would write an
input file like this (`constant_decomp.in`).  Each line is the command for a
separate task.

    ./multi_thread 2
    ./multi_thread 1
    ./multi_thread 6
    ./multi_thread 3
    ./multi_thread 4
    ./multi_thread 2
    ./multi_thread 3
    ./multi_thread 1
    ./multi_thread 6
    ./multi_thread 2
    ./multi_thread 2
    ./multi_thread 5 

Then, you would create a Python script that runs a `ClassicLauncher`.  The first
argument points to the input file; the `cores` argument specified the number of
cores for each task; and the `debug` argument specifies whether debugging info
is listed in the output.  In this case, each instance of `multi_thread` will be
run with 6 cores.  We chose 6 cores to in order to accommodate the tasks with the
maximum number of threads.  

    from pylauncher import pylauncher
    pylauncher.ClassicLauncher("constant_decomp.in", debug="", cores=6)

The following sbatch script (`constant_decomp.sbatch`) will run our script in a
Slurm job with 12 cores, as specified with `--ntasks-per-node=12`.  We first
load `gcc` to build `multi_thread`; and then load `pylauncher` to run
`constant_decomp.py`.  

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

When complete, the job's output file will be similar to this.  Let's consider
the "speedup" that's listed.  We requested 12 cores (from the sbatch script),
and each task will use 6 cores (from the Python script).  We would expect at
most (12 cores) / (6 cores/task) = 2 tasks to be running at any given time.
Hence the maximum speedup we would expect is 2.  Our actual results show a
speedup of 1.63, which is likely due to the overhead of scheduling tasks.

    Detecting 12 cores per node
    making ssh client to host atl1-1-02-012-17-2

    ==========================
    Launcherjob run completed.

    total running time:  22.14

    # tasks completed: 12
    tasks aborted: 0
    max runningtime:   3.02
    avg runningtime:   3.02
    aggregate      :  36.18
    speedup        :   1.63



    Host pool of size 12.

    Number of tasks executed per node:
    max: 6
    avg: 6

    ==========================

# Example 2: Running multi-threaded programs with variable decomposition

In `constant_decomp.in`, you'll notice that not every task uses 6 threads.  If
we could schedule each task with *only* the required number of CPUs, then we
could run more tasks at the same time.  To do so, we will create a new input
file with additional info (`variable_decomp.in` from the `02_variable_decomp`
directory).  There are now two comma-separated columns.  The second column shows
the command for a task; and the first column shows the number of CPUs to
allocate to that task.

    2,./multi_thread 2
    1,./multi_thread 1
    6,./multi_thread 6
    3,./multi_thread 3
    4,./multi_thread 4
    2,./multi_thread 2
    3,./multi_thread 3
    1,./multi_thread 1
    6,./multi_thread 6
    2,./multi_thread 2
    2,./multi_thread 2
    5,./multi_thread 5

To use this extra info in the Python script, we pass the argument `cores='file`
to `ClassicLauncher` (see `variable_decomp.py`)

    from pylauncher import pylauncher
    pylauncher.ClassicLauncher("variable_decomp.in", debug="", cores="file")

The sbatch script (`variable_decomp.sbatch`) will request 12 cores, as in Example 1.  
Now the job output resembles the following.  Note that the speedup here
(2.36) is higher than in Example 1 (1.63) since PyLauncher is able to schedule
more tasks at the same time.  

    ==========================
    Launcherjob run completed.

    total running time:  15.66

    # tasks completed: 12
    tasks aborted: 0
    max runningtime:   3.55
    avg runningtime:   3.08
    aggregate      :  36.96
    speedup        :   2.36



    Host pool of size 12.

    Number of tasks executed per node:
    max: 4
    avg: 3

    ==========================

## Example 3:  MPI Tasks

Now let's consider how to schedule multiple instances of an MPI program, each
with a different number of processes.  We will use an example program,
`multi_process` from the `03_mpi` directory, where each MPI process performs the
same summation as in `multi_thread`.   The `multi_process` program can infer the
number of processes without an additional argument.  

The input file looks like this (`multi_process.in`).  The second column
specifies the command for each task, and the first column specifies the number
of CPUs for each task.  This is the same task division as in Example 2.  

    2,./multi_process
    1,./multi_process
    6,./multi_process
    3,./multi_process
    4,./multi_process
    2,./multi_process
    3,./multi_process
    1,./multi_process
    6,./multi_process
    2,./multi_process
    2,./multi_process
    5,./multi_process

To run an MPI program with PyLauncher, we use an `SrunLauncher`, as in `multi_process.py`:

    from pylauncher import pylauncher
    pylauncher.SrunLauncher("multi_process.in", cores='file')

We will also run it with 12 CPUs, as in `multi_process.sbatch`.  The job's
output resembles the following.  Note that the overall execution time and
speedup are very similar to Example 2.  This is because the two programs are
performing similar workloads with the same task decomposition.  

    ==========================
    Launcherjob run completed.

    total running time:  14.61

    # tasks completed: 12
    tasks aborted: 0
    max runningtime:   3.03
    avg runningtime:   2.90
    aggregate      :  34.78
    speedup        :   2.38



    Host pool of size 12.

    Number of tasks executed per node:
    max: 4
    avg: 3

    ==========================