{% extends '_layout.swig' %}
{% import '_macro/post.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %}{{ title }}{% if theme.index_with_subtitle and subtitle %} - {{ subtitle }}{% endif %}{% endblock %}

{% block page_class %}
  {% if is_home() %}page-home{% endif -%}
{% endblock %}

{% block content %}
  <section id="posts" class="posts-expand">
    {% for post in page.posts %}
      {{ post_template.render(post, true) }}
    {% endfor %}
  </section>
  {% if is_home() %}
    <link rel="stylesheet" href="/live2d/css/live2d.css" />
    <div id="landlord">
      <div class="message" style="opacity:0"></div>
      <canvas id="live2d" width="280" height="250" class="live2d"></canvas>
      <div class="hide-button">隐藏</div>
    </div>
  {% endif -%}

  {% include '_partials/pagination.swig' %}
{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}

{% block script_extra %}
  {% if is_home() %}
    <script type="text/javascript">
      var message_Path = '/live2d/';
      var home_Path = 'https://loofp.com/';
    </script>
    <script type="text/javascript" src="/live2d/js/live2d.js"></script>
    <script type="text/javascript" src="/live2d/js/message.js"></script>
    <script type="text/javascript">
      loadlive2d("live2d", "/live2d/model/tia/model.json");
    </script>
  {% endif -%}
{% endblock %}
