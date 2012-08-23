## v1.1.0.beta

* add google urlshorter
* login_by_cert! can be end by ctr+c
* session start logic moved to GoogleApi::Session
* add check_session without raise error
* fix: login_by_line are now first write messae and then write

## v1.0.3

* GoogleApi::Ga::Data has now silent error, GoogleApi::Ga::Data.error(true) - raise error, GoogleApi::Ga::Data.error(false) - not error (default)
* add GoogleApi::Ga::Data.use_cache
* add GoogleApi::Ga::Data.clear_cache

## v1.0.2

* ids is convert to integer
* ids is checked befere execute
* check error after execute
