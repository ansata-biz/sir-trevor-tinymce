tinymce_defaults = {
  selector: '.st-text-block'
  inline: true
}

initialize_tinymce = (block) ->
  config = $.extend(
    tinymce_defaults,
    {
      selector: "##{ block.blockID } .st-text-block"
    },
    _.result(SirTrevor, 'tinymce_config') || {},
    _.result(block.sirTrevor.options, 'tinymce_config') || {},
    _.result(block, 'tinymce_config') || {}
  )
  tinymce.init config
  if $text = block.getTextBlock?()
    $text.trigger('blur')
    $text.trigger('focus') if $text.is('[contenteditable]')

SirTrevor.EventBus.bind 'block:create:new', initialize_tinymce
SirTrevor.EventBus.bind 'block:create:existing', initialize_tinymce
SirTrevor.Block.prototype._initTextBlocks = -> initialize_tinymce(this)

SirTrevor.EventBus.bind 'block:remove:pre', (block) ->
  tinymce.remove "##{ block.blockID }"

# disable transforming to markdown
SirTrevor.toMarkdown = (html) -> html
SirTrevor.toHtml = (html) -> html