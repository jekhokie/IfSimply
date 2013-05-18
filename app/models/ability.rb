class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :update, Club, :user_id => user.id
  end
end
