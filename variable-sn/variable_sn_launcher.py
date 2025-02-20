#!/usr/bin/env python3
from pylauncher import pylauncher

myjob = "variable_sn_job.in"
pylauncher.ClassicLauncher(myjob, debug="", cores="file")
