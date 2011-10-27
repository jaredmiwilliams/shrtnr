module TagsHelper
	@@TAG_SEPARATOR = ','

	# from 'v1,v2,v3' generate tag objects
	def buildTagList(tag_string)
		raw_tags = generateTags(tag_string)

		tags = []

		raw_tags.each { |raw_tag|
			#do lookup with normalized tags in an attempt to avoid duplicates
			tag = 
				(
					getNormalizedTag(raw_tag[1]) || 
					Tag.new(:tag_value => raw_tag[0], :tag_normalized => raw_tag[1])
				);

			tags << tag;          
		}
		tags
	end

	# from 'v1,v2,v3' generate tuples with raw and cleansed data
	def generateTags(tag_string)
		tags = []

		if tag_string
			raw_tags = tag_string.split(@@TAG_SEPARATOR)

			clean_tags = raw_tags.inject([]) { |res, tag|
				res << cleanTag(tag)
			}

			0.upto(raw_tags.length - 1) { |i|
				tags << [raw_tags[i].strip, clean_tags[i]]
			}
		end
		tags
	end

	# given a tag strip and cleanse it of non-word characters
	def cleanTag(tag)
		clean_tag = nil
		if tag
			clean_tag = tag.downcase.strip

			stripped_tag = clean_tag.gsub(/(?!\w)./, '')
			clean_tag = stripped_tag if not stripped_tag.nil?
		end
		clean_tag
	end
	
	def getNormalizedTag(normalized_text)
		results = Tag.find_all_by_tag_normalized(normalized_text)

		if results.empty?
			nil
		else
			results[0]
		end
	end
end