require 'open-uri'
require 'nokogiri'

module Jekyll
  class ScholarProfileTag < Liquid::Tag
    puts "[DEBUG] ✅ Loaded scholar_stats plugin"
    def render(context)
      user_id = context.registers[:site].config['google_scholar_id']
      profile_url = "https://scholar.google.com/citations?user=#{user_id}&hl=en"
      begin
        html = URI.open(profile_url).read
        doc = Nokogiri::HTML.parse(html)
        publications = doc.css('.gsc_a_tr').first(5) # Top 5 only

        output = "<ul class='scholar-publications'>"
        publications.each do |pub|
          title = pub.at_css('.gsc_a_at')&.text
          link = pub.at_css('.gsc_a_at')&.[]('href')
          authors = pub.at_css('.gs_gray')&.text
          journal = pub.css('.gs_gray')[1]&.text

          output += "<li>"
          output += "<strong><a href='https://scholar.google.com#{link}' target='_blank' rel='noopener'>#{title}</a></strong><br>"
          output += "#{authors}<br><em>#{journal}</em>"
          output += "</li>"
        end
        output += "</ul>"
        output
      rescue => e
        "<p>Unable to load Google Scholar feed: #{e.message}</p>"
      end
    end
  end
end

Liquid::Template.register_tag('scholar_profile', Jekyll::ScholarProfileTag)
