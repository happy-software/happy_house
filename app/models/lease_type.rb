class LeaseType < ApplicationRecord
  # Description copied from: https://rentalleaseagreements.com/#By-Type
  #
  # Five (5) Types of Lease Agreements
  #   Commercial Lease Agreement:
  #     For any type of commercial space for traditional business use such as industrial,
  #     office, or retail. There are two (2) types of agreements:
  #                                                                                                                                                                  Gross Lease – Tenant only pays one fixed rental amount per month. Landlord pays most or all of the expenses related to the property.
  #     Modified Gross Lease:
  #       Landlord and tenant share the expenses related to the property.
  #     Triple Net (NNN) Lease:
  #       The tenant pays a fixed rental amount each month and assumes the majority of the expenses related to the
  #       property including but not limited to:
  #         - real estate taxes,
  #         - Common Area Maintenance (CAM’s), and
  #         - Insurance for the property (prorated share if not occupying entire premises).
  #
  #   Month-to-Month Rental Agreement:
  #     Otherwise known as “Tenancy at Will”, is a type of real estate contract that renews every month upon
  #     payment by the tenant. There is no end date but either the landlord or tenant may decide to alter or terminate
  #     the agreement with at least one (1) month’s written notice.
  #
  #   Roommate Lease:
  #     A roommate agreement is when more than one (1) person live together in a residence while sharing the common
  #     areas such as the kitchen, bathroom(s), and living areas. The agreement can be constructed in two (2) ways:
  #
  #       Amongst the Roommates only:
  #         An agreement between the roommates that establishes quiet times, cleanup schedules, and any other items to
  #         establish a happy living atmosphere.
  #       Amongst the Roommate(s) and the Landlord:
  #         An agreement between the roommates and the landlord that allows the roommate(s) to live with the landlord
  #         and rent a room and share common areas.
  #
  #   Standard Residential Lease Agreement:
  #     A fixed term arrangement between a landlord and tenant whereas payment is due every month, usually on the
  #     first (1st) day, and the term is commonly for one (1) year.
  #
  #   Sub-Lease Agreement:
  #     Where a tenant or “sublessor” who currently is under a lease decides to rent a portion or the entire space to
  #     someone else known as the “sublessee”. The sublessor is responsible for the sublessee to: Vacate the premises,
  #     Any damage created by the sublessee, and Payment (If the sublessee does not pay, the landlord remains to be
  #     owed the amount states in the master lease agreement).
  has_many :leases
end
