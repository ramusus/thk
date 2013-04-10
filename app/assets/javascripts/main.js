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
    })

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