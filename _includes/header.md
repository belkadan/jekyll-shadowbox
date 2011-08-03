<!-- You probably want to change the "logo" header, which shows on the left side of a page. The "banner" should be fine. -->

<h1 id="banner">
	<a href="{{ site.baseurl }}">
		<img src="{{ site.baseurl }}/images/blog-banner" alt="{{ site.title }}" width="246"/>
	</a>
</h1>

<h1 id="logo">
{% if page.categories and page.categories[0] != '' %}
	<a href="{{ site.baseurl }}/{{ page.categories[0] | xml_id }}">
		{{ page.categories[0] | taxonomy_name }}
	</a>
{% elsif page.name and page.no_categories %}
	<a href="#">
		{{ page.name | taxonomy_name }}
	</a>
{% else %}
	<a href="http://belkadan.com">
		Belkadan Software
	</a>
{% endif %}
</h1>
