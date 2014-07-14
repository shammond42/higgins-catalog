# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create({
  name: 'Test Admin',
  email: 'test_admin@example.com',
  title: 'Test admin',
  password: 'test_admin',
  password_confirmation: 'test_admin'
  }).update_attribute(:receives_question_notifications, false)
