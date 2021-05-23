module PostsHelper

  def name_post(post)
    if /.+\.html/ =~ post.memo.url
      File.open("public/" + post.memo.url) do |input|
        content = input.read
        title = content[/<h1.*>(.+)<\/h1>/u, 1]
        title.blank? ? "no_name" : title
      end
    else
      return "no_name"
    end
  end

  def of_current_user?(post)
    if logged_in?
      post.user_id == current_user.id
    else
      return false
    end
  end

end
