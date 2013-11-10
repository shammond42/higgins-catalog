Question.all.each do |q|
  puts "#{q.is_spam?} : #{q.spam?} : #{q.question}"
end