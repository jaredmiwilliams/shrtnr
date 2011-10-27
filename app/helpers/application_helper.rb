# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	@@accepted_formats = ['html', 'json']

	def getFormat(params)
		format = 'html'
		if params
			if params[:format] and @@accepted_formats.include?(params[:format])
				format = params[:format]
			end
		end
		format
	end

	def getDomain(request)
		request.protocol + (request.port == 80 ? request.host : request.host_with_port)
	end
end
