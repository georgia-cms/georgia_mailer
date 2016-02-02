# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require "georgia/mailer/version"

Gem::Specification.new do |s|
  s.name        = "georgia_mailer"
  s.version     = Georgia::Mailer::VERSION
  s.authors     = ["Mathieu Gagné"]
  s.email       = ["gagne.mathieu@hotmail.com"]
  s.homepage    = "http://www.georgiacms.org"
  s.summary     = "Handles Georgia Messages, SPAM, contact forms, etc."
  s.description = "Georgia::Mailer works essentially with Georgia CMS to provide spam-free contact forms, email notifications, Sendgrid integration, and so on."
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "georgia", '~> 0.8'
  s.add_dependency "rakismet", '~> 1.5'
  s.add_dependency 'sucker_punch', '~> 1.6'

end
