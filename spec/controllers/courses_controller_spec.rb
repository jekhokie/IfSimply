require 'spec_helper'

describe CoursesController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'show'" do
    let!(:club)   { user.clubs.first }
    let!(:course) { FactoryGirl.create :course, :club => club }

    describe "for a signed-in user" do
      describe "for the club owner" do
        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in user

          get 'show', :id => course.id
        end

        it "returns http redirect" do
          response.should be_redirect
        end

        it "redirects to the course title view" do
          response.should redirect_to(course_path(course))
        end

        it "returns the course" do
          assigns(:course).should_not be_nil
        end
      end

      describe "for a subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => club }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribed_user

          get 'show', :id => course.id
        end

        it "returns http redirect" do
          response.should be_redirect
        end

        it "redirects to the course title view" do
          response.should redirect_to(course_path(course))
        end

        it "returns the course" do
          assigns(:course).should_not be_nil
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show', :id => course.id
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(club))
        end

        it "returns the course" do
          assigns(:course).should_not be_nil
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show', :id => course.id
      end

      it "redirects to the sales page" do
        response.should redirect_to(club_sales_page_path(club))
      end

      it "returns the course" do
        assigns(:course).should_not be_nil
      end
    end
  end

  describe "POST 'create'" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user

      post 'create', :club_id => user.clubs.first.id
    end

    it "redirects to the edit view" do
      response.should redirect_to(course_editor_path(assigns(:course)))
    end

    it "returns the club" do
      assigns(:club).should_not be_nil
    end

    it "returns the course belonging to the club" do
      assigns(:course).should_not be_nil
      assigns(:course).club.should == assigns(:club)
    end

    it "assigns the default title" do
      assigns(:course).title.should == Settings.courses[:default_title]
    end

    it "assigns the default description" do
      assigns(:course).description.should == Settings.courses[:default_description]
    end
  end

  describe "GET 'edit'" do
    let(:course) { FactoryGirl.create :course, :club_id => user.clubs.first.id }

    describe "for a non signed-in user" do
      describe "for a course not belonging to user" do
        it "redirects for user sign in" do
          get 'edit', :id => FactoryGirl.create(:course).id

          response.should be_redirect
          response.should redirect_to new_user_session_path
        end
      end

      describe "for a course belonging to user" do
        it "redirects for user sign in" do
          get 'edit', :id => course

          response.should be_redirect
          response.should redirect_to new_user_session_path
        end
      end
    end

    describe "for a signed in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "for course not belonging to user" do
        before :each do
          get 'edit', :id => FactoryGirl.create(:course).id
        end

        it "returns 403 unauthorized forbidden code" do
          response.response_code.should == 403
        end

        it "renders the access_violation template" do
          response.should render_template('home/access_violation')
        end

        it "renders the application layout" do
          response.should render_template(:layout => "layouts/application")
        end
      end

      describe "for course belonging to user" do
        before :each do
          get 'edit', :id => course.id
        end

        it "returns http redirect" do
          response.should be_redirect
        end

        it "redirects to the course title view" do
          response.should redirect_to(course_editor_path(course.id))
        end

        it "returns the club" do
          assigns(:club).should == course.club
        end

        it "returns the course" do
          assigns(:course).should == course
        end

        it "renders the mercury layout" do
          response.should render_template(:layout => "layouts/mercury")
        end
      end
    end
  end

  describe "PUT 'update'" do
    let(:course)    { FactoryGirl.create :course, :club_id => user.clubs.first.id }
    let(:new_title) { "Test Course" }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:users]
      sign_in user
    end

    describe "for valid attributes" do
      before :each do
        put 'update', :id => course.id, :content => { :course_title       => { :value => new_title },
                                                      :course_description => { :value => "123" },
                                                      :course_logo        => { :attributes => { :src => "abc" } } }
      end

      it "returns http success" do
        response.should be_success
      end

      it "returns the course" do
        assigns(:course).should_not be_nil
      end

      it "assigns the new attributes" do
        course.reload
        course.title.should == new_title
      end
    end

    describe "for invalid attributes" do
      before :each do
        @old_title = course.title
        put 'update', :id => course.id, :content => { :course_title       => { :value => "" },
                                                      :course_description => { :value => "123" },
                                                      :course_logo        => { :attributes => { :src => "abc" } } }
      end

      it "returns http unprocessable" do
        response.response_code.should == 422
      end

      it "returns the course" do
        assigns(:course).should_not be_nil
      end

      it "does not update the attributes" do
        course.reload
        course.title.should == @old_title
      end
    end

    describe "for included lessons" do
      let(:lesson)           { FactoryGirl.create :lesson, :course => course }
      let(:new_lesson_title) { "Test Title" }

      before :each do
        FakeWeb.clean_registry
        FakeWeb.register_uri(:head, "http://vimeo.com/22977143", :body => "", :status => [ "200", "OK" ])
      end

      describe "for a lesson with valid attributes" do
        before :each do
          put 'update', :id => course.id, :content => { :course_title       => { :value => "Test Title" },
                                                        :course_description => { :value => "123" },
                                                        :course_logo        => { :attributes => { :src => "abc" } },
                                                        :"lesson_#{lesson.id}_title" => { :value => new_lesson_title } }
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the course" do
          assigns(:course).should_not be_nil
        end

        it "assigns the new attributes" do
          lesson.reload
          lesson.title.should == new_lesson_title
        end
      end

      describe "for a lesson with invalid attributes" do
        before :each do
          @old_lesson_title = lesson.title
          put 'update', :id => course.id, :content => { :course_title       => { :value => "" },
                                                        :course_description => { :value => "123" },
                                                        :course_logo        => { :attributes => { :src => "abc" } },
                                                        :"lesson_#{lesson.id}_title" => { :value => "" } }
        end

        it "returns http unprocessable" do
          response.response_code.should == 422
        end

        it "returns the course" do
          assigns(:course).should_not be_nil
        end

        it "does not update the attributes" do
          lesson.reload
          lesson.title.should == @old_lesson_title
        end
      end
    end
  end

  describe "GET 'show_all'" do
    let(:course) { FactoryGirl.create :course, :club => user.clubs.first }

    describe "for a signed-in user" do
      describe "for the club owner" do
        let!(:club_owner)   { FactoryGirl.create :user }
        let!(:owned_course) { FactoryGirl.create :course, :club => club_owner.clubs.first }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in club_owner

          get 'show_all', :club_id => owned_course.club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the course show_all view" do
          response.should render_template("courses/show_all")
        end

        it "assigns club" do
          assigns(:club).should == club_owner.clubs.first
        end

        it "assigns courses" do
          assigns(:courses).should include(owned_course)
        end
      end

      describe "for a subscriber" do
        let!(:subscribed_user) { FactoryGirl.create :user }
        let!(:subscription)    { FactoryGirl.create :subscription, :user => subscribed_user, :club => course.club }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in subscribed_user

          get 'show_all', :club_id => course.club.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the courses show_all view" do
          response.should render_template("courses/show_all")
        end

        it "assigns club" do
          assigns(:club).should == user.clubs.first
        end

        it "assigns courses" do
          assigns(:courses).should include(course)
        end
      end

      describe "for a non-subscriber" do
        let!(:non_subscribed_user) { FactoryGirl.create :user }

        before :each do
          @request.env["devise.mapping"] = Devise.mappings[:users]
          sign_in non_subscribed_user

          get 'show_all', :club_id => course.club.id
        end

        it "redirects to the sales page" do
          response.should redirect_to(club_sales_page_path(course.club))
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show_all', :club_id => course.club.id
      end

      it "redirects to the sales page" do
        response.should redirect_to(club_sales_page_path(course.club))
      end
    end
  end

  describe "POST 'sort'" do
    describe "for a signed in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "for a club owner" do
        let!(:club)    { user.clubs.first }
        let!(:course1) { FactoryGirl.create :course, :club_id => club.id, :position => 1 }
        let!(:course2) { FactoryGirl.create :course, :club_id => club.id, :position => 2 }
        let!(:course3) { FactoryGirl.create :course, :club_id => club.id, :position => 3 }

        describe "for valid attributes" do
          before :each do
            post 'sort', :format => :js, :club_id => club.id, :courses => [ 'course_2', 'course_3', 'course_1' ]
          end

          it "returns http success" do
            response.should be_success
          end

          it "returns the club" do
            assigns(:club).should == club
          end

          it "re-assigns the ordering requested" do
            course1.reload
            course2.reload
            course3.reload

            course1.position.should == 3
            course2.position.should == 1
            course3.position.should == 2
          end
        end

        describe "for invalid attributes" do
          before :each do
            post 'sort', :format => :js, :club_id => club.id, :blah => [ 'course_2', 'course_3', 'course_1' ]
          end

          it "returns http success" do
            response.should be_success
          end

          it "does not assign any new positions" do
            course1.reload
            course2.reload
            course3.reload

            course1.position.should == 1
            course2.position.should == 2
            course3.position.should == 3
          end
        end
      end

      describe "for a non-club owner" do
        let!(:club)    { FactoryGirl.create :club }
        let!(:course1) { FactoryGirl.create :course, :club_id => user.clubs.first.id, :position => 1 }
        let!(:course2) { FactoryGirl.create :course, :club_id => user.clubs.first.id, :position => 2 }
        let!(:course3) { FactoryGirl.create :course, :club_id => user.clubs.first.id, :position => 3 }

        describe "for valid attributes" do
          before :each do
            post 'sort', :format => :js, :club_id => club.id, :courses => [ 'course_2', 'course_3', 'course_1' ]
          end

          it "returns 403 unauthorized forbidden code" do
            response.response_code.should == 403
          end

          it "does not change the courses positioning" do
            course1.reload
            course2.reload
            course3.reload

            course1.position.should == 1
            course2.position.should == 2
            course3.position.should == 3
          end
        end
      end
    end

    describe "for a non-signed in user" do
      let!(:club)    { FactoryGirl.create :club }
      let!(:course1) { FactoryGirl.create :course, :club_id => club.id, :position => 1 }
      let!(:course2) { FactoryGirl.create :course, :club_id => club.id, :position => 2 }
      let!(:course3) { FactoryGirl.create :course, :club_id => club.id, :position => 3 }

      describe "for valid attributes" do
        before :each do
          post 'sort', :format => :js, :club_id => club.id, :courses => [ 'course_2', 'course_3', 'course_1' ]
        end

        it "returns 401 unauthorized code" do
          response.response_code.should == 401
        end

        it "does not change the courses positioning" do
          course1.reload
          course2.reload
          course3.reload

          course1.position.should == 1
          course2.position.should == 2
          course3.position.should == 3
        end
      end
    end
  end
end
