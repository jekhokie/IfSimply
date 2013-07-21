require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'edit'" do
    describe "for a signed-in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "accessing their own account" do
        before :each do
          get 'edit', :id => user.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the users edit view" do
          response.should render_template("users/edit")
        end

        it "assigns user" do
          assigns(:user).should == user
        end
      end

      describe "accessing another user's account" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          get 'edit', :id => other_user.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the users edit view" do
          response.should render_template("users/edit")
        end

        it "assigns user as their own account" do
          assigns(:user).should == user
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'edit', :id => user.id
      end

      it "redirects to the sign-in page" do
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT 'update'" do
    let(:new_description) { "Test Course" }

    describe "for a signed-in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "updating their own attributes" do
        describe "for valid attributes" do
          before :each do
            put 'update', :id => user.id, :user => { :description => new_description }
          end

          it "returns http success" do
            response.should be_success
          end

          it "returns the user" do
            assigns(:user).should_not be_nil
          end

          it "assigns the new attributes" do
            user.reload
            user.description.should == new_description
          end
        end

        describe "for invalid attributes" do
          before :each do
            @request.env["devise.mapping"] = Devise.mappings[:users]
            sign_in user

            @old_description = user.description
            put 'update', :id => user.id, :user => { :description => "" }
          end

          it "returns http unprocessable" do
            response.response_code.should == 422
          end

          it "returns the user" do
            assigns(:user).should_not be_nil
          end

          it "does not update the attributes" do
            user.reload
            user.description.should == @old_description
          end
        end
      end

      describe "updating another user's attributes" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          put 'update', :id => other_user.id, :user => { :description => "Test" }
        end

        it "returns http unprocessable" do
          response.response_code.should == 204
        end

        it "assigns user as their own account" do
          assigns(:user).should == user
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        put 'update', :id => user.id, :user => { :description => "Test" }
      end

      it "redirects to the sign-in page" do
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET 'change_icon'" do
    describe "for a signed-in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "editing their own icon" do
        before :each do
          get 'change_icon', :id => user.id, :format => :js
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the user" do
          assigns(:user).should == user
        end
      end

      describe "updating another user's icon" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          get 'change_icon', :id => other_user.id, :format => :js
        end

        it "returns http unprocessable" do
          response.should be_success
        end

        it "assigns user as their own account" do
          assigns(:user).should == user
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'change_icon', :id => user.id, :format => :js
      end

      it "redirects to the sign-in page" do
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT 'upload_icon'" do
    let(:valid_icon)   { fixture_file_upload('/soccer_ball.jpg', 'image/jpeg') }
    let(:invalid_icon) { fixture_file_upload('/soccer_ball.txt', 'text/plain') }

    describe "for a signed-in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "updating their own icon" do
        describe "for a valid icon format" do
          before :each do
            put 'upload_icon', :id => user.id, :user => { :icon => valid_icon }, :format => :js
          end

          it "returns http success" do
            response.should be_success
          end

          it "renders the upload_icon template" do
            response.should render_template('users/upload_icon')
          end

          it "returns the user" do
            assigns(:user).should == user
          end

          it "assigns the user icon" do
            File.basename(assigns(:user).icon.to_s.sub(/\?.*/, '')).should == valid_icon.original_filename
          end
        end

        describe "for an invalid icon format" do
          before :each do
            put 'upload_icon', :id => user.id, :user => { :icon => invalid_icon }, :format => :js
          end

          it "returns http success" do
            response.should be_success
          end

          it "renders change_icon" do
            response.should render_template("users/change_icon")
          end

          it "returns the user" do
            assigns(:user).should == user
          end

          it "does not assign the user icon" do
            File.basename(assigns(:user).icon.to_s.sub(/\?.*/, '')).should_not == valid_icon.original_filename
          end
        end

        describe "for a non-specified icon value" do
          before :each do
            put 'upload_icon', :id => user.id, :format => :js
          end

          it "returns http success" do
            response.should be_success
          end

          it "renders change_icon" do
            response.should render_template("users/change_icon")
          end

          it "returns the user" do
            assigns(:user).should == user
          end

          it "does not assign the user icon" do
            File.basename(assigns(:user).icon.to_s.sub(/\?.*/, '')).should_not == valid_icon.original_filename
          end
        end
      end

      describe "uploading an icon for another user" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          put 'upload_icon', :id => other_user.id, :user => { :icon => invalid_icon }, :format => :js
        end

        it "returns http unprocessable" do
          response.should be_success
        end

        it "assigns user as their own account" do
          assigns(:user).should == user
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        put 'upload_icon', :id => user.id, :format => :js
      end

      it "redirects to the sign-in page" do
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end
