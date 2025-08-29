
"""
addCalendarEventNotification.py

This script adds or updates popup reminders for all events in a specified Google Calendar.

Defaults and Notes:
- Uses Python 2/3 compatible print function via __future__ import.
- Default timezone is set to 'Europe/Amsterdam'.
- Google Calendar API v3 is used.
- The script uses OAuth2 for authentication; credentials are stored in 'lib/token.json'.
- By default, reminders are set to trigger 13 hours (13*60 minutes) before each event.
- The calendar ID and search string should be set in the script.
- If you modify the SCOPES variable, delete 'token.json' to re-authenticate.
- Requires: google-api-python-client, oauth2client, httplib2.

References:
- Google Calendar API Python Quickstart: https://developers.google.com/calendar/quickstart/python
- Google Calendar API Reference: https://developers.google.com/calendar/v3/reference/events/patch
- argparse documentation: https://docs.python.org/3/howto/argparse.html

"""

from __future__ import print_function
import sys
import argparse
import json
import re
import pdb   # debug package, find pdb.set_trace() below
# import datetime
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools

timezone = 'Europe/Amsterdam'

# if modifying scopes, delete the file token.json
SCOPES = 'https://www.googleapis.com/auth/calendar.events'

libFolder = 'lib'

googleApi = 'calendar'
googleApiVersion = 'v3'
googleCalendarId='xxxxxxxx@group.calendar.google.com'  # calendar: Afval
searchString = ''

minutesBeforeEvent = 13*60   # remind x minutes before the event-start

# def main(myHome, mySchedule):
def main():
	"""Add a reminder to AFVAL events.
	"""

	token = './{}/token.json'.format(libFolder)
	clientsecret = './{}/client_secret.json'.format(libFolder)

	### authenticate
	store = file.Storage(token)
	creds = store.get()
	if not creds or creds.invalid:
		flow = client.flow_from_clientsecrets(clientsecret, SCOPES)
		creds = tools.run_flow(flow, store)
	# service object for API
	service = build(googleApi, googleApiVersion, http=creds.authorize(Http()))

	### search existing entries
	# now = datetime.datetime.utcnow().isoformat() + 'Z' # 'Z' indicates UTC time
	events_result = service.events().list(
		# timeMin=now,
		# maxResults=1, 
		calendarId=googleCalendarId, 
		orderBy='startTime',
		singleEvents=True,
		q=searchString
	).execute()
	events = events_result.get('items', [])

	if events:
		print('\n')
		# pdb.set_trace()
		for event in events:
			# for content in event:
				# print(content, ':', event[content])
			print('-', event['start'].get('date'), event['summary'])
			event['reminders'] = {'useDefault': False, 'overrides': [{'method': 'popup', 'minutes': minutesBeforeEvent}]}
			try:
				service.events().patch(calendarId=googleCalendarId, eventId=event['id'], body=event).execute()
				# service.events().delete(calendarId=googleCalendarId, eventId=event['id']).execute()
			except:
				print ("update error:", sys.exc_info()[0])
			
			# print(event)
			# input('\nPress enter to continue. CTRL + C to cancel.')

	else:
		print('No events found.')

			
if __name__ == '__main__':

	# parser = argparse.ArgumentParser(description='Add a notification to events.')
	# parser.add_argument("--home",
		# action='store', 
		# dest='myHome',
		# default='D:\schedule', 
		# help="Home path, default: D:\schedule")
	# parser.add_argument("--schedule",
		# action='store', 
		# dest='mySchedule',
		# default='report.json', 
		# help="The name of the schedule file, default: report.json")
	# args = parser.parse_args()
	
	# main(args.myHome, args.mySchedule)
	main()

