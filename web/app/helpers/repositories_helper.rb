module RepositoriesHelper
  def link_to_path(path, name)
    link = "<a href=\"\/";
    link += h(@repository.user.username) + '/';
    link += h(@repository.name) + '/tree/' + h(@branch) + '/';
    link += (h(path) + '/') if !path.empty?
    link += h(name)
    link += "\">" + h(name) + "</a>"
    link
  end

  def link_to_user(user)
    link_to h(user.username), :controller => 'users', :action => 'show', :user => user.username
  end

  def link_to_repository(repository)
    link_to h(repository.name), :controller => 'repositories', :action => 'show', :repo => repository.name, :user => repository.user.username
  end

end
