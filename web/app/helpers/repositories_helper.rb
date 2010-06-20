#
#   Copyright (C) 2010 Benjamin C. Meyer <ben@meyerhome.net>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

module RepositoriesHelper
  def link_to_path(path, name)
    link = "<a href=\"\/";
    link += h(@repository.user.username) + '/';
    link += h(@repository.name) + '/tree/' + h(@branch) + '/';
    link += h(path) if !path.empty?
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

  def print_date(date)
    return String(Date::MONTHNAMES[date.mon]) + " " + String(date.mday) + ", " + String(date.year)
  end

  def print_short_commit_message(message, length = 50)
    if (length < 0 || message.length < length)
        message
    else
        message.slice(0, length) + "..."
    end
  end
end
