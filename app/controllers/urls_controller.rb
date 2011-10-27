class UrlsController < ApplicationController
  include ApplicationHelper
  include UrlsHelper
  include TagsHelper
  
  #mapped from to <domain>/<hash>
  #if hash is found will forward to appropriate url
  def forward
    format = getFormat(params)

    @hash = params[:hash]

    results = Url.find_all_by_hashed_url(@hash)

    @result = nil
    if not results.empty?
      #populate result if found
      @result = results[0]
      @result.count = @result.count + 1
      @result.save()

      @result = {
        :url => @result.original_url, 
        :short_url => "#{getDomain(request)}/#{@result.hashed_url}", 
        :hit_count => @result.count}
    else
      #create error otherwise
      @result = {
        :error => 'no url associated with #{request.url}', 
        :url => request.url
      }
    end

    if format == 'html'
      if @result[:error]
        render # index.html.erb
      else
        redirect_to @result[:url]
      end
    else
      render format.to_sym => @result
    end
  end

  #mapped from <domain>/c/?url=<url>&tags=<tags>
  def create
    format = getFormat(params)

    @url = formatUrl(params[:url])

    ret = nil

    if @url
      #get hash values for url
      hashed_url_values = hashUrlValues(@url)
      @hashed_url, @hashed_edit_url = hashed_url_values[0], hashed_url_values[1]

      @created_by = request.remote_ip

      #format tags
      @tags = buildTagList(params[:tags])

      url = Url.new(:original_url => @url,
                    :hashed_url => @hashed_url,
                    :hashed_edit_url => @hashed_edit_url,
                    :created_by => @created_by,
                    :count => 0)
      url.tags = @tags    

      url.save()

      ret = {
        :url => @url, 
        :short_url => "#{getDomain(request)}/#{@hashed_url}", 
        :edit_url => "#{getDomain(request)}/e/#{@hashed_edit_url}",
        :tags => @tags
      }
    else
      ret = {
        :error => "The url provided (#{params[:url]}) doesn't appear to be valid.", 
        :url => params[:url]
      }
    end

    render format.to_sym => ret
  end

  #mapped from <domain>/e/<hash>
  def edit
    @hash = params[:hash]

    results = Url.find_all_by_hashed_edit_url(@hash)

    @result = nil
    @url = nil
    if not results.empty?
      @result = results[0]

      @short_url = "#{getDomain(request)}/#{@result.hashed_url}"
    end

    render # index.html.erb
  end

  # mapped from <domain>/e/s.:format
  def edit_save
    format = getFormat(params)

    id = params[:id]
    tags = buildTagList(params[:tags])

    url = Url.find(id)

    ret = nil
    if url
      #tags all only value with potential to be modified
      url.tags = tags

      url.save()
      ret = {
        :url => url.original_url, 
        :short_url => "#{getDomain(request)}/#{url.hashed_url}", 
        :edit_url => "#{getDomain(request)}/e/#{url.hashed_edit_url}",
        :tags => tags
      }
    else
      ret = {
        :error => "The url provided (#{params[:url]}) doesn't appear to be valid.", 
        :url => params[:url]
      }
    end

    render format.to_sym => ret
  end
end
