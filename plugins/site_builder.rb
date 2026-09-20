require "cgi"
require "kramdown"

module LegacyShortcodes
  module_function

  def convert(content)
    content = content.gsub(/\{\{<\s*typeit\b.*?>\}\}(.*?)\{\{<\s*\/typeit\s*>\}\}/m) do
      %(<span class="typeit">#{Regexp.last_match(1).strip}</span>)
    end

    content = replace_block(content, "lead") { |body, _attrs| %(<div class="lead">#{markdown(body)}</div>) }
    content = replace_block(content, "keywordList") { |body, _attrs| %(<div class="keyword-list">#{body.strip}</div>) }
    content = content.gsub(/\{\{<\s*keyword\b([^>]*)>\}\}(.*?)\{\{<\s*\/keyword\s*>\}\}/m) do
      attrs = attributes(Regexp.last_match(1))
      icon = icon_markup(attrs["icon"]) if attrs["icon"]
      %(<span class="keyword-pill">#{icon}#{inline_markdown(Regexp.last_match(2))}</span>)
    end

    content = content.gsub(/\{\{<\s*timelineItem\b([^>]*)>\}\}(.*?)\{\{<\s*\/timelineItem\s*>\}\}/m) do
      attrs = attributes(Regexp.last_match(1))
      header = CGI.escapeHTML(attrs["header"].to_s)
      badge = attrs["badge"] ? %(<span class="timeline-badge">#{CGI.escapeHTML(attrs["badge"])}</span>) : ""
      subheader = attrs["subheader"] ? %(<p class="timeline-subheader">#{CGI.escapeHTML(attrs["subheader"])}</p>) : ""
      icon = icon_markup(attrs["icon"])
      body = markdown(Regexp.last_match(2))
      <<~HTML
        <article class="timeline-item">
          <div class="timeline-item-icon">#{icon}</div>
          <div class="timeline-item-card">
            <header><h3>#{header}</h3>#{badge}#{subheader}</header>
            <div class="timeline-item-body">#{body}</div>
          </div>
        </article>
      HTML
    end
    content = replace_block(content, "timeline") { |body, _attrs| %(<div class="timeline">#{body.strip}</div>) }

    content = replace_block(content, "mermaid") do |body, _attrs|
      %(<pre class="not-prose mermaid">#{CGI.escapeHTML(body.strip)}</pre>)
    end
    content = replace_block(content, "gallery") { |body, _attrs| %(<div class="gallery">#{body.strip}</div>) }

    content = content.gsub(/\{\{<\s*alert\b([^>]*)>\}\}(.*?)\{\{<\s*\/alert\s*>\}\}/m) do
      attrs = attributes(Regexp.last_match(1))
      styles = []
      styles << "background: #{attrs["cardColor"]}" if attrs["cardColor"]
      styles << "color: #{attrs["textColor"]}" if attrs["textColor"]
      style = styles.empty? ? "" : %( style="#{CGI.escapeHTML(styles.join("; "))}")
      %(<aside class="alert"#{style}>#{markdown(Regexp.last_match(2))}</aside>)
    end

    content = content.gsub(/\{\{<\s*button\b([^>]*)>\}\}(.*?)\{\{<\s*\/button\s*>\}\}/m) do
      attrs = attributes(Regexp.last_match(1))
      href = CGI.escapeHTML(attrs["href"].to_s)
      target = attrs["target"] ? %( target="#{CGI.escapeHTML(attrs["target"])}") : ""
      %(<a class="button" href="#{href}"#{target}>#{inline_markdown(Regexp.last_match(2))}</a>)
    end

    content = content.gsub(/\{\{<\s*github\b([^>]*)>\}\}/) do
      repo = CGI.escapeHTML(attributes(Regexp.last_match(1))["repo"].to_s)
      %(<div class="github-card"><a href="https://github.com/#{repo}">#{repo}</a></div>)
    end
    content = content.gsub(/\{\{<\s*badge\s*>\}\}(.*?)\{\{<\s*\/badge\s*>\}\}/m) do
      %(<span class="badge">#{Regexp.last_match(1).strip}</span>)
    end
    content = content.gsub(/\{\{<\s*icon\s+(?:["“]([^"”]+)["”]|icon=["“]([^"”]+)["”])\s*>\}\}/) do
      icon_markup(Regexp.last_match(1) || Regexp.last_match(2))
    end

    # Make an incomplete conversion visible in the generated source instead of
    # leaking Hugo syntax into the public page.
    content.gsub(/\{\{<\s*\/?[a-zA-Z][^>]*>\}\}/, "")
  end

  def replace_block(content, name)
    content.gsub(/\{\{<\s*#{name}\b([^>]*)>\}\}(.*?)\{\{<\s*\/#{name}\s*>\}\}/m) do
      yield(Regexp.last_match(2), attributes(Regexp.last_match(1)))
    end
  end

  def attributes(source)
    source.scan(/([a-zA-Z][\w-]*)=("[^"]*"|'[^']*'|\S+)/).to_h do |key, value|
      [key, value.sub(/\A['"]/, "").sub(/['"]\z/, "")]
    end
  end

  def icon_markup(name)
    return "" unless name

    icon_name = File.file?(File.join(Dir.pwd, "src", "icons", "#{name}.svg")) ? name : "code"
    safe_name = CGI.escapeHTML(icon_name)
    %(<img class="inline-icon" src="/icons/#{safe_name}.svg" alt="" width="16" height="16">)
  end

  def markdown(body)
    Kramdown::Document.new(body.strip).to_html.strip
  end

  def inline_markdown(body)
    body = body.gsub(/\{\{<\s*icon\s+(?:["“]([^"”]+)["”]|icon=["“]([^"”]+)["”])\s*>\}\}/) do
      icon_markup(Regexp.last_match(1) || Regexp.last_match(2))
    end
    markdown(body).sub(/\A<p>/, "").sub(%r{</p>\z}, "")
  end
end

Bridgetown::Hooks.register_one :resources, :post_read, priority: :high do |resource|
  next unless resource.content.is_a?(String)

  resource.content = LegacyShortcodes.convert(resource.content)
end

class SiteBuilder < Bridgetown::Builder
  def build
  end
end
