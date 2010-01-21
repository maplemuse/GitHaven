atom_feed do |feed|
  feed.title "#{@repository.user.username}/#{@repository.name} commits"
  return if !@commits
  feed.updated @commits.first.date if @commits.first
  for commit in @commits
    feed.entry(commit, :url => "commit/" + commit.sha) do |entry|
      entry.title commit.message.split('\n').first
      entry.updated(commit.date)
      entry.content(commit.to_patch, :type =>  'text')
      entry.summary(commit.message)
      entry.author do |author|
        entry.name commit.author
        entry.email commit.author
      end
    end
  end
end
