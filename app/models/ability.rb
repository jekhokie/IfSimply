class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :update, Club, :user_id => user.id

    can [ :create, :edit, :update ], Course do |course|
      course.user == user
    end

    can [ :create, :update ], Lesson do |lesson|
      lesson.user == user
    end
  end
end
