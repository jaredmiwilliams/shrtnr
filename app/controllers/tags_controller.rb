class TagsController < ApplicationController
 	include ApplicationHelper
 	include TagsHelper

 	#mapped from <domain>/t/<tag>
 	# used for auto suggest
	def get
		format = getFormat(params)

		query_text ="
select * from tags 
where tag_normalized like '#{cleanTag(params[:tag])}%'"

		results = Tag.find_by_sql(query_text)

		tags = results.inject([]) {|res, tag|
			res << 
				{
					:tag_value => tag.tag_value, 
					:tag_normalized => tag.tag_normalized, 
					:id => tag.id}
				}

		render format.to_sym => tags
	end

	#mapped from <domain>/tag/<tag>
	def index
		format = getFormat(params)

		# join tags, urls and tags_urls table looking for relations
		query_text = "
select tags.id as t_id,tag_value,tag_normalized,original_url,hashed_url,count
from tags 
inner join tags_urls on tags.id = tags_urls.tag_id 
inner join urls on urls.id = tags_urls.url_id 
where tag_normalized='#{cleanTag(params[:tag])}'"

		query = Tag.find_by_sql(query_text)

		tag = params[:tag];
	
		related = query.inject([]) {|res, data|
			tag = data.tag_value
			res << 
				{
					:url => data.original_url, 
					:hash => "#{getDomain(request)}/#{data.hashed_url}"}
				}
		@results = {:related=> related, :tag => tag}

		if format == 'html'
			render # index.html.erb
		else 
			render format.to_sym => @results
		end
	end
end
