Feature: Display a species page for a fish
  In order to find out new information about a species
  As a fish enthusiast
  I want to be able to see a species summary page for a fish species

  Scenario Outline: Go to a species page
    When I go to the species page for <species_id>
    Then I should see the common name "<common_name>"
    And I should see the size "<size>"
    And I should see the scientific name "<scientific_name>"

  Examples:
    |species_id|common_name|size|scientific_name|
    |1|pike|10m|icthy|
