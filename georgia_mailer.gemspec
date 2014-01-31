$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "georgia_mailer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "georgia_mailer"
  s.version     = GeorgiaMailer::VERSION
  s.authors     = ["Mathieu Gagné"]
  s.email       = ["mathieu@motioneleven.com"]
  s.homepage    = "http://www.motioneleven.com/"
  s.summary     = "Handles Georgia Messages, SPAM, contact forms, etc."
  s.description = "GeorgiaMailer works essentially with Georgia CMS to provide spam-free contact forms, email notifications, Sendgrid integration, and so on."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 3.2.6"
  s.add_dependency "georgia"
  s.add_dependency "sendgrid"
  s.add_dependency "rakismet"
  s.add_dependency 'sidekiq'

end
