Google Analytics
================

Configuration
-------------

```ruby
GoogleApi.configure do
  client_id "1"

  ga do
    client_id "2"
  end
end
```
**Or**

```ruby
GoogleApi.configure do |config|
  config.client_id "3"

  config.ga do |ga_config|
    ga_config.client_id "4"
  end
end
```

**Or**

```ruby
GoogleApi.config.client_id = "5"
GoogleApi.config.ga.client_id = "6"
```

### Get value

```ruby
GoogleApi.config.client_id
GoogleApi.config.ga.client_id
```

### Values

**client\_id:** 123456.apps.googleusercontent.com<br>
**client\_secret:** 123456123456123456<br>
**client\_developer\_email:** 123456@developer.gserviceaccount.com<br>
**client\_cert\_file:** located of your cert file<br>
**key\_secret:** 'notasecret'<br>
**redirect\_uri:** nil

Session
-------

There is a 3 way for starting sesssion.

### By cert file

```ruby
# use client_cert_file, client_developer_email
GoogleApi::Ga::Session.login_by_cert
```

Trying to login until login return true.

```ruby
GoogleApi::Ga::Session.login_by_cert!
```

### By oauth 2

```ruby
# use client_id, client_secret, redirect_uri
# return uri for oauth 2 login
GoogleApi::Ga::Session.login

# after callback
# code = code key in query (params[:code])
GoogleApi::Ga::Session.login(code)
```

**In rails:**

```ruby
redirect_to(GoogleApi::Ga::Session.login)

# in page specified in redirect_uri
GoogleApi::Ga::Session.login(params[:code])
```

### By oauth 2 via line (browser needed)

This will create TCPServer. After login will be closed.

**server:** optional is localhost, must be full path!<br>
**port:** on which port the server will listen

```ruby
# use client_id, client_secret
# default:
#   server = http://localhost/oauth2callback
#   port = 0 - get first free port
GoogleApi::Ga::Session.login_by_line(server, port)
```
