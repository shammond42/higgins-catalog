module ApplicationHelper

  def using_phone?
    (request.user_agent =~ /Mobile|webOS/) && !(request.user_agent =~ /iPad/)
  end

  def set_subtitle(subtitle)
    @subtitle = subtitle
  end

  def subtitle
    "#{@subtitle} : " if @subtitle.present?
  end

  def ga_tracking_code
    "<script type=\"text/javascript\">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-8222754-13']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>".html_safe
  end
end
