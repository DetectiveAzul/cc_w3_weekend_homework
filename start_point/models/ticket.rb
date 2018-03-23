class Ticket

  attr_reader :id
  attr_accessor :film_id, :customer_id

  def initialize(options)
    @id = options['id'].to_i unless options['id'] == nil
    @film_id = options['film_id'].to_i
    @customer_id = options['customer_id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM tickets;"
    tickets = SqlRunner.run(sql)
    return tickets.map { |ticket| Ticket.new(ticket) }
  end

  def self.delete_all()
    sql = "DELETE FROM tickets;"
    SqlRunner.run(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM tickets
    WHERE id = $1;"
    values = [id]
    ticket_array = SqlRunner.run(sql, values)
    return Ticket.new(ticket_array.first) unless ticket_array.first == nil
  end

  def save()
    sql = "INSERT INTO tickets
    (film_id, customer_id)
    VALUES
    ($1, $2)
    RETURNING id
    ;"
    values = [@film_id, @customer_id]
    id_array = SqlRunner.run(sql, values)
    @id = id_array.first['id'].to_i
  end

  def update()
    sql = "UPDATE tickets
    SET (film_id, customer_id) = ($1, $2)
    WHERE id = $3"
    values = [@film_id, @customer_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE from tickets
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

end
