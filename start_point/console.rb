require('pry')
require_relative('./models/customer')
require_relative('./models/film')
require_relative('./models/ticket')
require_relative('./models/screening')

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

screening01 = Screening.new({ 'time_slot' => '12:00', 'film_id' => film01.id,
  'stock' => 10 })
screening02 = Screening.new({ 'time_slot' => '14:30', 'film_id' => film02.id,
  'stock' => 12 })
screening03 = Screening.new({ 'time_slot' => '17:00', 'film_id' => film01.id,
  'stock' => 14 })
screening04 = Screening.new({ 'time_slot' => '19:30', 'film_id' => film02.id,
  'stock' => 8  })

screening01.save()
screening02.save()
screening03.save()
screening04.save()

ticket01 = Ticket.new({ 'film_id' => film01.id,
  'customer_id' => customer01.id,
  'screening_id' => screening01.id
})
ticket02 = Ticket.new({ 'film_id' => film02.id,
  'customer_id' => customer01.id,
  'screening_id' => screening02.id
})
ticket03 = Ticket.new({ 'film_id' => film02.id,
  'customer_id' => customer02.id,
  'screening_id' => screening02.id
})
ticket04 = Ticket.new({ 'film_id' => film02.id,
  'customer_id' => customer02.id,
  'screening_id' => screening04.id
})

ticket01.save()
ticket02.save()
ticket03.save()
10.times { ticket04.save() }


binding.pry
nil
