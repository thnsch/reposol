
"""
calendarUpdate.py

Removes existing events from a specified Google Calendar and imports new events from a JSON file.

Workflow:
- Authenticates with Google Calendar API using OAuth2.
- Searches for and deletes calendar events matching a search string.
- Imports new events from a JSON file (supports all-day and timed events).

Defaults and Notes:
- Default timezone: Europe/Amsterdam.
- Calendar ID and search string must be set in the script.
- Requires: google-api-python-client, oauth2client, httplib2.
- JSON file must be UTF-16 encoded and match the expected structure.
- If SCOPES is modified, delete 'script/token.json' to re-authenticate.

References:
- Google Calendar API Python Quickstart: https://developers.google.com/calendar/quickstart/python
- Google Calendar API Reference: https://developers.google.com/calendar/v3/reference/events
- argparse documentation: https://docs.python.org/3/howto/argparse.html

"""

from __future__ import print_function
import os
import sys
import argparse
import json
import re
# import datetime
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools

timezone = 'Europe/Amsterdam'
myHome = os.getcwd()

# if modifying scopes, delete the file token.json
SCOPES = 'https://www.googleapis.com/auth/calendar.events'


googleApi = 'calendar'
googleApiVersion = 'v3'
googleCalendarId='xxxxxxxxxxxx@group.calendar.google.com'
searchString = 'Ikea'


def main(mySchedule):
	"""Remove calendar events and import the provided JSON file.
	"""

	token = '{}/script/token.json'.format(myHome)
	clientsecret = '{}/script/client_secret.json'.format(myHome)
	srcEvents = '{}/{}'.format(myHome, mySchedule)

	### authenticate
	store = file.Storage(token)
	creds = store.get()
	if not creds or creds.invalid:
		flow = client.flow_from_clientsecrets(clientsecret, SCOPES)
		creds = tools.run_flow(flow, store)
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
		### remove existing entries
		print('\n')
		for event in events:
			# for content in event:
				# print(content, ':', event[content])
			print('-', event['start'].get('dateTime'), event['summary'])

		print('\nATTENTION! The listed {} {} events will be removed.'.format(len(events), searchString))
		input('\nPress enter to continue. CTRL + C to cancel.')
		print('Removing events...')
		for event in events:
			try:
				service.events().delete(calendarId=googleCalendarId, eventId=event['id']).execute()
			except:
				print ("remove error:", sys.exc_info()[0])
	else:
		print('Nothing to remove.')

	### import the json file
	with open(srcEvents, "r", encoding="utf16") as jsonFile:
		jsonString = jsonFile.read()
		data = json.loads(jsonString)
		print('Importing {} events...'.format(len(data['events'])))
		for p in data['events']:
			EVENT = {
				'summary':		p['summary'],
				'description':	p['description']
			}

			# all-day-event starts at 00:00:00 a.m.
			if re.match('.+00:00:00$', p['start']):
				EVENT.update( 
					{'start':	{'date': p['date'], 'timeZone': '{}'.format(timezone)},
					'end':		{'date': p['date'], 'timeZone': '{}'.format(timezone)}} 
				)
			else:
				EVENT.update(
					{'start':	{'dateTime': p['start'], 'timeZone': '{}'.format(timezone)},
					'end':		{'dateTime': p['end'], 'timeZone': '{}'.format(timezone)}} 
				)

			try:
				service.events().insert(calendarId=googleCalendarId, sendNotifications=True, body=EVENT).execute()
			except:
				print ("insert error:", sys.exc_info()[0])
				print (EVENT)
			# break

			
if __name__ == '__main__':

	parser = argparse.ArgumentParser(description='Remove existing events from a Google calendar, and import the delivered events.')
	# parser.add_argument("--home",
	# 	action='store', 
	# 	dest='myHome',
	# 	default='D:\schedule', 
	# 	help="Home path, default: D:\schedule")
	parser.add_argument("--schedule",
		action='store', 
		dest='mySchedule',
		default='report.json', 
		help="The name of the schedule file, default: report.json")
	args = parser.parse_args()
	
	main(args.mySchedule)
