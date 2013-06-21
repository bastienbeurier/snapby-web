if Rails.env.development?
	Urbanairship.application_key = '4dVNPZ-KR0yehG6rnwnLjw'
	Urbanairship.application_secret = 'mePbq7qaSLmJs23fsL546g'
	Urbanairship.master_secret = 'HBpafLkNSo65nTwsgrMNNg'
else 	
	Urbanairship.application_key = 'AzqCIDWGSqmEOJvM95Vfqw'
	Urbanairship.application_secret = '_YOtj7i6RyeelX_BE9AohQ'
	Urbanairship.master_secret = 'Jv4zxUycQC2ASS--Ea-1Fg'
end
Urbanairship.logger = Rails.logger
Urbanairship.request_timeout = 5
