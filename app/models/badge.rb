# class Badge
# def give_badge
# # gen badge
#   assert_url = HTTParty.post("http://playbadges.tsl.ac.uk/api",
#     :headers => { "recipient" => current_user.email, "evidence" => "http://www.example.org", "badgeId" => "1"},
#     :basic_auth => {:username => "martin.page@tsl.ac.uk", :password => "B0nF1rE"})
#  # redirect to receive badge
# end