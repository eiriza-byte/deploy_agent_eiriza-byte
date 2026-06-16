


# deploy_agent_eiriza-byte

## Description
A shell script that automates the creation of a Student Attendance Tracker project workspace.

## How to Run the Script
1. Clone the repository

2. Navigate into the directory deploy_agent_eiriza-byte

3. Make the script executable using chmod +x 

4. Run the script

5. Follow the prompts:
   - Enter a project name
   - Choose whether to update attendance thresholds

## How to Trigger the Archive Feature
1. Run the script:
   ./setup_project.sh
2. Enter a project name when prompted
3. Press Ctrl+C at any point during execution
4. The script will automatically:
   - Put the incomplete project into an archive file named attendance_tracker_{input}_archive.tar.gz
   - Delete the incomplete directory to keep the workspace clean

## Project Structure Created
```

attendance_tracker_{input}/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
    └── reports.log

```
## Default Thresholds
- Warning: 75%
- Failure: 50%
## Live Demonstartion of script : https://drive.google.com/file/d/1ri-a8FsN-LyhrH0zVcabYyb_-xPm9usS/view?usp=drive_link 
