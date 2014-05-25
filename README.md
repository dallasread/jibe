# Jibe

Jibe keeps simple data 'n sync with very little setup. For now, it relies on Pusher.

## Installation

First, Add this line to your application's Gemfile:

```
gem 'jibe'
bundle
```

Then, [Set up Pusher.](https://github.com/pusher/pusher-gem) You'll also need to throw your pusher key into a meta tag named `pusher-key`.

Add `//= require jibe` to your `application.js` file.

Add `jibe` to your model.

```
class Comment < ActiveRecord::Base
  jibe
end
```

Replace a render call:

```
<table>
  <%= render @comments %>
</table>
```

turns into:

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
    strategy: "prepend", # by default, new tasks are appended
    scope: "completed", # useful in conjunction with JS callbacks
    restrict_to: [@folder, current_user] # limit access
%>
```

You can hijack the `beforeCreate`, `afterCreate`, `beforeUpdate`, `afterUpdate`, `beforeDestroy`, `afterDestroy` events. This is helpful for transitions.

```
Jibe.events["comments"] =
	beforeCreate: (partial, data, scope) ->
    # partial = the DOM node
    # data = the model's attributes (override with jibe_data method in your model)
    # scope = an optional scope based on the jibe tag in your view
    
```

## Contributing

1. Fork it ( https://github.com/dallasread/jibe/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
