module Jibe
  module ViewHelpers
    def jibe *args
      if args.try(:last).is_a? Hash
        strategy = args.try(:last)[:strategy]
        scope = args.try(:last)[:scope]
        silent = args.try(:last)[:silent]
        restrict_to = args.try(:last)[:restrict_to]
        partial = args.try(:partial)
      end

      begin
        resource = args.first.table_name
      rescue
        resource = args.first.first.class.name.downcase.pluralize
      end

      data = {}
      data[:resource] = resource
      data[:strategy] = strategy if strategy
      data[:silent] = silent if silent
      
      if scope
        if scope.is_a? Array
          scopes = []
          
          scope.each do |s|
            s = "#{s.class.name.downcase}_id=#{s.id}" unless s.is_a? String
            scopes.push s
          end
          
          data[:scope] = scopes.join(" ")
        elsif scope.is_a? Object
          data[:scope] = "#{scope.class.name.downcase}_id=#{scope.id}"
        else
          data[:scope] = scope
        end
      end
      
      data[:silent] = true if args.first.nil?
      html = content_tag :script, nil, type: "x-jibe", data: data
      html += render *args unless args.first.nil?
      html.html_safe
    end
  end
end