require 'grape'

class HelloAPI < Grape::API
  format :json
  get '/' do
    # paramsでパラメータを取得
    id = headers['Test']
    return {'hello': 'world', account_id: id}
  end

  post '/' do
    body = env['api.request.body'] # -d データとして何かを送った物が格納される
    return body
  end

  get 'users/:user_id' do
    id = params[:user_id]
    return {user_id_params: id}
  end

  put '/' do
    status 405
    return { message: 'not support' }
  end
end
