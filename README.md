Google Analytics [![Build Status](https://secure.travis-ci.org/[ondra-m]/[google_api].png)](http://travis-ci.org/[ondra-m]/[google_api])
================

<a href="#examples">examples</a>

News
----

For now is released beta version. Pleas use issues for problems.

Installation
------------

Add this line to your application's Gemfile:

`gem 'google_api'`

And then execute:

`$ bundle`

Or install it yourself as:

`$ gem install google_api`

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
      <td>client_id</td>
      <td><i>123456.apps.googleusercontent.com</i></td>
      <td rowspan="3">required for oauth 2</td>
    </tr>
    <tr>
      <td>client_secret</td>
      <td><i>123456123456123456</i></td>
    </tr>
    <tr>
      <td>redirect_uri</td>
      <td><i>http://localhost/oauth2callback</i></td>
    </tr>
    <tr>
      <td>client_developer_email</td>
      <td><i>123456@developer.gserviceaccount.com</i></td>
      <td rowspan="3">required for login by cert</td>
    </tr>
    <tr>
      <td>client_cert_file</td>
      <td><i>/home/user/app/123456-privatekey.p12</i></td>
    </tr>
    <tr>
      <td>key_secret</td>
      <td><i>notasecret</i></td>
    </tr>
    <tr>
      <td colspan="3">only for ga</td>
    </tr>
    <tr>
      <td>cache</td>
      <td><i>default: </i><b>GoogleApi::Cache.new</b></td>
      <td>more information <a href="#Cache">Cache</a></td>
    </tr>
  </tbody>
</table>

<a name="Cache"></a>
Cache
-----

Cache must have these methods:

`write(key, value, expire)` - expire=0 for never expire<br>
`read(key)`<br>
`exists?(key)`<br>
`delete(key)`

Session
-------

There is a 3 way for starting sesssion.

### By cert file

`First you must add your developer email to google analytics profile.`

```ruby
# try login once
GoogleApi::Ga::Session.login_by_cert

# ----- OR -----

# trying login in loop
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

First you can play on the playground: http://ga-dev-tools.appspot.com/explorer/.

```ruby
GoogleApi::Ga::Data
```
<br>
> ## ids 
>
> <a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#ids" target="_blank" style="float:right">doc</a>
>
> **alias:** id
>
> Id of profile, by default is use id from GoogleApi::Ga.id.

<br>

> ## start_date
>
> <a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#startDate" target="_blank" style="float:right">doc</a>
>
> **alias:** from
>
> **default:** _Date.today_<br>
> **parameters:**<br>
> &nbsp;&nbsp; _String_ in YYYY-MM-DD or _Date_ or _DateTime_ or _Time_<br>
> &nbsp;&nbsp; _Integer_ for add or sub days from _Date.today_

<br>

> ## end_date
>
> <a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#startDate" target="_blank" style="float:right">doc</a>
>
> **alias:** from
>
> **default:** _Date.today_<br>
> **parameters:**<br>
> &nbsp;&nbsp; _String_ in YYYY-MM-DD or _Date_ or _DateTime_ or _Time_<br>
> &nbsp;&nbsp; _Integer_ for add or sub days from _Date.today_

<br>

> ## metrics
>
> <a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#metrics" target="_blank" style="float:right">doc</a>
>
> required parameters
>
> **alias:** select
>
> you can also add or sub parameters with `.metrics_add` or `.metrics_sub`
>
> **parameters:** Array with String or Symbol, String (not compiled, <i>"ga:visitors"</i>) or Symbol (compiled, <i>:visitors</i>)

<br>

> ## dimensions
>
> <a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#dimensions" target="_blank" style="float:right">doc</a>
>
> **alias:** with
>
> you can also add or sub parameters with `.dimensions_add` or `.dimensions_sub`
>
> **parameters:** Array with String or Symbol, String (not compiled, <i>"ga:visitors"</i>) or Symbol (compiled, <i>:visitors</i>)

<br>

> ## sort
>
> <a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#sort" target="_blank" style="float:right">doc</a>
> you can also add or sub parameters with `.sort_add` or `.sort_sub`
>
> **parameters:** Array with String or Symbol, String (not compiled, <i>"ga:visitors"</i>) or Symbol (compiled, <i>:visitors</i>)

<br>

> ## filters
>
> <a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#filters" target="_blank" style="float:right">doc</a>
>
> **alias:** where
>
> **parameters:**<br>
> {(attribute operator value) & (attribute operator value) | (attribute operator value)} or String (not compiled)
>
> **operators:** ==, !=, >, <, >=, <=, =~, !~<br>
> % &nbsp;&nbsp;&nbsp; _is &nbsp;=@_<br>
> ** &nbsp;&nbsp;&nbsp; _is &nbsp;&nbsp;!@_

<br>

> ## segment
>
> <a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#segment" target="_blank" style="float:right">doc</a>
>
> **parameters:**<br>
> {(attribute operator value) & (attribute operator value) | (attribute operator value)} or String (not compiled) <br>
>  with {} automaticly add "dynamic::"
>
> **operators:** ==, !=, >, <, >=, <=, =~, !~<br>
> % &nbsp;&nbsp;&nbsp; _is &nbsp;=@_<br>
> ** &nbsp;&nbsp;&nbsp; _is &nbsp;&nbsp;!@_

<br>

> ## start_index
>
> <a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#startIndex" target="_blank" style="float:right">doc</a>
>
> **alias:** offset
>
> **parameters:** Integer from 1. 

<br>

> ## max_results
>
> <a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#maxResults" target="_blank" style="float:right">doc</a>
>
> **alias:** limit
>
> **parameters:** Integer from 1 to 10 000. 

<br><br><br>

> ## cache
> 
> For how long in minutes will be data cached. Use 0 for never expire.

<br>

> ## clear
>
> Clear stored data.

### Fetch data

You can use one of these. Data is stored in the class.

`.all` - `[header, rows]`<br>
`.rows` - rows returned by google analytics<br>
`.header` - header of data, (`["ga:day", "ga:month", "ga:visitis"]`)<br>
`.count` - number of rows<br>
`.each` - each as you expected, (`|data|` or `|index, data|`)

### Clear stored data and fetch again

If you add some parameters clear is called automaticlly.

clear: `.clear`<br>

clear and fetch new:<br>
`.all!`, `.rows!`, `.header!`, `.count!`, `.each!`<br>

Examples
--------


```ruby
# Start session
# =============

  # set configuration
  GoogleApi.config.ga.client_cert_file = "privatekey.p12"
  GoogleApi.config.ga.client_developer_email = "123456@developer.gserviceaccount.com"

  # start session
  GoogleApi::Ga::Session.login_by_cert!



# Get profile id
# ==============

  # get profile id
  id = GoogleApi::Ga::Profile.all.first.id

  # set default id
  GoogleApi::Ga.id(id)



# Starting session by line
# ========================

  # First install launchy:
  #   gem install launchy

  # callback_uri and port are optional - auto start server at localhost
  GoogleApi::Ga::Session.login_by_line(callback_uri, port)

  # This will do
  # 1) create server
  # 2) launch browser and redirect to google api
  # 3) confirm and google api redirect to localhost
  # 4) server get code and start session
  # 5) close server - you are login



# Check session, error if not login
# =================================

  GoogleApi::Ga::Session.check_session!
  
  
  
# Management of accounts
# ======================

  # all accounts
  accounts = GoogleApi::Ga::Account.all

  # webproperties for account
  accounts.first.webproperties

  # all webproperties
  GoogleApi::Ga::Webproperty.all

  # all profiles
  GoogleApi::Ga::Profile.all

  # all goal
  GoogleApi::Ga::Goal.all

  # all segment
  GoogleApi::Ga::Segment.all



# Count of visitors between previous month and today
# ==================================================

  GoogleApi::Ga::Data.from(-30).select(:visits).rows



# Count of visitors between previous month and today - 2, and cache it for 30 minutes
# ===================================================================================

GoogleApi::Ga::Data.from(-30).to(-2).select(:visits).cache(30).rows



# Visitors by day, month, year from Czech Republic. Browser is Firefox and Opera or Chrome
# ========================================================================================

  GoogleApi::Ga::Data.from(-30).select(:visits).with(:day, :month, :year)
                     .sort(:year, :month, :day)
                     .where{(country == "Czech Republic") & 
                            (browser == "Firefox") &
                            (browser == "Opera") | 
                            (browser == "Chrome")}
                     .rows
  # ----- OR -----
  GoogleApi::Ga::Data.from(-30).select(:visits).with(:day, :month, :year)
                     .sort(:year, :month, :day)
                     .where("ga:country==Czech Republic;ga:browser==Firefox;ga:browser==Opera,ga:browser==Chrome")
                     .rows
```