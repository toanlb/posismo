Given /^the following admins:$/ do |admins|
  Admin.create!(admins.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) admin$/ do |pos|
  visit admins_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following admins:$/ do |expected_admins_table|
  expected_admins_table.diff!(tableish('table tr', 'td,th'))
end
