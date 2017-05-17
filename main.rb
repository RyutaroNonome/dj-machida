require 'sinatra'
require 'slack'
require './path.rb'
require './app.rb'

@bot_name = "test"

def params(channel_id = '', bot_name = '', text = '')
  {
    channel: channel_id,
    username: bot_name,
    text: text
  }
end

def post_url(comment = '')
  @url = comment.match(/\<https?:\/\/.+?\>/).to_s.gsub(/(\<|\>|\|.+)/, "")
  return @url
end

def post_url_params(comment = '')
  @url = comment.match(/\<https?:\/\/.+?\>/).to_s.gsub(/(\<|\>|\|.+)/, "")
  return params(@channel_id, @bot_name, @url)
end

def post_error_params(comment = '')
  text = comment
  return params(@channel_id, @bot_name, text)
end

Thread.start do
  Slack.auth_test
  Slack.configure {|config| config.token = @token }
    client = Slack.realtime
      puts "起動しました！"
    client.on :message do |data|
      puts "data取得可能"

      if (data['channel'] == @channel_id)
        puts "channel ok"
        puts data
        if (!data.has_key?('bot_id'))
          puts "I have not the key of bot_id."
          if (data.has_key?('text'))
            puts "I have the key of text."
            if (!!(data['text'] =~ /\<https?:\/\/.+?\>/))
              puts "I have a url."
              if data['text'].scan(/https?.+?/).size.to_i == 1
                Slack.chat_postMessage post_url_params(data['text'])
                access_spreadsheet # スプレッドシートに書き込み
              else
                puts "2個以上または0個マッチしています。"
                Slack.chat_postMessage post_error_params("正しく入力してください。")
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

    end #client
  client.start
end #Slack


get '/' do
  "Hello"
end