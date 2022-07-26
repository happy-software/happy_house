# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
  "Title",
  "Deed",
  "Bill of Sale",
  "Tax Related",
  "Mortgage",
  "Loan Application",
  "Closing Disclosure",
  "Insurance",
  "Other"
].each do |document_type|
  PropertyDocumentType.where(name: document_type).first_or_create
end

# Lease Frequencies
%w[
  Monthly
  Daily
  Yearly
].each do |frequency|
  LeaseFrequency.where(frequency: frequency).first_or_create
end

[
  {name: "Happy User", email: "user@happysoftware.dev", password_digest: "$2a$12$9flOWQYOUEaQjwElT6eayeUegdkm9vMhDUEl1N.mAxFGCYVZ/ngY.", activated: true, activated_at: Date.parse("2022-01-01") }
].each do |user_attributes|
  puts "Generating user with these attributes: #{user_attributes}"
  user = User.where(user_attributes).first_or_create
  [
    { address: {street_address: "123 Happy St.", city: "Smiles City", state: "Joyfulness", zip_code: "12345"}, nickname: "Happy House #1", property_type: "Townhome", zpid: nil, user_id: user.id}
  ].each do |property_attributes|
    puts "Generating property with these attributes: #{property_attributes}"
    p = Property.where(property_attributes).first_or_create!
  end
  puts "User count in database: #{User.count}"
  puts "Property count in database: #{Property.count}"
end
