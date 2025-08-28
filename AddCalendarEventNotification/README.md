# AddCalendarEventNotification

This project provides a Python script to add popup reminders to all events in a specified Google Calendar. It is useful for automatically updating calendar events (such as waste collection reminders) with notifications.

## Features

- Authenticates with Google Calendar API using OAuth2.
- Searches for all events in the specified calendar.
- Adds or updates popup reminders for each event (default: 13 hours before the event).
- Prints a summary of updated events.

## Prerequisites

- Python
- A Google account with the Calendar API enabled
- Required Python packages.  

## Usage

1. **Clone this repository** and navigate to the `AddCalendarEventNotification` folder.

2. **Set up Google API credentials:**
   - Create a Google Cloud project and enable the Calendar API at https://console.cloud.google.com/.
   - Download your `client_secret.json` and place it in the `my_lib` subfolder.
   - The script will generate a `token.json` in the same folder after the first run.

3. **Configure the script:**
   - Edit `AddCalendarEventNotification.py` and set your `googleCalendarId` to your calendar's ID.

4. **Install dependencies:**
   ```sh
   pip install -r requirements.txt
   ```

5. **Run the script:**
   ```sh
   python AddCalendarEventNotification.py
   ```

   The script will prompt for authentication on the first run.

## Customization

- Change the `minutesBeforeEvent` variable in `AddCalendarEventNotification.py` to adjust how long before the event the reminder should trigger.
- You can modify the `searchString` variable to filter which events are updated.

## References

- [Google Calendar API Python Quickstart](https://developers.google.com/calendar/quickstart/python)
- [Google Calendar API Reference](https://developers.google.com/calendar/v3/reference/events/patch)

## License

This project is released into the public domain. You may use, modify, and distribute it without restriction.