compensator = FactoryBot.create(:egov_utils_user, lastname: 'Compensator', mail: 'compensator@example.com', roles: ['compensator'])
FactoryBot.create(:redemption, author: compensator)
