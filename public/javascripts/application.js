  function SubmitHandler(element, params, data) {
    this.element = element;

    this.params = params;

    this.data = data;

    this.enabled = true;
  }

  SubmitHandler.prototype.register = function() {
    var self = this;

    this.element.click(function(event) {
      if(self.params[0].hasClass('placeholding')) {
        return;
      }

      if(self.enabled) {
        self.enabled = false;

        self.element.animate({
          opacity : 0.5
        });

        self.data(self.params);
      }
    });
  }

  function InputPlaceHolder(element, placeholder) {
    this.element = element;
    this.placeholder = placeholder;
  }

  InputPlaceHolder.prototype.register = function() {
    var self = this;
    this.element.focus(function() {
      var value = self.element.attr('value');

      if(value && value == self.placeholder) {
        self.element.attr('value', '');
      }

    });
    this.element.blur(function() {
      var value = self.element.attr('value');

      if(!value || value.match(/^\s*$/)) {
        self.element.attr('value', self.placeholder);

        self.element.addClass('placeholding');
      }
      else {
        self.element.removeClass('placeholding');
      }
    });

     self.element.attr('value', self.placeholder);
  }

  function TokenComplete(element, separator, data) {
    this.element = element;
    this.separator = separator;
    this.data = data;

    this.tokens = [];
    this.oldTokens = [];
  }

  TokenComplete.prototype.register = function() {
    var self = this;

    this.element.keyup(function(event) {
      delay(function() {
        var keyCode = event.keyCode;
        if(keyCode != 39 && keyCode != 37) {
          self.update(keyCode);
        }
      }, 250);
    });
  }

  TokenComplete.prototype.update = function(keyCode) {
    this.oldTokens = this.tokens;
    this.tokens = this.element.attr('value').split(this.separator);

    this.data(this.tokens[this.modifiedIndex()]);
  }

  TokenComplete.prototype.modifiedIndex = function() {

    if(this.tokens.length > this.oldTokens.length) {
      return this.oldTokens.length == 0 ? 0 : this.oldTokens.length;
    }

    for(var token in this.tokens) {
      if(this.tokens[token] != this.oldTokens[token]) {
        return token;
      }
    }

    return this.tokens.length - 1;
  }

  function getJSON(url, callbacks, params) {
    $.getJSON(url, function(data) {
      for(i in callbacks) {
        callbacks[i](data, params);
      }
    });
  }

  function getMatchingTags(tag) {
    if(tag && !tag.match(/^\s*$/)) {
      getJSON('/t/' + tag + '.json', [writeTagSuggestion]);
    }
  }

  function writeTagSuggestion(data) {
    var element = $('#suggestions');

    if(data.length == 0) {
      $('#suggestions').fadeOut('slow', function() {
        element.html('');
      });
    }
    else {
      $('#suggestions').fadeIn('slow');

      var text = "how about "
      if(data.length == 1) {
        text += data[0]['tag_value'] + "?";
      }
      else if(data.length > 1) {
        text += data[0]['tag_value'] + ", or " + data[1]['tag_value'] + "?";
      }
      element.html(text);
    }
  }

  var delay = (function(){
    var timer = 0;
      return function(callback, ms){
      clearTimeout (timer);
      timer = setTimeout(callback, ms);
    };
  })();