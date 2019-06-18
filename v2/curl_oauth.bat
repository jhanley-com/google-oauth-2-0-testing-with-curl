@set FILE=\config\client_secrets.json

@set CMD_1=jq -r ".installed.client_id" %FILE%
@set CMD_2=jq -r ".installed.client_secret" %FILE%

@for /f %%i in ('%CMD_1%') do set CLIENT_ID=%%i
@for /f %%i in ('%CMD_2%') do set CLIENT_SECRET=%%i

@echo Client ID: %CLIENT_ID%
@echo Client Secret: %CLIENT_SECRET%

set SCOPE=https://www.googleapis.com/auth/cloud-platform https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile

set ENDPOINT=https://accounts.google.com/o/oauth2/v2/auth

set URL="%ENDPOINT%?client_id=%CLIENT_ID%&response_type=code&scope=%SCOPE%&access_type=offline&redirect_uri=http://localhost:9000"

@REM start iexplore %URL%
start chrome %URL%
@REM start microsoft-edge:%URL%

@REM Run the webserver and store the code in a file
python webserver.py > code.txt
set /p AUTH_CODE=<code.txt

curl ^
--data client_id=%CLIENT_ID% ^
--data client_secret=%CLIENT_SECRET% ^
--data code=%AUTH_CODE% ^
--data redirect_uri=http://localhost:9000 ^
--data grant_type=authorization_code ^
https://www.googleapis.com/oauth2/v4/token > oauth.token

jq -r ".access_token" oauth.token > access.token
set /p ACCESS_TOKEN=<access.token

jq -r ".refresh_token" oauth.token > refresh.token
set /p REFRESH_TOKEN=<refresh.token

echo "Token Information:"
curl -H "Authorization: Bearer %ACCESS_TOKEN%" https://www.googleapis.com/oauth2/v3/tokeninfo

echo "User Information:"
curl -H "Authorization: Bearer %ACCESS_TOKEN%" https://www.googleapis.com/oauth2/v3/userinfo
