class BirthdayTable
  
  attr_reader :table

  def initialize
    @table = {}
    @year = Date.today.year
  end

  def add(birthday, ctx)    
    key = date_to_key(birthday)
    @table[key] || (@table[key] = [])
    @table[key] << ctx
  end

  def find(from_date, to_date)
    from = date_to_key(from_date)
    to = date_to_key(to_date)
    list = {}
    @table.each do |key, val|
      current_year_day = (key >= from) && ((from < to && key <= to) || from > to)
      next_year_day = (from > to && key <= to)
      if(current_year_day || next_year_day) 
        date = key_to_date(key, @year + (next_year_day ? 1 : 0))
        list[date] = val
      end
    end    
    list
  end

  def date_to_key(date) 
    return date.month * 31 + date.day
  end

  def key_to_date(key, year)
    (month, day) = key.divmod(31)
    Date.new(year, month, day)
  end
  
end