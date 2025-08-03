module Jekyll
  class DebugCheckTag < Liquid::Tag
    def render(context)
      "<p>✅ Custom plugin loaded successfully!</p>"
    end
  end
end

Liquid::Template.register_tag('debug_check', Jekyll::DebugCheckTag)
