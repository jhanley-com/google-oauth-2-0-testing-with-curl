set CLIENT_ID=Replace_with_your_Client_ID
set CLIENT_SECRET=Replace_with_your_Client_Secret
set SCOPE=https://www.googleapis.com/auth/cloud-platform
set ENDPOINT=https://accounts.google.com/o/oauth2/v2/auth

set URL="%ENDPOINT%?client_id=%CLIENT_ID%&response_type=code&scope=%SCOPE%&access_type=offline&redirect_uri=urn:ietf:wg:oauth:2.0:oob"

@REM start iexplore %URL%
@REM start microsoft-edge:%URL%
start chrome %URL%

set /p AUTH_CODE="Enter Code displayed in browser: "

curl ^
--data client_id=%CLIENT_ID% ^
--data client_secret=%CLIENT_SECRET% ^
--data code=%AUTH_CODE% ^
--data redirect_uri=urn:ietf:wg:oauth:2.0:oob ^
--data grant_type=authorization_code ^
https://www.googleapis.com/oauth2/v4/token
