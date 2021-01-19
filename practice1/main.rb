require 'grape'

class Main < Grape::API
  format :json

  alice = { id: 1, name: 'alice', age: 20 }
  bob = { id: 2, name: 'bob', age: 25 }
  users = [alice, bob]

  get '/users' do
    name = '' # 空文字列だとinclude?で全て通る
    name = params[:name] if params[:name].present?
    status 200
    return users.select{ |user| user[:name].include? name }
  end

  get '/users/:user_id' do
    id = params[:user_id]
    user = users.find{ |user| user[:id] == id.to_i }
    if user.present?
      status 200
      return user
    else
      status 404
      return { message: "Not Found User: #{id}" }
    end
  end

  post '/users' do
    body = env['api.request.body'].symbolize_keys
    if body[:name].present? && body[:age].present?
      body[:id] = users.map{ |user| user[:id] }.max + 1
      users << body
      status 201
      return body
    else
      status 400
      return { message: "'name' and 'age' must be required" }
    end
  end

  patch '/users/:user_id' do
    body = env['api.request.body'].symbolize_keys
    id = params[:user_id]
    user = users.find{ |user| user[:id] == id.to_i}

    if user.nil?
      status 404
      return { message: "Not Found User: #{id}" }
    end

    user[:name] = body[:name] if body[:name].present?
    user[:age] = body[:age] if body[:age].present?
    status 200
    return user
  end

  put '/users/:user_id' do
    id = params[:user_id]
    body = env['api.request.body'].symbolize_keys
    user = users.find{ |user| user[:id] == id.to_i }

    if user.nil?
      status 404
      return { message: "Not Found User: #{id}" }
    end

    if body[:name].nil? || body[:age].nil?
      status 400
      return { message: "'name' and 'age' must be required" }
    end

    user[:name] = body[:name]
    user[:age] = body[:age]
    status 200
    return user
  end

  delete '/users/:user_id' do
    id = params[:user_id]
    user = users.find{ |user| user[:id] == id.to_i }

    if user.nil?
      status 404
      return { message: "Not Found User: #{id}" }
    end

    users.reject!{ |user| user[:id] == id.to_i }

    status 204
    return { message: "Delete User" }
  end
end