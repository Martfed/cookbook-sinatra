require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "csv"
set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  @recipes = []
  #csv_file = File.join(__dir__, '/views/recipes.csv')
  #raise
  csv_options = { col_sep: ',', quote_char: '"' }
  CSV.foreach("./views/recipes.csv", csv_options) do |row|
    @recipes << row
  end
  erb :index
end

get "/new" do
  erb :new
end

post "/new" do
  csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
  CSV.open("./views/recipes.csv", 'ab', csv_options) do |csv|
    csv << [params[:description], params[:name], params[:prep_time]]
  end
  redirect "/", 302
end
