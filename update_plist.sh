#!/bin/bash
PLIST="ios/Runner/Info.plist"

# Just to make sure we have a backup
cp $PLIST ${PLIST}.bak

# Add LSApplicationQueriesSchemes for url_launcher if it doesn't exist
if ! grep -q "LSApplicationQueriesSchemes" "$PLIST"; then
  # Insert before the last </dict>
  sed -i '' '/<\/dict>/,$!b;//i\
	<key>LSApplicationQueriesSchemes</key>\
	<array>\
		<string>http</string>\
		<string>https</string>\
		<string>mailto</string>\
		<string>tel</string>\
		<string>sms</string>\
	</array>
' "$PLIST"
fi

# Add UIBackgroundModes for firebase_messaging if it doesn't exist
if ! grep -q "UIBackgroundModes" "$PLIST"; then
  sed -i '' '/<\/dict>/,$!b;//i\
	<key>UIBackgroundModes</key>\
	<array>\
		<string>fetch</string>\
		<string>remote-notification</string>\
	</array>
' "$PLIST"
fi
