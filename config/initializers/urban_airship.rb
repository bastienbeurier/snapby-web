if Rails.env.development?
	Urbanairship.application_key = 'aXRfOGGkRrKQITn0D60pOw'
	Urbanairship.application_secret = '07LuCbkpTKyEaWuNoUBTqg'
	Urbanairship.master_secret = '0cxOSgKATBupI2yWxVERRw'
else 	
	Urbanairship.application_key = 'Ci9HFIAAQ1OoOxkFykDtzA'
	Urbanairship.application_secret = 'IR0pVUgaSb2W0xQ4jrgXUQ'
	Urbanairship.master_secret = 'jf003iDXQ-u3ECZ9ORmULg'
end
Urbanairship.logger = Rails.logger
Urbanairship.request_timeout = 5
