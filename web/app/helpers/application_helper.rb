# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

def page_title
  (h(@content_for_title) + " &mdash; " if @content_for_title).to_s + 'GitHaven'
end

def page_heading(text)
  content_tag(:h1, content_for(:title){ text })
end

end
