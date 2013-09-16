if Rails.env.development?
	Urbanairship.application_key = 'd-rOeAKNRGKn9gsFgi18ew'
	Urbanairship.application_secret = 'EDtx_9xdQOqNvOQDKQJw2w'
	Urbanairship.master_secret = '52CbajzGRY6cFBLE54tdmA'
else 	
	Urbanairship.application_key = 'AzqCIDWGSqmEOJvM95Vfqw'
	Urbanairship.application_secret = '_YOtj7i6RyeelX_BE9AohQ'
	Urbanairship.master_secret = 'Jv4zxUycQC2ASS--Ea-1Fg'
end
Urbanairship.logger = Rails.logger
Urbanairship.request_timeout = 5
