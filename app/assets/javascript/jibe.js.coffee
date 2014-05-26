@Jibe ||= {}

Jibe.events ||= {}

Jibe.tearDown = ->
	Jibe.initialized = false
	Jibe.pusher.disconnect()
	
Jibe.initialized = false

Jibe.inScope = (test, scope) ->
	!$.inArray test, scope == -1

Jibe.compareScopeWithData = (scope, data) ->
	if !scope.length
		in_scope = true
	else
		scope_passes = 0

		$.each scope, (index, s) ->
			s_split = s.split("=")
			if s_split.length
				if "#{data.data[s_split[0]]}" == "#{s_split[1]}" || "#{data.data.data[s_split[0]]}" == "#{s_split[1]}"
					scope_passes += 1
			else
				scope_passes += 1
		
		in_scope = scope_passes == scope.length
	
	in_scope

Jibe.init = ->
	unless Jibe.initialized
		Jibe.initialized = true
		pusher_key = $("meta[name='pusher-key']").attr("content")
		Jibe.pusher = new Pusher pusher_key
		channel = Jibe.pusher.subscribe "jibe"
		
		channel.bind "event", (data) ->
			$("script[type='x-jibe'][data-resource='#{data.collection}']").each ->
				scope = if typeof $(this).data("scope") == "undefined" then [] else $(this).data("scope").split(" ")
				wrapper = $(this).parent()
				before_hook_name = "before#{data.action_capitalized}"
				after_hook_name = "after#{data.action_capitalized}"
				partial = $(data.partial)
				on_page = $(this).parent().find(".#{data.dom_id}, ##{data.dom_id}, .#{data.model}[data-id='#{data.id}']")
				has_events = typeof Jibe.events[data.collection] != "undefined"
				in_scope = Jibe.compareScopeWithData scope, data
				
				if in_scope
					if has_events && typeof Jibe.events[data.collection][before_hook_name] == "function"
						Jibe.events[data.collection][before_hook_name].call null, partial, data.data, scope
				
					if typeof $(this).data("silent") == "undefined"
						if data.action_name == "create"
							if $(this).data("strategy") == "prepend"
								partial.prependTo wrapper
							else
								partial.appendTo wrapper
						else if data.action_name == "update"
							on_page.replaceWith partial
						else if data.action_name == "destroy"
							on_page.remove()
				
					if has_events && typeof Jibe.events[data.collection][after_hook_name] == "function"
						Jibe.events[data.collection][after_hook_name].call null, partial, data.data, scope

$ ->
	Jibe.init()

document.addEventListener "page:fetch", Jibe.tearDown
document.addEventListener "page:change", Jibe.init