"""
getContentOfOutlookMails.py

Extracts specific content from Outlook emails using the Microsoft Graph API via the O365 library.

Features:
- Authenticates with Microsoft Graph API using OAuth2.
- Connects to the user's Outlook mailbox and searches for emails with a specified subject.
- Extracts and prints the body content between two Dutch phrases ("Geachte relatie," and "Wij vertrouwen").
- Prints the received date and extracted message content for each matching email.

Authentication:
- The default authentication method is "on behalf of a user" (`auth_flow_type='authorization'`).
- Scope: 'offline_access' and 'https://graph.microsoft.com/Mail.Read'
- Credentials must be set in the script (`credentials`).
- Token is stored in the 'lib' folder as 'token.txt'.

Defaults and Notes:
- Requires: O365 Python package.
- The subject to search for is set in the 'subject' variable.
- Adjust string extraction logic for different email templates or languages.

References:
- O365 Python Library Documentation: https://o365.github.io/python-o365/latest/html/index.html
- Microsoft Graph API Documentation: https://learn.microsoft.com/en-us/graph/overview

"""

import pdb   # debug package, find pdb.set_trace() below
from O365 import Account, FileSystemTokenBackend, MSGraphProtocol


# Set your credentials here
credentials = ('xxxxxxxx', 'xxxxxxxx')
scope = ['offline_access', 'https://graph.microsoft.com/Mail.Read']
# myPrincipal='xxxxx@outlook.com'
tokenBackend = FileSystemTokenBackend(
	token_path     = 'lib', 
	token_filename = 'token.txt')
protocol = MSGraphProtocol()

account = Account(
	credentials   = credentials, 
	scopes        = scope, 
	token_backend = tokenBackend, 
	protocol      = protocol)

subject = 'Betaalalert'

if not account.is_authenticated:
	if account.authenticate():
		print('Authenticated!')

# account.connection.refresh_token()
# quit()
   
myMailbox = account.mailbox()

# myInbox = myMailbox.get_folder(folder_name='Inbox')
myInbox = myMailbox.inbox_folder()

print ("\r")

for message in myInbox.get_messages():
	if not message.subject == subject:
		continue
	html_body = message.get_body_text()

	msgBody = html_body[html_body.find('Geachte relatie,')+20:html_body.find('Wij vertrouwen')]
	# msgBody = html_body[html_body.find('Dear Client,')+16:html_body.find('We trust')-4]
	# msgBody = msgBody.replace('.', ',', 1)  # change decimal-separator from EN to NL

	msgDate = message.received

	# pdb.set_trace()
	# print("{0}{1}{2}".format(msgDate, "\r\n", msgBody))
	print("\n{0}\n{1}".format(msgDate, msgBody))

print ("\r")
