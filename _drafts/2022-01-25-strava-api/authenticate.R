library(httr)
strava_endpoint <- oauth_endpoint(
  request = NULL,
  authorize = "authorize", 
  access = "token",
  base_url = "https://www.strava.com/api/v3/oauth/"
)

myapp <- oauth_app(
  "strava", 
  key = 77114, 
  secret = "4cc3840c95ac7c819b727f5d93a2afeead69b8af"
)

mytok <- oauth2.0_token(
  endpoint = strava_endpoint, 
  app = myapp,
  scope = c("activity:read_all"),
  cache = TRUE
)
