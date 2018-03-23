class Ticket

  attr_reader :id
  attr_accessor :film_id, :customer_id

  def initialize(options)
    @id = options['id'].to_i unless options['id'] == nil
    @film_id = options['film_id'].to_i
    @customer_id = options['customer_id'].to_i
  end

end
