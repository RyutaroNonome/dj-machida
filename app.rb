require "./path.rb"
require "rubygems"
require "google_drive"
require "pp"
require 'oauth2'

def access_spreadsheet
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


  #pp ws.rows

  # ws.num_rows.times do |i|
  #   p i
  # end

  # ws[3, 4] = "test_input!"

# (1..ws.num_rows).each do |row|
#   (1..ws.num_cols).each do |col|
#     p ws[row, col]
#   end
# end

  # レコード数を取得
  p ws.num_rows
  # カラム数を取得
  p ws.num_cols



# B, C, D列にスラックから記入
@row_id , @column_id = 0
# def input_to_sheet
  @row_id = ws.num_rows
  @column_id = 2

  ws[@row_id + 1, @column_id] = @url

  ws.save
  #id リセット
  @row_id , @column_id = 0
# end
end

# access_spreadsheet