# frozen_string_literal: true

module Rack
  class Attack # rubocop:disable Style/Documentation
    ### Configure Cache ###

    # If you don't want to use Rails.cache (Rack::Attack's default), then
    # configure it here.
    #
    # Note: The store is only used for throttling (not blocklisting and
    # safelisting). It must implement .increment and .write like
    # ActiveSupport::Cache::Store

    # Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    ### Throttle Spammy Clients ###

    # If any single client IP is making tons of requests, then they're
    # probably malicious or a poorly-configured scraper. Either way, they
    # don't deserve to hog all of the app server's CPU. Cut them off!
    #
    # Note: If you're serving assets through rack, those requests may be
    # counted by rack-attack and this throttle may be activated too
    # quickly. If so, enable the condition to exclude them from tracking.

    # Throttle all requests by IP (60rpm)
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
    # throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    #   req.ip # unless req.path.start_with?('/assets')
    # end

    ### Prevent Brute-Force Login Attacks ###

    # The most common brute-force login attack is a brute-force password
    # attack where an attacker simply tries a large number of emails and
    # passwords to see if any credentials match.
    #
    # Another common method of attack is to use a swarm of computers with
    # different IPs to try brute-forcing a password for a specific account.

    # Throttle POST requests to /login by IP address
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
    throttle('users/confirmation', limit: 5, period: 20.seconds) do |req|
      req.ip if req.path == '/users/confirmation' && req.post?
    end

    throttle('users/sign_in', limit: 5, period: 20.seconds) do |req|
      req.ip if req.path == '/users/sign_in' && req.post?
    end

    # Membership lookups by name + birthdate can be enumerated by walking
    # birthdates, so limit how fast any one client can query them.
    throttle('api/member_status/minute', limit: 10, period: 1.minute) do |req|
      req.ip if req.path == '/api/member_status' && req.post?
    end

    throttle('api/member_status/hour', limit: 100, period: 1.hour) do |req|
      req.ip if req.path == '/api/member_status' && req.post?
    end

    # Count lookups per name, whatever the client IP or birthdate, so a scan
    # across birthdays for one name is capped. Normalise the name the same way
    # MemberFinder matches it (ignore case and accents).
    throttle('api/member_status/name', limit: 20, period: 1.hour) do |req|
      next unless req.path == '/api/member_status' && req.post?

      first = ActiveSupport::Inflector.transliterate(req.params['first_name'].to_s.strip).downcase
      last = ActiveSupport::Inflector.transliterate(req.params['last_name'].to_s.strip).downcase
      "#{first}|#{last}" if first.present? && last.present?
    end

    # Throttle POST requests to /login by email param
    #
    # Key: "rack::attack:#{Time.now.to_i/:period}:logins/email:#{normalized_email}"
    #
    # Note: This creates a problem where a malicious user could intentionally
    # throttle logins for another user and force their login requests to be
    # denied, but that's not very common and shouldn't happen to you. (Knock
    # on wood!)
    # throttle('logins/email', limit: 5, period: 20.seconds) do |req|
    #   if req.path == '/login' && req.post?
    #     # Normalize the email, using the same logic as your authentication process, to
    #     # protect against rate limit bypasses. Return the normalized email if present, nil otherwise.
    #     req.params['email'].to_s.downcase.gsub(/\s+/, "").presence
    #   end
    # end

    # Devise password reset: each request makes the app send an email, so limit
    # by IP and by target address (so many IPs can't flood one inbox).
    throttle('users/password/ip', limit: 5, period: 20.seconds) do |req|
      req.ip if req.path == '/users/password' && req.post?
    end

    throttle('users/password/email', limit: 5, period: 1.hour) do |req|
      next unless req.path == '/users/password' && req.post?

      req.params.dig('user', 'email').to_s.strip.downcase.presence
    end

    # Devise registration
    throttle('users/registration', limit: 5, period: 1.minute) do |req|
      req.ip if req.path == '/users' && req.post?
    end

    # PayPal capture calls the PayPal API on every request and is unauthenticated
    throttle('paypal/create', limit: 10, period: 1.minute) do |req|
      req.ip if req.path == '/create-paypal-transaction' && req.post?
    end

    # Catch-all per-IP limit for everything else. Assets are excluded so
    # normal page loads don't count against it.
    throttle('req/ip', limit: 300, period: 5.minutes) do |req|
      req.ip unless req.path.start_with?('/assets')
    end

    ### Custom Throttle Response ###

    # By default, Rack::Attack returns an HTTP 429 for throttled responses,
    # which is just fine.
    #
    # If you want to return 503 so that the attacker might be fooled into
    # believing that they've successfully broken your app (or you just want to
    # customize the response), then uncomment these lines.
    # self.throttled_responder = lambda do |env|
    #  [ 503,  # status
    #    {},   # headers
    #    ['']] # body
    # end
  end
end
