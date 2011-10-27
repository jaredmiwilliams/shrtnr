# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_shrtnr_session',
  :secret      => '9b3f6ee9902fbb59afa31498a5384d57f3ee0548de08247e4bf7601648a51e4c9759ef2a5c21380b115c56501557525aadd9f62f30ff41c33c625f388e130b14'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
