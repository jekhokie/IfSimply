FactoryGirl.define do
  factory :payment do
    payer_email        { Faker::Internet.email }
    payee_email        { Faker::Internet.email }
    pay_key            { Faker::Lorem.words(3).join("") }
    total_amount_cents { rand(9000) + 1000 }
    payee_share_cents  { ("%.2f" % (total_amount_cents.to_f * Settings.paypal[:club_owner_share])) }
    house_share_cents  { ("%.2f" % (total_amount_cents.to_f * Settings.paypal[:ifsimply_share])) }
  end
end
