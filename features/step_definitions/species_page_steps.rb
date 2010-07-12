Then /I should see the common name "([^\"]+)"/ do |common_name|
  response.should contain(common_name)
end

