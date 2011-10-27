class UrlsController < ApplicationController
  include ApplicationHelper
  include UrlsHelper
  include TagsHelper
  
  #mapped from to <domain>/<hash>
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
      if result[:error]
        //TODO html
      else
        redirect_to @result[:url]
      end
    else
      render format.to_sym => @result
    end
  end

  #mapped from <domain>/<hash>/info
  def info
    @hash = params[:hash]

    results = Url.find_all_by_hashed_url(@hash)

    @result = {}
    if not results.empty?
       @result = {
         :url => @result.original_url, 
         :short_url => "#{getDomain(request)}/#{@result.hashed_url}", 
         :hit_count => @result.count
       }
    else
      @result = {
        :error => 'no url associated with #{request.url}'
        :url => request.url
      }
    end

    if format == 'html'
      //TODO html
    else
      render format.to_sym => @result
    end
  end

  #mapped from <domain>/c/?url=<url>&tags=<tags>
  # or <domain>/c/<url>/<tags> (chunks should be url encoded)
  def create
    format = getFormat(params)

    @url = formatUrl(params[:url])

    ret = nil

    if @url
      #get hash values for url
      hashed_url_values = hashUrlValues(@url)
      @hashed_url, @hashed_edit_url = hashed_url_values[0], hashed_url_values[1]

      @created_by = request.remote_ip

      tag_string = params[:tags]
      raw_tags = generateTags(tag_string)

      @tags = []
      raw_tags.each { |raw_tag|
        #do lookup with normalized tags in an attempt to avoid duplicates
        @tags <<
          (
            getNormalizedTag(raw_tag[1]) || 
              Tag.new(:tag_value => raw_tag[0], :tag_normalized => raw_tag[1])
          )
      }

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
        :edit_url => "#{getDomain(request)}/e/#{@hashed_edit_url}"
      }
    else
      ret = {
        :error => "url provided doesn't appear to be valid", 
        :url => params[:url]
      }
    end

    if format == 'html'
      //TODO html
    else
      render format.to_sym => ret
    end
  end

  def edit
    @hash = params[:hash]

    results = Url.find_all_by_hashed_edit_url(@hash)

    render :json => [@hash]    
  end


end
