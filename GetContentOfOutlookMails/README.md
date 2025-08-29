# GetContentOfOutlookMails

This project provides a Python script to extract specific content from Outlook emails using the Microsoft Graph API via the [O365](https://o365.github.io/python-o365/latest/html/index.html) library.

## Features

- Authenticates with Microsoft Graph API using OAuth2.
- Connects to your Outlook mailbox and searches for emails with a specific subject.
- Extracts and prints the body content between two Dutch phrases ("Geachte relatie," and "Wij vertrouwen").
- Prints the received date and extracted message content for each matching email.

## Prerequisites

- Python
- Microsoft 365 account with API access
- Required Python packages (install with):
  ```sh
  pip install -r requirements.txt
  ```
- Register an Azure app and obtain your client ID and secret for authentication.
- Place your credentials in the script (`credentials`) and ensure the `lib` folder exists for token storage.

## Usage

1. **Configure credentials:**  
   Edit `getContentOfOutlookMails.py` and set your Microsoft app client ID and secret in `credentials`.

2. **Set your search subject:**  
   Adjust the `subject` variable to match the email subject you want to filter.

3. **Run the script:**  
   ```sh
   python getContentOfOutlookMails.py
   ```
   The script will prompt for authentication on the first run and store the token in `lib/token.txt`.

4. **Output:**  
   For each matching email, the script prints the received date and the extracted message content.

## Customization

- Change the `subject` variable to filter for different email subjects.
- Adjust the string extraction logic to match different email templates or languages.

## References

- [O365 Python Library Documentation](https://o365.github.io/python-o365/latest/html/index.html)
- [Microsoft Graph API Documentation](https://learn.microsoft.com/en-us/graph/overview)

## License

This project is released into the public domain. You may use, modify, and distribute it without restriction.