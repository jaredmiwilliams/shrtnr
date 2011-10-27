module TagsHelper
	@@TAG_SEPARATOR = ','

	def generateTags(tag_string)
		tags = []

		if tag_string
			raw_tags = tag_string.split(@@TAG_SEPARATOR)

			clean_tags = raw_tags.inject([]) { |res, tag|
				res << cleanTag(tag)
			}

			0.upto(raw_tags.length - 1) { |i|
				tags << [raw_tags[i], clean_tags[i]]
			}
		end
		tags
	end

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