def pytest_configure(config):
    """Register custom markers."""
    config.addinivalue_line(
        "markers", "ansible: marks tests related to ansible playbooks"
    )
    config.addinivalue_line("markers", "integration: marks integration tests")
