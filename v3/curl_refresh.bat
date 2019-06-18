@set FILE=\config\client_secrets.json

@set CMD_1=jq -r ".installed.client_id" %FILE%
@set CMD_2=jq -r ".installed.client_secret" %FILE%

@for /f %%i in ('%CMD_1%') do set CLIENT_ID=%%i
@for /f %%i in ('%CMD_2%') do set CLIENT_SECRET=%%i

@echo Client ID: %CLIENT_ID%
@echo Client Secret: %CLIENT_SECRET%

set ENDPOINT=https://www.googleapis.com/oauth2/v4/token

set /p REFRESH_TOKEN=<refresh.token

curl ^
--data client_id=%CLIENT_ID% ^
--data client_secret=%CLIENT_SECRET% ^
--data grant_type=refresh_token ^
--data refresh_token=%REFRESH_TOKEN% ^
%ENDPOINT% > oauth_refreshed.token

jq -r ".access_token" oauth_refreshed.token > access.token
set /p ACCESS_TOKEN=<access.token

jq -r ".id_token" oauth_refreshed.token > id.token
set /p ID_TOKEN=<id.token

echo "Token Information:"
curl -H "Authorization: Bearer %ACCESS_TOKEN%" https://www.googleapis.com/oauth2/v3/tokeninfo
