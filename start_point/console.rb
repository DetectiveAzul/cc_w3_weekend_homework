require('pry')
require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')

Ticket.delete_all()
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

ticket01 = Ticket.new({ 'film_id' => film01.id, 'customer_id' => customer01.id })
ticket02 = Ticket.new({ 'film_id' => film02.id, 'customer_id' => customer01.id })
ticket03 = Ticket.new({ 'film_id' => film02.id, 'customer_id' => customer02.id })

ticket01.save()
ticket02.save()
ticket03.save()

binding.pry
nil
