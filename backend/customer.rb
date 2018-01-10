class Customer
  attr_reader :email, :memberships, :bonus

  def initialize(email:)
    @email = email
    @memberships = []
    @bonus = 0
  end

  def add_membership(membership)
    @memberships << membership
  end

  def add_bonus(bonus_value)
    @bonus += bonus_value
  end
end
