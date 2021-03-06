var init_sliders = function() {

    $('.slider').each(function() {
        var $box = $(this),
            $sliderNav = $box.find('.slider-nav'),
            $sliderBox = $box.find('.slider-list'),
            $sliderItems = $sliderBox.find('.slider-item'),
            $sliderNavPrev = $sliderNav.find('.slider-nav-prev'),
            $sliderNavNext = $sliderNav.find('.slider-nav-next'),
            $sliderNavCur = $sliderNav.find('.slider-nav-num'),
            $sliderNavTotal = $sliderNav.find('.slider-nav-of'),

            CLASS_CURRENT = 'current',
            CLASS_INVERTED = 'inverted';

        $sliderNavTotal.text($sliderItems.length);

        var show = function($item) {
            $sliderItems.fadeOut();
            $item.fadeIn();
            $sliderNavCur.text($item.index() + 1);
            $sliderNav.removeClass(CLASS_INVERTED);
            if ($item.hasClass(CLASS_INVERTED)) {
                $sliderNav.addClass(CLASS_INVERTED);
            }
        }

        $sliderNavNext.on('click', function() {
            $cur = $cur.next();
            if (!$cur.length) $cur = $sliderItems.first();
            show($cur);
        });

        $sliderNavPrev.on('click', function() {
            $cur = $cur.prev();
            if (!$cur.length) $cur = $sliderItems.last();
            show($cur);
        });

        $sliderBox.on('click', function() {
            $sliderNavNext.trigger('click');
        });

        var $cur = $sliderBox.find('.' + CLASS_CURRENT);
        show($cur);
    });
}

// Функция, подгрузки статей в количестве v_number
manage_visible_articles = function(articles_visible) {
    var s_list = $('ul.article-list.clear'),
        s_items = $('li', s_list),
        s_items_hidden = s_items.filter(':hidden'),
        s_load_more,
        v_number = 10;

    s_items.slice(0, articles_visible).show();

    if(s_items.length > articles_visible)
        s_list.after('<div class="loadmore">Загрузить еще материалов ...</div>');

    s_load_more = $('.loadmore');
    s_load_more.click(showMoreArticles);

    // Определяет показ следующих пунктов
    function showMoreArticles() {
        var v_this = $(this),
            s_items_hidden = s_items.filter(':hidden'),
            v_hidden_items = s_items_hidden.length;

        s_items_hidden.slice(0, articles_visible).show();
        if(v_hidden_items <= articles_visible - 1) {
            v_this.hide();
        }
    }
}

function ArticlesBlock(el, options) {

  var settings = $.extend({
    per_page:  21,
    filter:  {
      on_index:  false,
      type:      null,
      mhl:       false,
      published: true
    }, 
    template: JST['article'] || null
  }, options);

  var page = 1;

  function appendLoadmore() {
    var button = $('<div>').addClass('loadmore').html('Загрузить еще материалов...');
    $(el).append(button);    
    return button;
  }

  function getContext(page_num) {
    var context = {
      page: page_num,
      per_page: settings.per_page
    }
    $.each(settings.filter, function(key, val) {
       if(val) context[key] = val;
    });    
    return context;
  }

  function onLoad(res) {
    var list = $('ul.article-list', el);
    var last_page = 0;
    if(settings.template) {
      $.each(res, function(i, item) {
        list.append(settings.template(item));
        last_page = item.last_page;
      });
    }
    if(page == last_page) {
      $('.loadmore', el).hide();
    }

  }

  function loadPage(page_num) {
    return $.get('/articles.json', getContext(page_num), onLoad, 'json');
  }

  function init() {
    $(el).on('click', '.loadmore', function(e) {
      var loader = $(this);
      loader.addClass('pending');
      page = page + 1;
      loadPage(page).always(function() {
        loader.removeClass('pending');
      });
    });
    loadPage(page).done(appendLoadmore)
  }
  init();
}

$(function() {
    $('.tabs').each(function() {
        var $box = $(this),
            $clickers = $box.find('.tabs-switcher-item'),
            $tabs = $box.find('.tabs-tab'),

            CLASS_ACTIVE = 'active';

        $clickers.on('click', function() {
            var index = $(this).index();
            $box.find('.' + CLASS_ACTIVE).removeClass(CLASS_ACTIVE);
            $(this).addClass(CLASS_ACTIVE);
            $tabs.eq(index).addClass(CLASS_ACTIVE);
        })
    });

    // По умолчанию необходимо показывать на странице championships прошедшие игры
    // defaultGames();
    // function defaultGames() {
    //     var v_url_page = window.location.href,
    //         v_reg_exp = /championships/,
    //         v_result_search = v_url_page.search(v_reg_exp),
    //         v_need_tab = 'прошедшие игры',

    //         s_tabs = $('.tabs-switcher-item');
        
    //     if(v_result_search < 0) return;

    //     s_tabs.each( searchNeedTab );

    //     function searchNeedTab(index, value) {
    //         var s_tab = $(value),
    //             v_text = s_tab.text();
            
    //         if( v_text == v_need_tab ) {
    //             s_tab.click();
    //         }
    //     }

    // }

    init_sliders();

    var $stick = $('.stick');
    $(window).scroll(function(){
        var y = $(window).scrollTop();
        if (y > 200 && y < 400) {
            $stick.hide();
        }
        else {
            if (y > 400) {
                $stick.fadeIn();
                $stick.addClass('sticky');
            }
            else {
                $stick.show();
                $stick.removeClass('sticky');
            }
        }
    });
});