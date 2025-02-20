#!/usr/bin/env python3
from pylauncher import pylauncher

myjobname="mpi_job.in"
pylauncher.SrunLauncher(myjobname, cores='file')
