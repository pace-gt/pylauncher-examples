#!/usr/bin/env python3
from pylauncher import pylauncher

myjob = "constant_sn_job.in"
pylauncher.ClassicLauncher(myjob, debug="", cores=3)
