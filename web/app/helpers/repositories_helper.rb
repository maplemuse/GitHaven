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
end
