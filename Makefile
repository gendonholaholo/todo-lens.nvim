.PHONY: test format lint install clean

# Run tests
test:
	@echo "Running tests..."
	busted --verbose

# Format code with stylua
format:
	@echo "Formatting code..."
	stylua --config-path .stylua.toml .

# Check code formatting
lint:
	@echo "Checking code formatting..."
	stylua --config-path .stylua.toml --check .

# Install dependencies for development
install:
	@echo "Installing dependencies..."
	luarocks install busted
	luarocks install luacov
	luarocks install stylua

# Clean up generated files
clean:
	@echo "Cleaning up..."
	rm -f luacov.stats.out
	rm -f luacov.report.out

# Run tests with coverage
test-coverage:
	@echo "Running tests with coverage..."
	busted --verbose --coverage

# Generate coverage report
coverage-report: test-coverage
	@echo "Generating coverage report..."
	luacov

# Development setup
dev-setup: install
	@echo "Development environment ready!"

# CI tasks
ci: lint test
	@echo "CI tasks completed!" 