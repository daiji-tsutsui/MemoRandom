require 'open-uri'

module PostsHelper

  def name_post(post)
    if /.+\.html\z/ === post.memo.url
      if Rails.env.production?
        open(post.memo.url) do |input|
          content = input.read
          title = content[/<h1.*>(.+)<\/h1>/, 1]
          title.blank? ? "no_name" : title
        end
      else
        File.open("public/" + post.memo.url) do |input|
          content = input.read
          title = content[/<h1.*>(.+)<\/h1>/, 1]
          title.blank? ? "no_name" : title
        end
      end
    else
      return original_filename(post.memo.url)
    end
  end

  def original_filename(url)
    url.instance_of?(String) ? url[/\/([a-zA-Z\d_!-\-]+\.[a-zA-Z]+)\z/, 1] : nil
  end

  def timestamp_post(post)
    if /([\w\-_]+)\.[\w]+\z/ === post.memo.url
      filename = Regexp.last_match[1]
      if /(\d\d)(\d\d)(\d\d)(\d\d)-(\d\d)/ === filename
        match = Regexp.last_match
        return Time.zone.parse("20#{match[5]}-#{match[1]}-#{match[2]} #{match[3]}:#{match[4]}:00 +0900")
      elsif /(20)?(\d\d)(\d\d)(\d\d)[\-_]?[^\d]/ === filename
        match = Regexp.last_match
        return Time.zone.parse("20#{match[2]}-#{match[3]}-#{match[4]} 00:00:00 +0900")
      end
    end
    return nil
  end

  def of_current_user?(post)
    if logged_in?
      post.user_id == current_user.id
    else
      return false
    end
  end
  ###こいつら↑のテストやりたいっすね
  #ああああああああ

end
