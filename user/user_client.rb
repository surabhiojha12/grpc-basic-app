this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(File.dirname(this_dir), 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'user_services_pb'

module User
  class UserClient
    USER_REQUEST_DATA = [
      UserRequest.new(id: 1),
      UserRequest.new(id: 2),
      UserRequest.new(id: 3),
      UserRequest.new(id: 4),
      UserRequest.new(id: 5),
      UserRequest.new(id: 6),
      UserRequest.new(id: 7)
    ].freeze

    def run_user_information(stub)
      p 'UserInformation'
      p '----------'
      USER_REQUEST_DATA.each do |user|
        resp = stub.user_information(user)
        if resp.id != ''
          p "id: #{resp.id}"
          p "first_name: #{resp.first_name}"
          p "last_name: #{resp.last_name}"
          p "phone_number: #{resp.phone_number}"
          p "email: #{resp.email}"
        else
          p "- found nothing at #{user.inspect}"
        end
        p '----------'
      end
    end
  end
end

def main
  stub = User::User::Stub.new('localhost:50051', :this_channel_is_insecure)
  User::UserClient.new.run_user_information(stub)
end

main
