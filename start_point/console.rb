require('pry')
require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')

Film.delete_all()
Customer.delete_all()

customer01 = Customer.new({ 'name' => 'Pawel', 'funds' => 45 })
customer02 = Customer.new({ 'name' => 'Sian', 'funds' => 55 })

film01 = Film.new({ 'title' => 'Star Wars', 'price' => 6 })
film02 = Film.new({ 'title' => 'Ready Player One', 'price' => 8 })

customer01.save()
customer02.save()
film01.save()
film02.save()

binding.pry
nil
