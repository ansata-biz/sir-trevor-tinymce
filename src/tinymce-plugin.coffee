tinymce_defaults =
  selector: '.st-text-block'
  content_editable: true
  inline: true
  hidden_input: false

super_initialize = SirTrevor.Editor.prototype.initialize
SirTrevor.Editor.prototype.initialize = ->
  super_initialize.apply(this, arguments)

  ed = this
  config = $.extend(
    {},
    tinymce_defaults, {
      selector: '#'+this.ID + ' .st-text-block'
    },
    _.result(SirTrevor, 'tinymce_config') || {},
    _.result(this.options, 'tinymce_config') || {}
  )
  tinymce.init(config);

  $(this.$wrapper).on 'focus click', '.st-text-block', (e) ->

    if !$(this).is('.mce-content-body')
      $(this).attr('contenteditable', 'true')
      $block = $(this).closest('.st-block')
      block = ed.findBlockById($block.attr('id'))

      this.id = _.uniqueId('st-text-block-mce-') if !this.id
      id = this.id

      setTimeout () =>
        tinymce.init $.extend( {}, config, selector: '#'+id )
        $(this).trigger('blur').trigger('focus')
      , 100



SirTrevor.Editor.prototype.scrollTo = (element) ->
  $('html, body').animate
    scrollTop: element.offset().top - 70 # tinymce panel height
  , 300, "linear"

SirTrevor.Block.prototype.validateField = (field) ->
  field = $(field)
  content = if field.attr('contenteditable') then field.html() else field.val()
  if content.length == 0
    this.setError(field, i18n.t("errors:block_empty", name: bestNameFromField(field) ))


# disable transforming to markdown
SirTrevor.toMarkdown = (html) -> html
SirTrevor.toHTML = (html) -> html
