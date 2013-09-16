if Rails.env.development?
	Urbanairship.application_key = 'NePQiDkcSHWFDyhmEzGgWA'
	Urbanairship.application_secret = 'ynGtrru1S_m-BVEo_9T9FQ'
	Urbanairship.master_secret = '1XQd8jYOQWKX5n5KrVoxPw'
else 	
	Urbanairship.application_key = 'AzqCIDWGSqmEOJvM95Vfqw'
	Urbanairship.application_secret = '_YOtj7i6RyeelX_BE9AohQ'
	Urbanairship.master_secret = 'Jv4zxUycQC2ASS--Ea-1Fg'
end
Urbanairship.logger = Rails.logger
Urbanairship.request_timeout = 5
