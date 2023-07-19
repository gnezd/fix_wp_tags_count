# Explore wp database structure and fix tag/category count issue
require 'pry'
require 'mysql2'

conn = {}
(File.open('./mysql_cred', 'r') {|f| f.readlines.map{|ln| ln.chomp}}).each do |line|
  conn[line.split('=')[0]] = line.split('=')[1]
end

client = Mysql2::Client.new(host: conn['host'], username: conn['user'], password: conn['password'], database:conn['database'])

prefix = 'wp_blog_'
tables = client.query("show tables").to_a
taxonomies = client.query("select * from #{prefix}term_taxonomy").to_a
terms = client.query("select * from #{prefix}terms").to_a
relationships = client.query("select * from #{prefix}term_relationships").to_a
termmeta = client.query("select * from #{prefix}termmeta").to_a
posts = client.query("select * from #{prefix}posts").to_a

count = Hash.new {0}
relationships.each do |rela|
  count[rela['term_taxonomy_id']] += 1
end

count.each do |term|
  #puts "Term name: #{terms[term]}"
end

binding.pry