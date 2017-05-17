require 'sinatra'
require 'slack'
require './path.rb'
require './app.rb'

@bot_name = "DJ bot"

def params(channel_id = '', bot_name = '', text = '', user = '')
  {
    channel: channel_id,
    username: bot_name,
    icon_emoji: ":aw_yeah:",
    text: "<@#{user}>\n" + text
  }
end

def post_url_params(comment = '', user = '')
  @url = comment.match(/\<https?:\/\/.+?\>/).to_s.gsub(/(\<|\>|\|.+)/, "")
  @user = user
  return params(@channel_id, @bot_name, @url, @user)
end

def post_error_params(comment = '', user = '')
  text = comment
  @user = user
  return params(@channel_id, @bot_name, text, @user)
end

def get_url_params(comment = '', user = '')
  text = "こちら\n" + comment
  @user = user
  return params(@channel_id, @bot_name, text, @user)
end

Thread.start do
  Slack.auth_test
  Slack.configure {|config| config.token = @token }
    client = Slack.realtime
      puts "起動しました！"
    client.on :message do |data|
      puts "data取得可能"

      # URLをSpreadsheetに記入
      if (data['channel'] == @channel_id)
        puts "channel ok"
        puts data
        if (!data.has_key?('bot_id') && data['username'] != "slackbot")
          puts "I have not the key of bot_id and slackbot"
          if (data.has_key?('text'))
            puts "I have the key of text."
            if (!!(data['text'] =~ /\<https?:\/\/.+?\>/))
              puts "I have a url."
              if data['text'].scan(/https?.+?/).size.to_i == 1
                Slack.chat_postMessage post_url_params(data['text'], data['user'])
                access_spreadsheet # スプレッドシートに書き込み
              else
                puts "2個以上または0個マッチしています。"
                Slack.chat_postMessage post_error_params("正しく入力してください。", data['user'])
              end
            else
              puts "I have any urls."
            end
          else
            puts "I have not key of text"
          end
        end
      else
        puts "指定チャンネルではありません。"
      end

      # ノしたらURL出力
      if ((data['text'] == 'ノ' || data['text'] =='丿' || data['text'] =='ﾉ') && data['subtype'] != 'bot_message' && data['channel'] == @channel_id)
        Slack.chat_postMessage get_url_params(get_url_by_spreadsheet, data['user'])
      end
    end #client
  client.start
end #Slack


get '/' do
  "Hello"
end
