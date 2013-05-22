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
  end
end
