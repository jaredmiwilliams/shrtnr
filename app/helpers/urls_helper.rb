require 'digest/md5'

module UrlsHelper

	#length of hash we want to create
	@@HASH_LENGTH = 6
	#max times to hash string before giving up
	@@MAX_HASH_ITERATIONS = 10
	#2^23, arbitrarily large number
	@@MAX_RAND = 4294967296
	#also arbitrary, for hash randomization
	@@TIME_DIVISOR = 107

	#return two hash values for url..
	# [0] = for forwarding
	# [1] = for editing
	def hashUrlValues(url)
		#append time stamp divided by random number to avoid collisions
		url += (Time.now.to_i / rand(@@TIME_DIVISOR)).to_s

		hashed_url, hashed_edit_url = url, url.reverse

		doHash(hashed_url) { |hash|
			if Url.find_all_by_hashed_url(hash).empty?
				hashed_url = hash
				break;
			end
		}

		doHash(hashed_url) { |hash|
			if Url.find_all_by_hashed_edit_url(hash).empty?
				hashed_edit_url = hash
				break;
			end
		}

		# if unique hash not found try again
		if(hashed_url == url or hashed_edit_url == url)
			hashUrl(url)
		else
			[hashed_url, hashed_edit_url]
		end
	end

	#compute hash based on instructions in args
	# or if nothing provided a random integer
	def doHash(*args)
		max_iterations = @@MAX_HASH_ITERATIONS
		hash_length = @@HASH_LENGTH
		hash = nil

		if args.length > 0
			hash = args[0]

			if args.length > 1
				if args[1].is_a Hash
					params = args[1]
					max_iterations = params[:max_iterations] if params[:max_iterations]
					hash_lenght = params[:hash_length] if params[:hash_length]
				end
			end
		else
			hash = rand(@@MAX_RAND)
		end
		
		#hash until provided block aborts or we hit max_iterations
		0.upto(max_iterations) { |i|
			hash = Digest::MD5.hexdigest(hash)
			
			shortened = hash[0..(hash_length-1)]

			yield shortened
		}
	end

	#very simple address matcher, would need much more work for better matching
	def formatUrl(url)
		if url.match(/(?:^\w+\:\/\/)?(?:\w+\.)?\w+\.\w+.*$/)
			if not url.match(/^\w+\:\/\//)
				url = "http://#{url}"
			end
			url
		else
			nil
		end
	end
end




