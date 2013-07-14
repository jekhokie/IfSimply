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

    # membership-specific capabilities
    can :read, Club do |club|
      club.members.include?(user)
    end

    can :read, Blog do |blog|
      membership = user.subscriptions.find_by_club_id blog.club.id
      ! membership.blank? && (blog.free || membership.level.to_s != "basic")
    end

    # global defaults
    can [ :read ], Topic
    can [ :read ], SalesPage
  end
end
