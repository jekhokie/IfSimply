class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :update, Club, :user_id => user.id

    can :read, Club do |club|
      club.members.include?(user)
    end

    can [ :create, :edit, :update ], Course do |course|
      course.user == user
    end

    can [ :create, :update ], Lesson do |lesson|
      lesson.user == user
    end

    can [ :create, :edit, :update ], Blog do |blog|
      blog.user == user
    end

    can [ :edit, :update ], DiscussionBoard do |discussion_board|
      discussion_board.user == user
    end

    can [ :update ], Topic do |topic|
      topic.user == user
    end

    can [ :update ], SalesPage do |sales_page|
      sales_page.user == user
    end

    # global defaults
    can [ :read ], Topic
    can [ :read ], SalesPage
  end
end
