source "http://rubygems.org"

gem "mongo"

git 'git://github.com/yuya-takeyama/markovchain.git' do
  gem "markovchain", "~> 0.1.0"
end

group :development do
  gem "rspec", "~> 2.8.0"
  gem "guard-rspec"
  platform :ruby do
    gem "rb-readline"
  end
  gem "yard", "~> 0.7"
  gem "rdoc", "~> 3.12"
  gem "bundler", "~> 1.1.0"
  gem "jeweler", "~> 1.8.3"
  gem "simplecov", ">= 0"
  gem "bson_ext"
end
