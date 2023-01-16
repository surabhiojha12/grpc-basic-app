this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(File.dirname(this_dir), 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'user_services_pb'

module User
  class UserServer < User::Service

    ALL_USERS = [
      { first_name: 'Surabhi', last_name: 'Ojha', email: 'some_email1@some_email.com', phone_number: '23231232321' },
      { first_name: 'Xavier', last_name: 'Samuel', email: 'some_email2@some_email.com', phone_number: '45231232321' },
      { first_name: 'Ravi', last_name: 'Nath', email: 'some_email3@some_email.com', phone_number: '67231232321' },
      { first_name: 'Aditya', last_name: 'Chopra', email: 'some_email4@some_email.com', phone_number: '89231232321' },
      { first_name: 'Charu', last_name: 'R', email: 'some_email5@some_email.com', phone_number: '76231232321' },
      { first_name: 'Yuva', last_name: 'Reshma', email: 'some_email6@some_email.com', phone_number: '13231232321' },
      { first_name: 'Zeba', last_name: 'V', email: 'some_email7@some_email.com', phone_number: '32231232321' }
    ].freeze

    def user_information(user_request, _call)
      user_id = user_request.id - 1
      fetched_user = ALL_USERS[user_id]
      UserResponse.new(first_name: fetched_user[:first_name] || '',
                       last_name: fetched_user[:last_name] || '',
                       email: fetched_user[:email] || '',
                       phone_number: fetched_user[:phone_number] || '',
                       id: user_request.id)
    end
  end
end

def main
  port = '0.0.0.0:50051'
  s = GRPC::RpcServer.new
  s.add_http2_port(port, :this_port_is_insecure)
  GRPC.logger.info("... running insecurely on #{port}")
  s.handle(User::UserServer.new)
  # Runs the server with SIGHUP, SIGINT and SIGTERM signal handlers to
  #   gracefully shutdown.
  # User could also choose to run server via call to run_till_terminated
  s.run_till_terminated_or_interrupted([1, 'int', 'SIGTERM'])
end

main
