require "cgi"

class SiteBuilder < Bridgetown::Builder
  def build
  end
end

class ContentRouteGenerator < Bridgetown::Generator
  priority :low

  def generate(site)
    resources = site.resources.select { |resource| resource.write? && resource.data.layout == "article" }
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
