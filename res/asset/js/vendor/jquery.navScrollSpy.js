/**
 * jQuery lightweight plugin boilerplate
 * @file_name jquery.navScrollSpy.js
 * @author liuyidi <liuyidi1993@gmail.com>
 * Licensed under the MIT license
 */
;(function($, window, document, undefined){
    mouseInContainer = false;
    //pluginName
    var pluginName = "navScrollSpy";
    //defaults options
    var defaults = {
        navContainer: '#nav',  //外部容器
        navItems: 'a',        //元素
        current : 'current',  //当前
        easing : 'swing',   //动效
        speed: 550,        //速度
        // duration: y    //方向
        fixed: true,
        newTop: "30",        //停留在距离顶部的距离
        oldTop: "180"        //最开始的高度
    };

    function navScrollSpy(element, options){
        this.element = element;             //获得id=#nav
        this.$ele = $(element);             //获得$("#nav")
        this.$win = $(window);              //获取window
        this.options = $.extend({}, defaults, options);   //得到参数值
        this._defaults = defaults;
        this._name = pluginName;

        this.boxs = {};    //定义一个对象用来存放box的top值
        this.init();
    };

    navScrollSpy.prototype = {
        init: function(){
            //得到a元素
            this.$a = this.$ele.find(this.options.navItems);
            mouseInContainer = false;
            //得到内容区Box的top值
            this.getBoxTop();

            var container = $(this.options.navContainer);
            container.on('mouseover', function() {
                mouseInContainer = true;
            })
            container.on('mouseout', function() {
                mouseInContainer = false;
            })
            console.log('init');
            //点击切换导航按钮样式,更改上下文this
            this.$a.on("click", $.proxy(this.clickSwitch,this));

            //滚动切换导航按钮
            this.$win.on("scroll",$.proxy(this.scrolling,this));
            //当页面重置时会发生问题？
            return this;
        },

        //导航变化
        changeNav: function(self,$parent){
            var current = self.options.current;
            // console.log(current);
            self.$ele.find("."+current).removeClass(current);
            $parent.addClass(current);
        },

        //得到内容区的Top值
        getBoxTop: function(){
            var self = this;
            self.$a.each(function(){
                var boxId = $(this).attr("href").split('#')[1];
                // var boxTop = $("#"+boxId).offset().top;
                var boxTop = $("a[name='"+boxId+"']").offset().top;
                //存放boxtop到box对象中去
                self.boxs[boxId] = parseInt(boxTop);
            });
        },

        //滚动切换
        scrolling: function(){
            var st = $(window).scrollTop();
            var wH = $(window).height();
            //临界条件: $("#id").offset().top－$(window).scrollTop()>$(window).height()/2;

            for(var box in this.boxs){
                if(st >= this.boxs[box]-parseInt(wH/9)){
                    var $parent = this.$ele.find('a[href="#'+box+'"]');
                    // console.log($parent.attr('href'));
                    this.changeNav(this,$parent);
                }
            };

            var current = this.$ele.find("."+this.options.current);
            if (current.length > 0 && !mouseInContainer) {
                var container = $(this.options.navContainer);
                var offset = $(current).offset().top - container.offset().top + container.scrollTop();
                if ($(current).offset().top - container.offset().top < 0) {
                    container.scrollTop(offset - container.height()*0.15);
                }
                if ($(current).offset().top - container.offset().top > container.height()) {
                    container.scrollTop(offset - container.height()*0.85);
                }
            }
        },

        //点击切换
        clickSwitch: function(e){
            var $a = $(e.currentTarget);  //获得当前的a
            // var $parent = $a.parent();    //获得a的li元素
            var $parent = $a;
            var self = this;
            var target = "a[name='"+$a.attr("href").substring(1)+"']"; //新的a #id
            
            //滚动开始
            self.scrollTo(target, function(){

            });
            //导航切换
            self.changeNav(self,$parent);

            e.preventDefault();   //有current阻止冒泡
        },

        //滚动到某个地方
        scrollTo: function(target, callback){
            //获取目标元素的TOP值
            var offset = $(target).offset().top;
            var $el = $('html,body');

            if(!$el.is(":animated")){
                $el.animate({
                    scrollTop: offset
                }, this.options.speed, this.options.easing,callback);
            }
        }
    };

    $.fn.navScrollSpy = function(options){
        return this.each(function(){
            if(!$.data(this, "plugin_"+pluginName)){
                $.data(this, "plugin_"+pluginName,new navScrollSpy(this, options));
            }
        });
    };

})(jQuery, window, document);