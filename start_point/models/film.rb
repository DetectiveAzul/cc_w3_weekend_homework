require_relative('./customer')
require_relative('./ticket')
require_relative('./screening')
require_relative('../db/sql_runner')

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i unless options['id'] == nil
    @title = options['title']
    @price = options['price'].to_i
  end

  def self.all()
    sql = "SELECT * FROM films;"
    films = SqlRunner.run(sql)
    return films.map { |film| Film.new(film) }
  end

  def self.delete_all()
    sql = "DELETE FROM films;"
    SqlRunner.run(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM films
    WHERE id = $1;"
    values = [id]
    film_array = SqlRunner.run(sql, values)
    return Film.new(film_array.first) unless film_array.first == nil
  end

  def save()
    sql = "INSERT INTO films
    (title, price)
    VALUES
    ($1, $2)
    RETURNING id
    ;"
    values = [@title, @price]
    id_array = SqlRunner.run(sql, values)
    @id = id_array.first['id'].to_i
  end

  def update()
    sql = "UPDATE films
    SET (title, price) = ($1, $2)
    WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "
      SELECT * FROM customers
      INNER JOIN tickets
      ON customer_id = customers.id
      INNER JOIN films
      ON film_id = films.id
      WHERE films.id = $1
    ;"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map { |customer| Customer.new(customer) }
  end

  def customer_count()
    return self.customers().count
  end

  def tickets()
    sql = "
      SELECT * FROM tickets
      WHERE film_id = $1
    ;"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    return tickets.map { |ticket| Ticket.new(ticket) }
  end

  #To be fixed
  def sell_ticket(customer, screening)
    if screening.ticket_left > 0
      customer.funds -= @price
      Ticket.new({ 'film_id' => @id,
        'customer_id' => customer.id ,
        'screening_id' => screening.id
      }).save()
      customer.update()
    end
  end

  def ticket_count()
    return self.tickets().count
  end

  def screenings()
    sql = "
      SELECT * FROM screenings
      WHERE film_id = $1
    ;"
    values = [@id]
    screenings = SqlRunner.run(sql, values)
    return screenings.map { |screening| Screening.new(screening) }
  end

  def most_popular_screening()
    screening_array = self.screenings()
    most_popular_screening = screening_array.first
    screening_array.each do |screening|
      most_popular_screening = screening if screening.ticket_count() > most_popular_screening.ticket_count()
      end
    return most_popular_screening
  end
end
