require "json"
require "minitest/autorun"
require "rexml/document"
require "rexml/xpath"
require "uri"

class SiteContractTest < Minitest::Test
  OUTPUT = File.expand_path("../output", __dir__)
  EXTERNAL_DEMO_SLUGS = %w[
    delivery-routing-rust
    employee-scheduling
    field-service-routing-rust
    flight-crew-scheduling-java
    lesson-timetabling-rust
    maintenance-scheduling
    meeting-scheduling
    order-picking
    portfolio-optimization
    vehicle-routing
    vm-placement
  ].freeze

  def test_published_routes_exist
    %w[
      /
      /about/
      /services/
      /blog/
      /blog/easa-ftl-constraints-flight-crew-scheduling/
      /blog/implementing-late-acceptance-rust/
      /demos/
      /portfolio/
      /portfolio/1765120232288-solverforge---a-constraint-programming-framework-for-rust-and-python/
      /portfolio/aitdtnn-pc-overhaul/
      /portfolio/computer-use-sway/
      /portfolio/elphame/
      /portfolio/franking/
      /portfolio/lumen/
      /portfolio/meridian/
      /portfolio/planner123/
      /portfolio/redona-broadcasting/
      /portfolio/ricespace/
      /portfolio/tranche/
      /portfolio/trex/
      /portfolio/yuga-planner/
      /portfolio/zoyd/zoyd/
      /redona/
      /redona/zh/
    ].each do |route|
      assert File.file?(output_file(route)), "missing published route #{route}"
    end

    EXTERNAL_DEMO_SLUGS.each do |slug|
      refute File.file?(output_file("/demos/#{slug}/")), "external demo rendered locally: #{slug}"
    end
  end

  def test_demos_listing_links_every_external_demo
    html = File.read(output_file("/demos/"), encoding: "UTF-8")
    cards = html.scan(/<article class="resource-card">/).length

    assert_equal EXTERNAL_DEMO_SLUGS.length, cards, "demos listing card count"
    assert_equal EXTERNAL_DEMO_SLUGS.length, html.scan(%r{<h3><a href="https://huggingface\.co/spaces/}).length
  end

  def test_search_index_contains_only_searchable_pages
    entries = JSON.parse(File.read(File.join(OUTPUT, "index.json")))
    permalinks = entries.map { |entry| entry.fetch("permalink") }

    assert_equal permalinks.uniq.length, permalinks.length
    assert_includes permalinks, "/"
    refute permalinks.any? { |url| url.start_with?("//") }
    refute permalinks.any? { |url| url.end_with?(".xml", ".json") }
    refute EXTERNAL_DEMO_SLUGS.any? { |slug| permalinks.include?("/demos/#{slug}/") }
    refute entries.any? { |entry| entry["external_url"] }
  end

  def test_sitemap_contains_published_page_routes_only
    document = REXML::Document.new(File.read(File.join(OUTPUT, "sitemap.xml")))
    routes = REXML::XPath.match(document, "//xmlns:url/xmlns:loc", "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9").map do |loc|
      URI.parse(loc.text).path
    end

    assert_includes routes, "/"
    refute routes.any? { |route| route.match?(%r{\A/(tags|authors|categories|series)/}) }
    refute routes.any? { |route| route.include?("/page/1/") }
    routes.each { |route| assert File.file?(output_file(route)), "sitemap route does not exist: #{route}" }
  end

  def test_feeds_are_valid_and_exclude_unpublished_external_demos
    Dir[File.join(OUTPUT, "**/*.xml")].each do |file|
      document = REXML::Document.new(File.read(file))
      links = REXML::XPath.match(document, "//item/link").map(&:text)
      refute links.any? { |link| link.include?("huggingface.co") }, "external demo leaked into #{file}"
    end
  end

  def test_chinese_page_glyphs_are_in_the_subset_fonts
    page = File.read(output_file("/redona/zh/"), encoding: "UTF-8")
    subset = File.read(File.join(OUTPUT, "redona/fonts/zh-glyphs.txt"), encoding: "UTF-8")
    cjk = /[\u3000-\u303F\u4E00-\u9FFF\uFF00-\uFFEF]/
    missing = page.scan(cjk).uniq - subset.scan(cjk).uniq
    assert_empty missing, "run script/redona-zh-fonts.py: subset lacks #{missing.join}"
  end

  def test_home_plays_the_studio_reel
    html = File.read(output_file("/"), encoding: "UTF-8")
    assert_includes html, '<source src="/video/studio-07.mp4"'
    assert_includes html, 'poster="/video/studio-07.jpg"'
    assert File.file?(output_file("/video/studio-07.mp4")), "reel video not published"
    assert File.file?(output_file("/video/studio-07.jpg")), "reel poster not published"
  end

  private

  def output_file(route)
    relative = route.sub(%r{\A/}, "")
    route.end_with?("/") ? File.join(OUTPUT, relative, "index.html") : File.join(OUTPUT, relative)
  end
end
