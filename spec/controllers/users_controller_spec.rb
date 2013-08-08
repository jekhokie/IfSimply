require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create :user }

  describe "GET 'show'" do
    describe "for a signed-in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "viewing their own profile" do
        before :each do
          get 'show', :id => user.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the user show view" do
          response.should render_template("users/show")
        end

        it "returns the user" do
          assigns(:user).should_not be_nil
        end
      end

      describe "viewing a different user's profile" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          get 'show', :id => other_user.id
        end

        it "returns http success" do
          response.should be_success
        end

        it "renders the user show view" do
          response.should render_template("users/show")
        end

        it "returns the user" do
          assigns(:user).should_not be_nil
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'show', :id => user.id
      end

      it "returns redirect to sign in" do
        response.should redirect_to(new_user_session_path)
      end
    end
  end

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

        it "assigns user" do
          assigns(:user).should == user
        end

        it "renders the mercury layout" do
          response.should render_template(:layout => "layouts/mercury")
        end
      end

      describe "accessing another user's account" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          get 'edit', :id => other_user.id
        end

        it "returns http forbidden" do
          response.response_code.should == 403
        end

        it "renders the access violation view" do
          response.should render_template("home/access_violation")
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
            put 'update', :id => user.id, :content => { :user_icon        => { :attributes => { :src => "abc" } },
                                                        :user_description => { :value => new_description } }
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
            @old_description = user.description
            put 'update', :id => user.id, :content => { :user_icon        => { :attributes => { :src => "abc" } },
                                                        :user_description => { :value => "" } }
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
          put 'update', :id => other_user.id, :content => { :user_icon        => { :attributes => { :src => "abc" } },
                                                            :user_description => { :value => "123" } }
        end

        it "returns http forbidden" do
          response.response_code.should == 403
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        put 'update', :id => user.id, :content => { :user_icon        => { :attributes => { :src => "abc" } },
                                                    :user_description => { :value => "123" } }
      end

      it "redirects to the sign-in page" do
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end