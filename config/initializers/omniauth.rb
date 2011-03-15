require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '0bSz3URebktk4tC5MInbw', '5NjsAmAFhNlJHjYM6OllhJunEsVYmT1c9KDJzzKW8'
  
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'wf', :domain => 'wf.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'jpn', :domain => 'jpn.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'bll', :domain => 'bll.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'in', :domain => 'in.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'kn', :domain => 'kn.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'hsr', :domain => 'hsr.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'ft', :domain => 'ft.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'kor', :domain => 'kor.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'jn', :domain => 'jn.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'ne', :domain => 'ne.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'rmv', :domain => 'rmv.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'dmb', :domain => 'dmb.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'aun', :domain => 'aun.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'ecil', :domain => 'ecil.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'mlm', :domain => 'mlm.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'vij', :domain => 'vij.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'vjn', :domain => 'vjn.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'rrn', :domain => 'rrn.justbooksclc.com'

  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'skn', :domain => 'skn.justbooksclc.com'
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'wnr', :domain => 'wnr.justbooksclc.com'
  
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :name => 'strata', :domain => 'strata.co.in'
  
end