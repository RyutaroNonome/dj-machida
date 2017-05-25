require "rubygems"
require "google_drive"
require "pp"
require 'oauth2'

class Spread
  @client_id           = ENV['client_id']
  @client_secret       = ENV['client_secret']
  @refresh_token       = ENV['refresh_token']
  @MY_SPREAD_SHEET_KEY = ENV['MY_SPREAD_SHEET_KEY']

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

  def self.access_spreadsheet
    # client = OAuth2::Client.new(
    #   @client_id,
    #   @client_secret,
    #   site: "https://accounts.google.com",
    #   token_url: "/o/oauth2/token",
    #   authorize_url: "/o/oauth2/auth")
    # auth_token = OAuth2::AccessToken.from_hash(client,{:refresh_token => @refresh_token, :expires_at => 3600})
    # auth_token = auth_token.refresh!
    # session = GoogleDrive.login_with_oauth(auth_token.token)
    # ws = session.spreadsheet_by_key(@MY_SPREAD_SHEET_KEY).worksheets[0]
    # B, C, D列にスラックから記入
    @row_id , @col_id = 0

    # レコード数を取得
    p ws.num_rows
    # カラム数を取得
    p ws.num_cols
    @row_id = ws.num_rows
    ws[@row_id + 1, 2] = @url
    ws[@row_id + 1, 3] = @description
    # ws[@row_id + 1, 4] = user_name
    ws[@row_id + 1, 5] = @user


    ws.save
    #id リセット
    @row_id , @column_id = 0
  end

  def self.get_url_by_spreadsheet
    # client = OAuth2::Client.new(
    #   @client_id,
    #   @client_secret,
    #   site: "https://accounts.google.com",
    #   token_url: "/o/oauth2/token",
    #   authorize_url: "/o/oauth2/auth")
    # auth_token = OAuth2::AccessToken.from_hash(client,{:refresh_token => @refresh_token, :expires_at => 3600})
    # auth_token = auth_token.refresh!
    # session = GoogleDrive.login_with_oauth(auth_token.token)
    # ws = session.spreadsheet_by_key(@MY_SPREAD_SHEET_KEY).worksheets[0]

    # 2行目以降のランダムな数字を出力 0.1.2... → 2.3.4...
    random_num = rand(ws.num_rows.to_i) + 2
    @getted_description = ws[random_num, 3]
    @getted_url = ws[random_num, 2]
    return @getted_url + "\n" + @getted_description
  end
end