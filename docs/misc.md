### rails c command to refresh all paperclip models:
`ActiveRecord::Base.descendants.select { |d| !d.name.match(/HABTM|::/) && defined? d.attachment_definitions }.each { |k| k.all.each { |i| i.image.reprocess! } }`
