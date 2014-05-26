# Jibe

Jibe keeps simple data 'n sync with very little setup. For now, it relies on Pusher.

## Installation

First, Add `gem 'jibe'` to your application's Gemfile and `bundle`.

Then, [Set up Pusher.](https://github.com/pusher/pusher-gem)

You'll need to throw your pusher key into a meta tag named `pusher-key`:

```
<%= tag :meta, name: "pusher-key", content: CONFIG["pusher_key"] %>
```

Add `//= require jibe` to your `application.js` file.


## Usage

With only 2 1-word tweaks, your views will stay in sync!
Add `jibe` to the model you'd like to stay in sync. In our case, `app/models/comment.rb`.

```
class Comment < ActiveRecord::Base
  jibe
end
```

Replace a collection render call. In our case, its in `app/views/comments/index.html.erb`.

```
<table>
  <%= render @comments %>
</table>
```

should be replaced with:

```
<table>
  <%= jibe @comments %>
</table>
```

Now, all those `@comments` will stay in sync. At this point, its probably worth adding `remote: true` to your forms.

## Options

```
<%=
  jibe @comments, 
    strategy: "append", # where should jibe place new records (prepend/append)
    scope: [@post, "completed"], # checks AR objects against *_id attrs, strings are useful in conjunction with JS callbacks
    silent: true # don't manipulate the DOM
%>
```

You can control the way the DOM is updated by using the `beforeCreate`, `afterCreate`, `beforeUpdate`, `afterUpdate`, `beforeDestroy`, `afterDestroy` events. This is helpful for transitions.

```
Jibe.events["comments"] =
	beforeCreate: (partial, data, scope) ->
    # partial = the DOM node
    # data = the model's attributes (override with jibe_data method in your model)
    # scope = based on the jibe tag in your view
    # Jibe.inScope("completed", scope) is useful to check if the record is within the scope
    
```

## Contributing

1. Fork it ( https://github.com/dallasread/jibe/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
