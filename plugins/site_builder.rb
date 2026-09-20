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

class ContentRouteGenerator < Bridgetown::Generator
  priority :low

  def generate(site)
    resources = site.resources.select do |resource|
      resource.data.layout == "article" && resource.data.draft != true
    end
    tags = resources.each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |resource, grouped|
      Array(resource.data.tags).each { |tag| grouped[tag] << resource }
    end
    tags["PyO3"] = [] unless tags.key?("PyO3")

    add_page(site, "tags", "index.md", "/tags/", "Tags", taxonomy_index(tags))
    add_feed(site, "tags", "/tags/index.xml", "Tags", taxonomy_feed_items(site, tags))
    tags.each do |label, tagged_resources|
      slug = slugify(label)
      add_page(site, File.join("tags", slug), "index.md", "/tags/#{slug}/", label, taxonomy_page(label, tagged_resources))
      add_feed(site, File.join("tags", slug), "/tags/#{slug}/index.xml", label, resource_feed_items(site, tagged_resources))
      add_redirect_page(site, File.join("tags", slug, "page", "1"), "/tags/#{slug}/")
    end

    add_page(site, "authors", "index.md", "/authors/", "Authors", taxonomy_index({}))
    add_page(site, "categories", "index.md", "/categories/", "Categories", taxonomy_index({}))
    add_page(site, "series", "index.md", "/series/", "Series", taxonomy_index({}))
    add_feed(site, "authors", "/authors/index.xml", "Authors", [])
    add_feed(site, "categories", "/categories/index.xml", "Categories", [])
    add_feed(site, "series", "/series/index.xml", "Series", [])
    { "blog" => "Blog", "portfolio" => "Portfolio", "demos" => "Demos" }.each do |section, title|
      section_resources = resources.select { |resource| resource.relative_url.start_with?("/#{section}/") }
      add_feed(site, section, "/#{section}/index.xml", title, resource_feed_items(site, section_resources))
      add_redirect_page(site, File.join(section, "page", "1"), "/#{section}/")
    end
  end

  private

  def add_page(site, directory, filename, permalink, title, content)
    page = Bridgetown::GeneratedPage.new(site, site.source, directory, filename)
    page.data["layout"] = "default"
    page.data["title"] = title
    page.data["description"] = "#{title} on #{site.metadata.title}"
    page.data["permalink"] = permalink
    page.content = content
    site.add_generated_page(page)
  end

  def add_feed(site, directory, permalink, title, items)
    page = Bridgetown::GeneratedPage.new(site, site.source, directory, "index.xml")
    page.data["layout"] = false
    page.data["permalink"] = permalink
    page.content = feed_markup(site, title, permalink, items)
    site.add_generated_page(page)
  end

  def add_redirect_page(site, directory, target)
    page = Bridgetown::GeneratedPage.new(site, site.source, directory, "index.html")
    page.data["layout"] = false
    page.data["permalink"] = "/#{directory}/"
    target_url = "#{site.metadata.url.chomp("/")}#{target}"
    page.content = <<~HTML
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <title>#{target_url}</title>
          <link rel="canonical" href="#{target_url}">
          <meta charset="utf-8">
          <meta http-equiv="refresh" content="0; url=#{target_url}">
        </head>
      </html>
    HTML
    site.add_generated_page(page)
  end

  def resource_feed_items(site, resources)
    resources.sort_by { |resource| resource.data.date ? resource.data.date.to_time.to_i : 0 }.reverse.first(20).map do |resource|
      url = "#{site.metadata.url.chomp("/")}#{resource.relative_url}"
      image = File.file?(File.join(site.source, resource.relative_url.sub(%r{\A/}, ""), "featured.png")) ? %(<media:content xmlns:media="http://search.yahoo.com/mrss/" url="#{url}featured.png" />) : ""
      date = resource.data.date ? %(<pubDate>#{resource.data.date.rfc2822}</pubDate>) : ""
      <<~XML.strip
        <item><title>#{escape(resource.data.title)}</title><link>#{url}</link>#{date}<guid>#{url}</guid><description>#{escape(resource.data.description)}</description>#{image}</item>
      XML
    end
  end

  def taxonomy_feed_items(site, grouped)
    grouped.map do |label, resources|
      url = "#{site.metadata.url.chomp("/")}/tags/#{slugify(label)}/"
      latest = resources.map { |resource| resource.data.date }.compact.max
      date = latest ? %(<pubDate>#{latest.rfc2822}</pubDate>) : ""
      "<item><title>#{escape(label)}</title><link>#{url}</link>#{date}<guid>#{url}</guid><description></description></item>"
    end.sort
  end

  def feed_markup(site, title, permalink, items)
    base_url = site.metadata.url.chomp("/")
    channel_url = "#{base_url}#{permalink.sub(%r{/index\.xml\z}, "/")}"
    entries = items.join("\n    ")
    <<~XML
      <?xml version="1.0" encoding="utf-8" standalone="yes"?>
      <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
        <channel>
          <title>#{escape(title)} on #{escape(site.metadata.title)}</title>
          <link>#{channel_url}</link>
          <description>Recent content in #{escape(title)} on #{escape(site.metadata.title)}</description>
          <generator>Bridgetown</generator>
          <language>#{escape(site.metadata.locale)}</language>
          <atom:link href="#{base_url}#{permalink}" rel="self" type="application/rss+xml" />
          #{entries}
        </channel>
      </rss>
    XML
  end

  def taxonomy_index(grouped)
    links = grouped.keys.sort.map do |label|
      slug = slugify(label)
      %(<a class="taxonomy-term" href="/tags/#{slug}/"><strong>#{escape(label)}</strong><span>#{grouped[label].length} #{grouped[label].length == 1 ? "entry" : "entries"}</span></a>)
    end
    %(<section class="taxonomy-page"><p class="lead">Browse the indexed topics across the site.</p><div class="taxonomy-terms">#{links.join}</div></section>)
  end

  def taxonomy_page(label, resources)
    entries = resources.sort_by { |resource| resource.data.date ? resource.data.date.to_time.to_i : 0 }.reverse.map do |resource|
      date = resource.data.date ? %(<time datetime="#{resource.data.date.iso8601}">#{resource.data.date.strftime("%-d %B %Y")}</time>) : ""
      %(<article class="taxonomy-entry"><h2><a href="#{resource.relative_url}">#{escape(resource.data.title)}</a></h2>#{date}<p>#{escape(resource.data.description.to_s)}</p></article>)
    end
    %(<section class="taxonomy-page"><p class="lead">Entries tagged <strong>#{escape(label)}</strong>.</p><div class="taxonomy-entries">#{entries.join}</div></section>)
  end

  def slugify(value)
    value.to_s.downcase.gsub(/[^a-z0-9+]+/, "-").sub(/-+$/, "")
  end

  def escape(value)
    CGI.escapeHTML(value.to_s)
  end
end
