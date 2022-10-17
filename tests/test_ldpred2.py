# encoding: utf-8

"""
Test module for ``ldpred2.sif`` singularity build 
or ``ldpred2`` dockerfile build

In case ``singularity`` is unavailable, the test function(s) should fall 
back to ``docker``.
"""

import os
import subprocess


# Check that (1) singularity exist, and (2) if not, check for docker. 
# If neither are found, tests will not run.
try:
    pth = os.path.join('containers', 'ldpred2.sif')
    out = subprocess.run('singularity')
    PREFIX = f'singularity run {pth}'
except FileNotFoundError:    
    try:
        out = subprocess.run('docker')
        PREFIX = 'docker run -p 5001:5001 ldpred2'
    except FileNotFoundError:
        raise FileNotFoundError('Neither `singularity` nor `docker` found in PATH. Can not run tests!')


def test_ldpred2_R():
    call = f'{PREFIX} R --version'
    out = subprocess.run(call.split(' '))
    assert out.returncode == 0

def test_ldpred2_Rscript():
    call = f'{PREFIX} Rscript --version'
    out = subprocess.run(call.split(' '))
    assert out.returncode == 0

def test_ldpred2_R_libraries():
    pwd = os.getcwd()
    call = f'singularity run --home={pwd} {pth} Rscript {pwd}/tests/extras/libraries.R'
    out = subprocess.run(call.split(' '))
    assert out.returncode == 0