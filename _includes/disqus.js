<script type="text/javascript">
	if (document.getElementById('disqus_thread')) {
		var disqus_shortname = '{{ site.disqus }}';
		var disqus_identifier = '{{ page.url }}';
		var disqus_url = '{{ site.base_url }}{{ page.url }}';
		var disqus_title = '{{ page.title }}';
		{% if site.offline %}
		var disqus_developer = 1;
		{% endif %}

		(function() {
			var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
			dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
			(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);

			// var commentCount = setInterval(function() {
			// 	if ($('#dsq-num-posts').length) {
			// 		$('.responses-number').html($('#dsq-num-posts').html());
			// 		clearInterval(commentCount);
			// 	}
			// }, 1000);
		})();
	}
</script>
