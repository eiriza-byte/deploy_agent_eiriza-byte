#!/bin/bash
#The trap
cleanup() {
	echo ""
	echo "Script interrupted! Archiving current state..."
	tar -czf attendance_tracker_${input}_archive.tar.gz attendance_tracker_${input}/
	rm -rf attendance_tracker_${input}/
	echo "Archive created and incomplete directory deleted."
	exit 1
}
trap cleanup SIGINT

# Get user input
read -p "Enter project name: " input

# Validate input is not empty
if [ -z "$input" ]; then
    echo "Error: Project name cannot be empty!"
    exit 1
fi

echo "Creating project: attendance_tracker_${input}..."

# Create directory structure
BASE_DIR="attendance_tracker_${input}"

# Check if directory already exists
if [ -d "$BASE_DIR" ]; then
    echo "Error: Directory ${BASE_DIR} already exists!"
    exit 1
fi

# Create directories
mkdir -p ${BASE_DIR}/Helpers
mkdir -p ${BASE_DIR}/reports

# Copy files into correct locations
cp attendance_checker.py ${BASE_DIR}/
cp assets.csv ${BASE_DIR}/Helpers/
cp config.json ${BASE_DIR}/Helpers/
cp reports.log ${BASE_DIR}/reports/

echo "Directory structure created successfully!"
# Dynamic Configuration
read -p "Do you want to update attendance thresholds? (y/n): " answer

if [ "$answer" = "y" ]; then
    # Get warning threshold
    read -p "Enter new Warning threshold (default 75): " warning_val
    read -p "Enter new Failure threshold (default 50): " failure_val

    # Validate inputs are numbers
    if ! [[ "$warning_val" =~ ^[0-9]+$ ]]; then
        echo "Error: Warning threshold must be a number!"
        exit 1
    fi

    if ! [[ "$failure_val" =~ ^[0-9]+$ ]]; then
        echo "Error: Failure threshold must be a number!"
        exit 1
    fi

    # Use sed to update config.json
    sed -i "s/\"warning\": [0-9]*/\"warning\": $warning_val/" ${BASE_DIR}/Helpers/config.json
    sed -i "s/\"failure\": [0-9]*/\"failure\": $failure_val/" ${BASE_DIR}/Helpers/config.json

    echo "Thresholds updated successfully!"
    echo "Warning: ${warning_val}%"
    echo "Failure: ${failure_val}%"
elif [ "$answer" = "n" ]; then
    echo "Keeping default thresholds (Warning: 75%, Failure: 50%)"
else
	echo "Invalid input! Please enter y or n"
	exit 1
fi
# ── HEALTH CHECK ──
echo ""
echo "Running Health Check..."

# Check if python3 is installed
if python3 --version &>/dev/null; then
    echo "✅ Python3 is installed: $(python3 --version)"
else
    echo "⚠️ Warning: Python3 is not installed!"
fi

# Check directory structure
echo ""
echo "Verifying directory structure..."

if [ -d "${BASE_DIR}" ]; then
    echo "✅ Main directory exists"
else
    echo "❌ Main directory missing!"
fi

if [ -f "${BASE_DIR}/attendance_checker.py" ]; then
    echo "✅ attendance_checker.py exists"
else
    echo "❌ attendance_checker.py missing!"
fi

if [ -d "${BASE_DIR}/Helpers" ]; then
    echo "✅ Helpers directory exists"
else
    echo "❌ Helpers directory missing!"
fi

if [ -f "${BASE_DIR}/Helpers/assets.csv" ]; then
    echo "✅ assets.csv exists"
else
    echo "❌ assets.csv missing!"
fi

if [ -f "${BASE_DIR}/Helpers/config.json" ]; then
    echo "✅ config.json exists"
else
    echo "❌ config.json missing!"
fi

if [ -d "${BASE_DIR}/reports" ]; then
    echo "✅ reports directory exists"
else
    echo "❌ reports directory missing!"
fi

if [ -f "${BASE_DIR}/reports/reports.log" ]; then
    echo "✅ reports.log exists"
else
    echo "❌ reports.log missing!"
fi

echo ""
echo "Health Check Complete!"
echo ""
echo "✅ Project setup complete! Your project is ready at: ${BASE_DIR}/"
