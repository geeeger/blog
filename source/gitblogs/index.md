---
title: 来自git的博客
date: 2020-08-26 15:00:00
---

<ul id="_Gblog"></ul>
<link rel="stylesheet" href="//cdn.jsdelivr.net/gh/highlightjs/cdn-release@10.1.2/build/styles/tomorrow-night.min.css">
<script src="//cdn.jsdelivr.net/gh/highlightjs/cdn-release@10.1.2/build/highlight.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<script>
(function () {
var timer;
timer = setInterval(function(){
    if (typeof $ !== 'undefined') {
        clearInterval(timer)
        // for scroll
        var onScroll = function(e) {
            if ($.active != 0) {
                return;
            }
            if (e.data) {
                var offset = e.data.offset;
            };
            if (offset === undefined) {
                offset = $(window).height() * 0.7;
            }
            var viewPortBottom = $(window).scrollTop() + $(window).height(),
                breakPoint = $(document).height() - offset;
                reachedBottom = viewPortBottom >= breakPoint;
            if (!reachedBottom) return;
            $(window).trigger('infiniteScroll');
        };
        $.onInfiniteScroll = function(callback, options) {
            $(window).on('infiniteScroll', callback);
            $(window).on('scroll.infinite', options, onScroll);
        };
        $.destroyInfiniteScroll = function() {
            $(window).off('infiniteScroll');
            $(window).off('scroll.infinite');
        };
        var _Gblog = {
            page: 1,
            done: false,
            loading: false
        }
        function fetchIssues() {
            if (_Gblog.loading) {
                return;
            }
            if (_Gblog.done) {
                return;
            }
            _Gblog.loading = true
            $.ajax({
                url:"https://api.github.com/repos/geeeger/blog/issues",
                data:{
                    page: _Gblog.page++,
                }
            })
            .then(function(data, textStatus, jqXHR){
                var link = jqXHR.getResponseHeader("Link") || "";
                if(link.indexOf('rel="next"') < 0){
                    _Gblog.done = true
                }
                _Gblog.loading = false
                var tpl = ''
                var dom = document.querySelector('#_Gblog')
                var fragment = document.createDocumentFragment()
                for (var i = 0; i < data.length; i++) {
                    var container = document.createElement('li')
                    var item = data[i]
                    var content = '<div style="margin:10px 5px;padding:5px;background:#f2f2f2;">'
                    +   '<h3>'
                    +   '<a href="' + item.url + '">' + '[' + item.created_at + '] ' + item.title + '</a>'
                    +   '</h3>'
                    +   '<section style="margin:10px;">' + marked(item.body) + '</section>'
                    +   '</ p>'
                    container.innerHTML = content
                    fragment.appendChild(container)
                }
                dom.appendChild(fragment)
                $('pre code').each(function(i, block) {
                    hljs.highlightBlock(block);
                });
            });
        }
        fetchIssues()
        $.onInfiniteScroll(fetchIssues)
    }
},100)
})()
</script>