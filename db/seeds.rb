# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
    'Title',
    'Deed',
    'Bill of Sale',
    'Tax Related',
    'Mortgage',
    'Loan Application',
    'Closing Disclosure',
    'Insurance',
    'Other',
].each do |document_type|
  PropertyDocumentType.where(name: document_type).first_or_create
end


# Lease Frequencies
[
    'Monthly',
    'Daily',
    'Yearly',
].each do |frequency|
  LeaseFrequency.where(frequency: frequency).first_or_create
end

# Lease Types
[
    'Commercial',
    'Month to Month',
    'Roommate',
    'Standard Residential',
    'Sub-Lease',
].each { |type| LeaseType.where(name: type).first_or_create }
