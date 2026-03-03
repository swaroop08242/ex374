"""
Tests for Ansible playbooks and utility functions.
Add your own tests here as the project grows.
"""

import os
import subprocess
import pytest


@pytest.mark.ansible
def test_ansible_syntax_check():
    """Ensure the main playbook passes syntax check."""
    result = subprocess.run(
        [
            "ansible-playbook",
            "ansible/playbooks/site.yml",
            "--syntax-check",
            "-i",
            "ansible/inventory/",
        ],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, f"Syntax check failed:\n{result.stderr}"


@pytest.mark.ansible
def test_inventory_file_exists():
    """Ensure the inventory file is present and readable."""
    inventory_path = "ansible/inventory/hosts.yml"
    assert os.path.exists(inventory_path), f"Inventory not found: {inventory_path}"


@pytest.mark.ansible
def test_ansible_cfg_exists():
    """Ensure ansible.cfg is present."""
    assert os.path.exists("ansible/ansible.cfg"), "ansible.cfg is missing"


def test_requirements_txt_exists():
    """Ensure requirements.txt is present."""
    assert os.path.exists("requirements.txt")


def test_requirements_yml_exists():
    """Ensure requirements.yml is present."""
    assert os.path.exists("requirements.yml")
