module OneOffUploaders
#########################################################################
# These are one off methods I created to load things into the db through#
# console instead of trying to create a UI for it.                      #
#########################################################################
  def self.create_yearly_mortgage_payments!(property, year, amount)
    (1..12).each do |month|
      name = "#{month}-#{year} Mortgage Payment"
      cost = amount
      expense_date = DateTime.parse("#{year}-#{month}-01")

      ExpenseItem.new.tap do |item|
        item.name = name
        item.cost = cost
        item.expense_date = expense_date
        item.property = property
        item.save!
      end
    end
  end

  def self.create_yearly_hoa_payments!(property,  year, amount)
    (1..12).each do |month|
      name = "#{month}-#{year} HOA Payment"
      cost = amount
      expense_date = DateTime.parse("#{year}-#{month}-01")

      ExpenseItem.new.tap do |item|
        item.name = name
        item.cost = cost
        item.expense_date = expense_date
        item.property = property
        item.save!
      end
    end
  end
end