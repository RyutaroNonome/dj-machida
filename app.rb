require "./path.rb"
require "rubygems"
require "google_drive"
require "pp"
require 'oauth2'

def show_spreadsheet
  client = OAuth2::Client.new(
    @client_id,
    @client_secret,
    site: "https://accounts.google.com",
    token_url: "/o/oauth2/token",
    authorize_url: "/o/oauth2/auth")
  auth_token = OAuth2::AccessToken.from_hash(client,{:refresh_token => @refresh_token, :expires_at => 3600})
  auth_token = auth_token.refresh!
  session = GoogleDrive.login_with_oauth(auth_token.token)
  ws = session.spreadsheet_by_key(@MY_SPREAD_SHEET_KEY).worksheets[0]

  # レコード数を取得
  p ws.num_rows
  # カラム数を取得
  p ws.num_cols

  #pp ws.rows

  # ws.num_rows.times do |i|
  #   p i
  # end

  # ws[59, 50] = "test_input!"
  #
  # ws.save

end

show_spreadsheet