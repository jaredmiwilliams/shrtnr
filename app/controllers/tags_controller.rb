class TagsController < ApplicationController
 	include ApplicationHelper

	def get
		format = getFormat(params)

		results = Tag.find_by_sql("select * from tags where tag_normalized like '%#{params[:tag]}%'")

		tags = results.inject([]) {|res, tag| res << {:tag_value => tag.tag_value, :tag_normalized => tag.tag_normalized, :id => tag.id}}

		if format == 'html'
			#render 
		else 
			render format.to_sym => tags
		end
	end
end
