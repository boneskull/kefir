;(function(global){
  "use strict";

  function init(Kefir, $) {





    $.fn.asStream = function(event, selector, transformer) {
      var $el = this;
      if (transformer == null && selector != null && 'string' !== typeof selector) {
        transformer = selector;
        selector = null;
      }
      transformer = transformer && new Kefir.Fn(transformer);
      return Kefir.fromBinder(function(send) {
        function onEvent(e) {
          send('value', transformer ? Kefir.Fn.call(transformer, arguments) : e);
        }
        $el.on(event, selector, onEvent);
        return function() {  $el.off(event, selector, onEvent)  }
      });
    }






  }

  if (typeof define === 'function' && define.amd) {
    define(['kefir', 'jquery'], init);
  } else if (typeof module === "object" && typeof exports === "object") {
    init(require('kefir'), require('jquery'));
  } else {
    init(global.Kefir, global.jQuery);
  }

}(this));
