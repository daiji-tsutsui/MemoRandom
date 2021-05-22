# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

60.times do |i|
  Post.create(name: "dummy#{i}", memo: open("#{Rails.root}/app/assets/images/dummy.pdf"), user_id: 1)
end
