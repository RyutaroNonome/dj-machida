require "rubygems"
require "google_drive"
require "pp"
require 'oauth2'

  @client_id           = ENV['client_id']
  @client_secret       = ENV['client_secret']
  @refresh_token       = ENV['refresh_token']
  @MY_SPREAD_SHEET_KEY = ENV['MY_SPREAD_SHEET_KEY']
  def init
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
  end

  def access_spreadsheet
    ws = init
    @row_id , @col_id = 0
    # レコード数を取得
    p ws.num_rows
    # カラム数を取得
    p ws.num_cols
    @row_id = ws.num_rows
    ws[@row_id + 1, 2] = @url
    ws[@row_id + 1, 3] = @description
    ws[@row_id + 1, 5] = @user


    ws.save
    #id リセット
    @row_id , @column_id = 0
  end

  def get_url_by_spreadsheet
    ws = init
    # 2行目以下のランダムな数字を出力 0.1.2... → 2.3.4...
    random_num = rand(ws.num_rows.to_i) + 2
    @getted_description = ws[random_num, 3]
    @getted_url = ws[random_num, 2]
    return @getted_url + "\n" + @getted_description
  end