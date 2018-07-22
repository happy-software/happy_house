module UsersHelper

  def gravatar_for(user)
    email = user.email.downcase
    gravatar_id  = Digest::MD5::hexdigest(email)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
