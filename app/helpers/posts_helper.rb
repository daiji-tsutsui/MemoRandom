module PostsHelper

  def name_post(post)
    if /.+\.html/ =~ post.memo.url
      Rails.env.production? ? (url = post.memo.url) : (url = "public/" + post.memo.url)
      File.open(url) do |input|
        content = input.read
        title = content[/<h1.*>(.+)<\/h1>/u, 1]
        title.blank? ? "no_name" : title
      end
    else
      return "no_name"
    end
  end

  def original_filename(url)
    url.instance_of?(String) ? url[/\/([a-zA-Z\d_!-\-]+\.[a-zA-Z]+)$/, 1] : nil
  end

  def of_current_user?(post)
    if logged_in?
      post.user_id == current_user.id
    else
      return false
    end
  end
  ###こいつら↑のテストやりたいっすね

end
