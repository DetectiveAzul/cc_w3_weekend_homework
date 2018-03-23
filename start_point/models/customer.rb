require_relative('./film')
require_relative('./ticket')
require_relative('../db/sql_runner')


class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i unless options['id'] == nil
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def self.all()
    sql = "SELECT * FROM customers;"
    customers = SqlRunner.run(sql)
    return customers.map { |customer| Customer.new(customer) }
  end

  def self.delete_all()
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM customers
    WHERE id = $1;"
    values = [id]
    customer_array = SqlRunner.run(sql, values)
    return Customer.new(customer_array.first) unless customer_array.first == nil
  end

  def save()
    sql = "INSERT INTO customers
    (name, funds)
    VALUES
    ($1, $2)
    RETURNING id
    ;"
    values = [@name, @funds]
    id_array = SqlRunner.run(sql, values)
    @id = id_array.first['id'].to_i
  end

  def update()
    sql = "UPDATE customers
    SET (name, funds) = ($1, $2)
    WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE from customers
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "
      SELECT * FROM films
      INNER JOIN tickets
      ON film_id = films.id
      INNER JOIN customers
      ON customer_id = customers.id
      WHERE customers.id = $1
    ;"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map { |film| Film.new(film) }
  end

  def tickets()
    sql = "
      SELECT * FROM tickets
      WHERE customer_id = $1
    ;"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    return tickets.map { |ticket| Ticket.new(ticket) }
  end

  def ticket_count()
    return self.tickets().count
  end

  def buy_ticket(film)
    film.sell_ticket(self) if @funds >= film.price
  end

end
