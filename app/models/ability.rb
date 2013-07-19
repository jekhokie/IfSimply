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
      club.user == user or club.members.include?(user)
    end

    can :read, Blog do |blog|
      membership = user.subscriptions.find_by_club_id blog.club.id
      blog.club.user == user or (!membership.blank? and (blog.free or membership.level.to_s != "basic"))
    end

    can :read, Course do |course|
      course.club.user == user or course.club.members.include?(user)
    end

    can :read, Lesson do |lesson|
      membership = user.subscriptions.find_by_club_id lesson.club.id
      lesson.club.user == user or (!membership.blank? and (lesson.free or membership.level.to_s != "basic"))
    end

    can :read, DiscussionBoard do |discussion_board|
      discussion_board.club.user == user or discussion_board.club.members.include?(user)
    end

    can :read, Topic do |topic|
      topic.club.user == user or topic.club.members.include?(user)
    end

    # global defaults
    can [ :read ], SalesPage
  end
end
