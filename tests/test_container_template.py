# encoding: utf-8

"""
Test module for ``container_template.sif`` singularity build 
or ``container_template`` dockerfile build

In case ``singularity`` is unavailable, the test function(s) should fall 
back to ``docker``.
"""

import os
import subprocess


# Check that (1) singularity exist, and (2) if not, check for docker. 
# If neither are found, tests will not run.
try:
    pth = os.path.join('containers', 'container_template.sif')
    out = subprocess.run('singularity')
    PREFIX = f'singularity run {pth}'
except FileNotFoundError:    
    try:
        out = subprocess.run('dockr')
        PREFIX = 'docker run -p 5001:5001 container_template'
    except FileNotFoundError:
        raise FileNotFoundError('Neither `singularity` nor `docker` found in PATH. Can not run tests!')

def test_assert():
    """dummy test that should pass"""
    assert True

def test_container_template_python():
    """test that the Python installation works"""
    call = f'{PREFIX} python --version'
    out = subprocess.run(call.split(' '))
    assert out.returncode == 0
