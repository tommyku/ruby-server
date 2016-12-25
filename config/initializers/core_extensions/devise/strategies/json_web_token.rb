module Devise
  module Strategies
    class JsonWebToken < Base
      def valid?
        request.headers['Authorization'].present?
      end

      def authenticate!
        return fail unless claims
        return fail unless claims.has_key?('user_uuid')
        success! User.find_by_uuid claims['user_uuid']
      end

      protected

      def claims
        strategy, token = request.headers['Authorization'].split(' ')
        return nil if (strategy || '').downcase != 'bearer'
        JWTWrapper.decode(token) rescue nil
      end
    end
  end
end
