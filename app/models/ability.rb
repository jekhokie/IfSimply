class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :update, Club,   :user_id => user.id
    can :create, Course, :club_id => user.clubs.first.id # TODO: Figure out how to restrict to course_id in user.clubs.map(&:id)
  end
end
