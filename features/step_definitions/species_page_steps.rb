Then /I should see the common name "([^\"]+)"/ do |common_name|
  page.should have_content(common_name)
end

Then /I should see the size "([^\"]+)"/ do |size|
  page.should have_content(size)
end

Then /I should see the scientific name "([^\"]+)"/ do |sci_name|
  page.should have_content(sci_name)
end

