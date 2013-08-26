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

  describe "GET 'specify_paypal'" do
    describe "for a signed-in user" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
        sign_in user
      end

      describe "viewing their own account" do
        before :each do
          get 'specify_paypal', :format => :js, :id => user.id
        end

        it "returns http success" do
          response.should be_success
        end
      end

      describe "viewing a different user's account" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          get 'specify_paypal', :format => :js, :id => other_user.id
        end

        it "returns 403 unauthorized forbidden code" do
          response.response_code.should == 403
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        get 'specify_paypal', :format => :js, :id => user.id
      end

      it "renders the sign in view" do
        response.should render_template("devise/sessions/new")
      end
    end
  end

  describe "PUT 'verify_email'" do
    describe "for a signed-in user" do
      let(:payment_email) { "test@test.com" }

      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:users]
      end

      describe "specifying their PayPal email address" do
        let(:verified_user) { FactoryGirl.create :verified_user, :payment_email => payment_email }

        describe "for valid attributes" do
          before :each do
            PaypalProcessor.should_receive(:is_verified?).with(payment_email).and_return true

            sign_in verified_user

            put 'verify_paypal', :format => :js, :id => verified_user.id, :payment_email => payment_email
          end

          it "returns http success" do
            response.should be_success
          end

          it "returns the user" do
            assigns(:user).should_not be_nil
          end

          it "assigns the new attributes" do
            verified_user.reload
            verified_user.payment_email.should == payment_email
            verified_user.verified.should      == true
          end
        end

        describe "for invalid attributes" do
          let(:other_user) { FactoryGirl.create :verified_user, :payment_email => payment_email }

          before :each do
            sign_in other_user

            put 'verify_paypal', :format => :js, :id => other_user.id, :payment_email => ""
          end

          it "returns the user" do
            assigns(:user).should_not be_nil
          end

          it "returns an error" do
            flash[:error].should_not be_blank
          end

          it "does not update the attributes" do
            other_user.reload
            other_user.payment_email.should == payment_email
          end
        end

        describe "for an unverified PayPal email address" do
          let(:other_user) { FactoryGirl.create :verified_user, :payment_email => payment_email }

          before :each do
            PaypalProcessor.should_receive(:is_verified?).with(payment_email).and_return false

            sign_in other_user

            put 'verify_paypal', :format => :js, :id => other_user.id, :payment_email => payment_email
          end

          it "returns the user" do
            assigns(:user).should_not be_nil
          end

          it "returns an error" do
            flash[:error].should_not be_blank
          end

          it "does not update the attributes" do
            other_user.reload
            other_user.payment_email.should == payment_email
          end
        end
      end

      describe "updating another user's attributes" do
        let!(:other_user) { FactoryGirl.create :user }

        before :each do
          sign_in user
          put 'verify_paypal', :format => :js, :id => other_user.id, :payment_email => "test@test.com"
        end

        it "returns http forbidden" do
          response.response_code.should == 403
        end
      end
    end

    describe "for a non signed-in user" do
      before :each do
        put 'verify_paypal', :format => :js, :id => user.id, :payment_email => "test@test.com"
      end

      it "renders the sign in view" do
        response.should render_template("devise/sessions/new")
      end
    end
  end
end
