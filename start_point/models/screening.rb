class Screening
  attr_reader :id
  attr_accessor :time_slot, :film_id
  def initialize(options)
    @id = options['id'].to_i unless options['id'] == nil
    @time_slot = options['time_slot']
    @film_id = options['film_id']
  end

  def self.all()
    sql = "SELECT * FROM screenings;"
    screenings = SqlRunner.run(sql)
    return screenings.map { |screening| Screening.new(screening) }
  end

  def self.delete_all()
    sql = "DELETE FROM screenings;"
    SqlRunner.run(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM screenings
    WHERE id = $1;"
    values = [id]
    screening_array = SqlRunner.run(sql, values)
    return Screening.new(screening_array.first) unless screening_array.first == nil
  end

  def save()
    sql = "INSERT INTO screenings
    (time_slot, film_id)
    VALUES
    ($1, $2)
    RETURNING id
    ;"
    values = [@time_slot, @film_id]
    id_array = SqlRunner.run(sql, values)
    @id = id_array.first['id'].to_i
  end

  def update()
    sql = "UPDATE screenings
    SET (time_slot, film_id) = ($1, $2)
    WHERE id = $3"
    values = [@time_slot, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE from screenings
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end
end
