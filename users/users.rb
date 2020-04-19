require "yaml"

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"


before do
  @users = YAML.load_file("users.yaml")
end

helpers do

  def count_interests
    total_interests = 0

    @users.each do |user, deets| 
      total_interests += deets[:interests].size      
    end
    p total_interests
    total_interests
  end

end

get "/" do
  redirect "/users"
end

get "/users" do
  erb :users
end

get "/users/:name" do
  name = params[:name].to_sym
  user = @users[name]
  
 @user_name = name.to_s
 @user_email = user[:email]
 @user_interests = user[:interests].join(", ")

 erb :user
end
