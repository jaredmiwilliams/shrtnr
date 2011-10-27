ActionController::Routing::Routes.draw do |map|
  map.connect '/c.:format', :controller=>'urls', :action=>'create'
  map.connect '/e/s.:format', :controller=>'urls', :action=>'edit_save'
  map.connect '/e/:hash', :controller=>'urls', :action=>'edit'
  map.connect '/t/:tag.:format', :controller=>'tags', :action=>'get'
  map.connect '/tag/:tag.:format', :controller=>'tags', :action=>'index'
  map.connect '/tag/:tag', :controller=>'tags', :action=>'index'
  map.connect '/:hash.:format', :controller=>'urls', :action=>'forward'
  map.connect '/:hash', :controller=>'urls', :action=>'forward', :requirements => {:hash => /.+/}
end
