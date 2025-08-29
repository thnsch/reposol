# MigrateWorkSchedule

> **Notes:**  
> This workflow is designed for **Windows** environments and uses Batch (`.bat`) and PowerShell (`.ps1`) scripts beside Python.  
> The PDF-to-json convertion is based on the PDF layout of **January 2020**.

# Table of Contents

- [Workflow Overview](#workflow-overview)
- [Python Script Details](#python-script-details)
  - [Features](#features)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)
  - [Customization](#customization)
- [License](#license)

## Workflow Overview

This project provides tools for migrating an Ikea PDF work schedule in Google Calendar including removing the old events. The main workflow is automated by the [`MijnWerk.bat`](./MijnWerk.bat) batch file, which guides you through converting your schedule PDF to a text file, generating JSON and ICS files, and updating your Google Calendar.


The `MijnWerk.bat` script automates the following steps:

⚠️ Important: Make sure to place your downloaded work schedule PDF in the main folder before running MijnWerk.bat.

1. **Checks for a single PDF file** in the folder (your schedule).
2. **Deletes old `.txt`, `.ics`, and `.json` files** to avoid conflicts.
3. **Converts the PDF to a text file** using `pdftotext`.
4. **Generates JSON and ICS files** from the text file using the PowerShell script [`script/createIcsAndJsonFiles.ps1`](./script/createIcsAndJsonFiles.ps1).
5. **Updates your Google Calendar** by running the Python script [`script/calendarUpdate.py`](./script/calendarUpdate.py) with the generated JSON file.

To use the workflow, simply place your schedule PDF in the folder and run:

```sh
MijnWerk.bat
```

Follow the on-screen prompts to complete the migration.

# Python Script Details

## Features

- Authenticates with Google Calendar API using OAuth2.
- Searches for and removes calendar events matching a search string.
- Imports new events from a JSON file (supports all-day and timed events).
- Command-line interface for specifying input paths and files.

## Prerequisites

- Python 3.6 or higher
- Google account with Calendar API enabled
- Required Python packages (install with the command below):

  ```sh
  pip install -r requirements.txt
  ```

- Google API credentials (`client_secret.json`) placed in the `script` subfolder.

## Usage

1. **Clone this repository** and navigate to the `MigrateWorkSchedule` folder.

2. **Set up Google API credentials:**
   - Create a Google Cloud project and enable the Calendar API at [https://console.cloud.google.com/](https://console.cloud.google.com/).
   - Download your `client_secret.json` and place it in the `script` subfolder.
   - The script will generate a `token.json` in the same folder after the first run.

3. **Prepare your events JSON file:**  
   Ensure your JSON file matches the expected format (see below).

4. **Run the script:**
   ```sh
   python script/calendarUpdate.py --home <path_to_home_folder> --schedule <events_json_file>
   ```
   Example:
   ```sh
   python script/calendarUpdate.py --home ~/schedules --schedule report.json
   ```

   The script will list and remove existing events matching the search string, then import new events from your JSON file.

## JSON File Format

Your events JSON file should look like:

```json
{
  "events": [
    {
      "summary": "Event Title",
      "description": "Event Description",
      "start": "2025-09-01T09:00:00",
      "end": "2025-09-01T10:00:00",
      "date": "2025-09-01"
    }
    // ... more events ...
  ]
}
```

- For all-day events like vacation, the `start` time should end with `00:00:00` and the `date` field should be present.
- Times are according to your timezone.

## Customization

- Edit `googleCalendarId` and `searchString` in `calendarUpdate.py` to match your calendar and event filter.
- Adjust the script as needed for your event data structure.

## autoit-v3 Subfolder

The `autoit-v3` subfolder contains a standalone script intended to download the PDF work schedule file.  
This script is not part of the main migration workflow. Its functionality is unverified and I am no longer able to test it. 

## License

This project is released into the public domain. You may use, modify, and distribute it without restriction.

