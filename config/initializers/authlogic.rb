Authlogic::Session::Base.controller = "Api::V1::UserSessionsController"
Authlogic::Session::Base.logout_on_timeout = true
Authlogic::Session::Base.session_key = 'user_session'
# frozen_string_literal: true

