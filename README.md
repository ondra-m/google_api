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

# ----- OR -----

GoogleApi.config.client_id    = "4"
GoogleApi.config.ga.client_id = "5"
```

<table>
  <thead>
    <tr>
      <th>name</th>
      <th>example</th>
      <th>note</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td><b>client_id</b></td>
      <td><i>123456.apps.googleusercontent.com</i></td>
      <td rowspan="3">required for oauth 2</td>
    </tr>
    <tr>
      <td><b>client_secret</b></td>
      <td><i>123456123456123456</i></td>
    </tr>
    <tr>
      <td><b>redirect_uri</b></td>
      <td><i>http://localhost/oauth2callback</i></td>
    </tr>
    <tr>
      <td><b>client_developer_email</b></td>
      <td><i>123456@developer.gserviceaccount.com</i></td>
      <td rowspan="3">required for login by cert</td>
    </tr>
    <tr>
      <td><b>client_cert_file</b></td>
      <td><i>/home/user/app/123456-privatekey.p12</i></td>
    </tr>
    <tr>
      <td><b>key_secret</b></td>
      <td><i>notasecret</i></td>
    </tr>
    <tr>
      <td colspan="3">only for ga</td>
    </tr>
    <tr>
      <td><b>cache</b></td>
      <td><i>default: </i><b>GoogleApi::Cache.new</b></td>
      <td>more information <a href="#Cache">Cache</a></td>
    </tr>
  </tbody>
</table>

<a name="Cache"></a>
Cache
-----

Cache mus have these methods:

`write(key, value, expire = 0)` - 0 for never expire<br>
`read(key)`<br>
`exists?(key)`<br>
`delete(key)`

Session
-------

There is a 3 way for starting sesssion.

### By cert file

```ruby
GoogleApi::Ga::Session.login_by_cert
```

If login return false, trying login again.

```ruby
GoogleApi::Ga::Session.login_by_cert!
```

### By oauth 2

```ruby
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
# default:
#   server = http://localhost/oauth2callback
#   port = 0 - get first free port
GoogleApi::Ga::Session.login_by_line(server, port)
```

Management
----------

<table>
  <thead>
    <tr>
      <th colspan="2">Account ~~~ Webproperty ~~~ Profile ~~~ Goal ~~~ Segment</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>all</b></td>
      <td>find all</td>
    </tr>
    <tr>
      <td><b>find(id)</b></td>
      <td>find one by id</td>
    </tr>
    <tr>
      <td><b>refresh</b></td>
      <td>refresh data</td>
    </tr>
  </tbody>
</table>

#### Account

```ruby
# Variables: id, name, created, updated
# Methods:   webproperties

GoogleApi::Ga::Account
```

#### Webproperty

```ruby
# Variables: id, name, created, updated, accountId, websiteUrl
# Methods:   account, profiles

GoogleApi::Ga::Webproperty
```

#### Profile

```ruby
# Variables: id, name, created, updated, accountId, websiteUrl, currency, timezone
# Methods:   webproperty, goals

GoogleApi::Ga::Profile
```

#### Goal

```ruby
# Variables: accountId, webPropertyId, profileId, value, active, type, goal
# Methods:   profile

GoogleApi::Ga::Goal
```

#### Segment

```ruby
# Variables: segmentId, definition

GoogleApi::Ga::Segment
```

Set default id
--------------

```ruby
GoogleApi::Ga.id(123456) # profile id
```

Data
----

First you can play on the playground: http://ga-dev-tools.appspot.com/explorer.

```ruby
GoogleApi::Ga::Data
```








filter
segment
start_index
max_results

<table style="width:100%">

    <tr>
      <td style="width:10%">name</td>
      <td>alias</td>
      <td>description</td>
      <td>required</td>
    </tr>

    <tr>
      <td>ids</td>
      <td>id</td>
      <td>id of profile, by default use default id (GoogleApi::Ga.id)</td>
      <td>yes</td>
    </tr>
    <tr>
      <td>cache</td>
      <td></td>
      <td>
        for how long in minutes will be data cached,<br>
        for example: visitors count between last year and last week will not change
      </td>
      <td>no</td>
    </tr>
    <tr>
      <td>start_date</td>
      <td>from</td>
      <td></td>
    </tr>
    <tr>
      <td>end_date</td>
      <td>to</td>
      <td></td>
    </tr>
    <tr>
      <td>metrics</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>dimensions</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>sort</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td></td>
      <td></td>
      <td></td>
    </tr>

</table>



