require 'spec_helper'
require 'cancan'
require 'cancan/matchers'
require_relative '../../app/models/ability.rb'

describe Ability do
  let(:user)    { FactoryGirl.create :user }
  let(:ability) { Ability.new user }

  describe "Club" do
    let(:owned_club)     { FactoryGirl.create :club, :user_id => user.id }
    let(:non_owned_club) { FactoryGirl.create :club }

    context "update" do
      it "succeeds when the user owns the club" do
        ability.should be_able_to(:update, owned_club)
      end

      it "fails when the user does not own the club" do
        ability.should_not be_able_to(:update, non_owned_club)
      end
    end

    context "read" do
      let!(:subscribed_user)        { FactoryGirl.create :user }
      let!(:non_subscribed_user)    { FactoryGirl.create :user }
      let!(:subscription)           { FactoryGirl.create :subscription, :user => subscribed_user, :club => non_owned_club }
      let!(:owner_ability)          { Ability.new owned_club.user }
      let!(:subscribed_ability)     { Ability.new subscribed_user }
      let!(:non_subscribed_ability) { Ability.new non_subscribed_user }

      it "succeeds for the club owner" do
        owner_ability.should be_able_to(:read, owned_club)
      end

      it "succeeds for a subscribed user" do
        subscribed_ability.should be_able_to(:read, non_owned_club)
      end

      it "fails for a non-subscribed user" do
        non_subscribed_ability.should_not be_able_to(:read, non_owned_club)
      end
    end
  end

  describe "Course" do
    let(:club)             { FactoryGirl.create :club, :user_id => user.id }
    let(:owned_course)     { FactoryGirl.create :course, :club_id => club.id }
    let(:non_owned_course) { FactoryGirl.create :course }

    context "create" do
      it "succeeds when the user owns the corresponding club" do
        ability.should be_able_to(:create, owned_course)
      end

      it "fails when the user does not own the corresponding club" do
        ability.should_not be_able_to(:create, non_owned_course)
      end
    end

    context "edit" do
      it "succeeds when the user owns the corresponding club" do
        ability.should be_able_to(:edit, owned_course)
      end

      it "fails when the user does not own the corresponding club" do
        ability.should_not be_able_to(:edit, non_owned_course)
      end
    end

    context "update" do
      it "succeeds when the user owns the corresponding club" do
        ability.should be_able_to(:update, owned_course)
      end

      it "fails when the user does not own the corresponding club" do
        ability.should_not be_able_to(:update, non_owned_course)
      end
    end

    context "read" do
      let(:club) { FactoryGirl.create :club }

      describe "for a subscribed user" do
        let!(:course)        { FactoryGirl.create :course, :club => club }
        let!(:owner_ability) { Ability.new club.user }

        it "succeeds for the club owner" do
          owner_ability.should be_able_to(:read, course)
        end

        describe "for a pro member" do
          let!(:pro_user)         { FactoryGirl.create :user }
          let!(:pro_subscription) { FactoryGirl.create :subscription, :user => pro_user, :club => club, :level => :pro }
          let!(:pro_ability)      { Ability.new pro_user }

          it "succeeds" do
            pro_ability.should be_able_to(:read, course)
          end
        end

        describe "for a basic member" do
          let!(:basic_user)         { FactoryGirl.create :user }
          let!(:basic_subscription) { FactoryGirl.create :subscription, :user => basic_user, :club => club, :level => :basic }
          let!(:basic_ability)      { Ability.new basic_user }

          it "succeeds" do
            basic_ability.should be_able_to(:read, course)
          end
        end
      end

      describe "for a non-subscribed user" do
        let!(:course)  { FactoryGirl.create :course }
        let!(:user)    { FactoryGirl.create :user }
        let!(:ability) { Ability.new user }

        it "fails" do
          ability.should_not be_able_to(:read, course)
        end
      end
    end
  end

  describe "Lesson" do
    let(:club)             { FactoryGirl.create :club, :user_id => user.id }
    let(:course)           { FactoryGirl.create :course, :club_id => club.id }
    let(:owned_lesson)     { FactoryGirl.create :lesson, :course_id => course.id }
    let(:non_owned_lesson) { FactoryGirl.create :course }

    context "create" do
      it "succeeds when the user owns the corresponding club" do
        ability.should be_able_to(:create, owned_lesson)
      end

      it "fails when the user does not own the corresponding club" do
        ability.should_not be_able_to(:create, non_owned_lesson)
      end
    end

    context "update" do
      it "succeeds when the user owns the corresponding club" do
        ability.should be_able_to(:update, owned_lesson)
      end

      it "fails when the user does not own the corresponding club" do
        ability.should_not be_able_to(:update, non_owned_lesson)
      end
    end

    context "read" do
      let(:club)   { FactoryGirl.create :club }
      let(:course) { FactoryGirl.create :course, :club => club }

      describe "for a subscribed user" do
        let!(:free_lesson)   { FactoryGirl.create :lesson, :course => course, :free => 'true' }
        let!(:paid_lesson)   { FactoryGirl.create :lesson, :course => course, :free => 'false' }
        let!(:owner_ability) { Ability.new club.user }

        it "succeeds for the club owner" do
          owner_ability.should be_able_to(:read, paid_lesson)
        end

        describe "for a pro member" do
          let!(:pro_user)         { FactoryGirl.create :user }
          let!(:pro_subscription) { FactoryGirl.create :subscription, :user => pro_user, :club => club, :level => :pro }
          let!(:pro_ability)      { Ability.new pro_user }

          it "succeeds for a free lesson" do
            pro_ability.should be_able_to(:read, free_lesson)
          end

          it "succeeds for a paid lesson" do
            pro_ability.should be_able_to(:read, paid_lesson)
          end
        end

        describe "for a basic member" do
          let!(:basic_user)         { FactoryGirl.create :user }
          let!(:basic_subscription) { FactoryGirl.create :subscription, :user => basic_user, :club => club, :level => :basic }
          let!(:basic_ability)      { Ability.new basic_user }

          it "succeeds for a free lesson" do
            basic_ability.should be_able_to(:read, free_lesson)
          end

          it "fails for a paid lesson" do
            basic_ability.should_not be_able_to(:read, paid_lesson)
          end
        end
      end

      describe "for a non-subscribed user" do
        let!(:lesson)  { FactoryGirl.create :lesson }
        let!(:user)    { FactoryGirl.create :user }
        let!(:ability) { Ability.new user }

        it "fails" do
          ability.should_not be_able_to(:read, lesson)
        end
      end
    end
 end

  describe "Blog" do
    let(:club)           { FactoryGirl.create :club, :user_id => user.id }
    let(:owned_blog)     { FactoryGirl.create :blog, :club_id => club.id }
    let(:non_owned_blog) { FactoryGirl.create :blog }

    context "create" do
      it "succeeds when the user owns the corresponding club" do
        ability.should be_able_to(:create, owned_blog)
      end

      it "fails when the user does not own the corresponding club" do
        ability.should_not be_able_to(:create, non_owned_blog)
      end
    end

    context "edit" do
      it "succeeds when the user owns the corresponding club" do
        ability.should be_able_to(:edit, owned_blog)
      end

      it "fails when the user does not own the corresponding club" do
        ability.should_not be_able_to(:edit, non_owned_blog)
      end
    end

    context "update" do
      it "succeeds when the user owns the club" do
        ability.should be_able_to(:update, owned_blog)
      end

      it "fails when the user does not own the club" do
        ability.should_not be_able_to(:update, non_owned_blog)
      end
    end

    context "read" do
      let(:club) { FactoryGirl.create :club }

      describe "for a subscribed user" do
        let!(:free_blog)     { FactoryGirl.create :blog, :club => club, :free => 'true' }
        let!(:paid_blog)     { FactoryGirl.create :blog, :club => club, :free => 'false' }
        let!(:owner_ability) { Ability.new club.user }

        it "succeeds for the club owner" do
          owner_ability.should be_able_to(:read, paid_blog)
        end

        describe "for a pro member" do
          let!(:pro_user)         { FactoryGirl.create :user }
          let!(:pro_subscription) { FactoryGirl.create :subscription, :user => pro_user, :club => club, :level => :pro }
          let!(:pro_ability)      { Ability.new pro_user }

          it "succeeds for a free blog" do
            pro_ability.should be_able_to(:read, free_blog)
          end

          it "succeeds for a paid blog" do
            pro_ability.should be_able_to(:read, paid_blog)
          end
        end

        describe "for a basic member" do
          let!(:basic_user)         { FactoryGirl.create :user }
          let!(:basic_subscription) { FactoryGirl.create :subscription, :user => basic_user, :club => club, :level => :basic }
          let!(:basic_ability)      { Ability.new basic_user }

          it "succeeds for a free blog" do
            basic_ability.should be_able_to(:read, free_blog)
          end

          it "fails for a paid blog" do
            basic_ability.should_not be_able_to(:read, paid_blog)
          end
        end
      end

      describe "for a non-subscribed user" do
        let!(:blog)    { FactoryGirl.create :blog }
        let!(:user)    { FactoryGirl.create :user }
        let!(:ability) { Ability.new user }

        it "fails" do
          ability.should_not be_able_to(:read, blog)
        end
      end
    end
  end

  describe "DiscussionBoard" do
    let(:club)                       { FactoryGirl.create :club, :user_id => user.id }
    let(:owned_discussion_board)     { club.discussion_board }
    let(:non_owned_discussion_board) { FactoryGirl.create :discussion_board }

    context "edit" do
      it "succeeds when the user owns the corresponding club" do
        ability.should be_able_to(:edit, owned_discussion_board)
      end

      it "fails when the user does not own the corresponding club" do
        ability.should_not be_able_to(:edit, non_owned_discussion_board)
      end
    end

    context "update" do
      it "succeeds when the user owns the club" do
        ability.should be_able_to(:update, owned_discussion_board)
      end

      it "fails when the user does not own the club" do
        ability.should_not be_able_to(:update, non_owned_discussion_board)
      end
    end
  end

  describe "Topic" do
    let(:discussion_board) { FactoryGirl.create :discussion_board, :club_id => user.clubs.first.id }
    let(:owned_topic)      { FactoryGirl.create :topic, :discussion_board_id => discussion_board.id }
    let(:non_owned_topic)  { FactoryGirl.create :topic }

    context "read" do
      let(:ability) { Ability.new FactoryGirl.create(:user) }

      it "succeeds for any user" do
        ability.should be_able_to(:read, non_owned_topic)
      end
    end

    context "update" do
      it "succeeds when the user owns the topic" do
        ability.should be_able_to(:update, owned_topic)
      end

      it "fails when the user does not own the topic" do
        ability.should_not be_able_to(:update, non_owned_topic)
      end
    end
  end

  describe "SalesPage" do
    let(:owned_sales_page)     { FactoryGirl.create :sales_page, :club_id => user.clubs.first.id }
    let(:non_owned_sales_page) { FactoryGirl.create :sales_page }

    context "read" do
      let(:ability) { Ability.new FactoryGirl.create(:user) }

      it "succeeds for any user" do
        ability.should be_able_to(:read, non_owned_sales_page)
      end
    end

    context "update" do
      it "succeeds when the user owns the sales_page" do
        ability.should be_able_to(:update, owned_sales_page)
      end

      it "fails when the user does not own the sales_page" do
        ability.should_not be_able_to(:update, non_owned_sales_page)
      end
    end
  end
end
