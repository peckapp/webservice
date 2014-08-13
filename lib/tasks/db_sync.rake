namespace :db do
  desc "TODO"
  task sync_local: :environment do
    tables = %(resource_types scrape_resources data_resources selectors)
    puts ARGV.count
  end

  desc "TODO"
  task sync_remote: :environment do

  end

  desc 'Dump given table into a YAML file'
  task :dump_table, [:table_name] => :environment do |t, args|
    table_name = args[:table_name] # ARGV.count > 1 ? ARGV[1] : nil
    (puts 'table name must be given'; next;) if table_name.blank?
    model = table_name.classify.constantize

    path = Rails.root.join("tmp/#{table_name}.yml")

    # FileUtils.touch(path)
    File.open(path, 'w') do |file|
      items = model.all
      # pass the file handle as the second parameter to dump
      YAML::dump(items, file)
    end
    puts "table '#{table_name}' dumped into tmp directory"
  end

  desc 'Load given YAML file into models'
  task :load_table, [:table_name] => :environment do |t, args|
    table_name = args[:table_name] # ARGV.count > 1 ? ARGV[1] : nil
    (puts 'table name must be given'; next;) if table_name.blank?
    model = table_name.classify.constantize

    path = Rails.root.join("tmp/#{table_name}.yml")
    next unless exist?(path)

    items = YAML.load_file(path)

    items.each do |i|
      puts item.inspect
      i.non_duplicative_save

    end
  end

end
