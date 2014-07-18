class @MessagesTable extends @Table

  constructor: (element, checkboxable) ->
    super(element, checkboxable)
    @deleteBtn  = @element.find('.js-delete')
    @spamBtn    = @element.find('.js-spam')
    @hamBtn     = @element.find('.js-ham')
    @setBindings()

  setBindings: () =>
    @deleteBtn.on('click', @delete)
    @spamBtn.on('click', @spam)
    @hamBtn.on('click', @ham)

  delete: (event) =>
    @stopEvent(event)
    $.ajax(
      url: "/admin/messages/#{@getIds()}"
      type: 'DELETE'
      dataType: "JSON"
      success: @removeMessages
    ).always(@notify)

  spam: (event) =>
    @stopEvent(event)
    $.ajax(
      type: "POST"
      dataType: "JSON"
      url: "/admin/messages/#{@getIds()}/spam"
      success: @removeMessages
    ).always(@notify)

  ham: (event) =>
    @stopEvent(event)
    $.ajax(
      type: "POST"
      dataType: "JSON"
      url: "/admin/messages/#{@getIds()}/ham"
      success: @removeMessages
    ).always(@notify)

  removeMessages: () =>
    $.each @getIds(), (i, message_id) => @removeMessage(message_id)

  removeMessage: (message_id) ->
    $("tr#message_#{message_id}").remove();

  enableActions: () =>
    @spamBtn.removeClass('disabled').addClass('btn-warning')
    @hamBtn.removeClass('disabled').addClass('btn-warning')
    @deleteBtn.removeClass('disabled').addClass('btn-danger')

  disableActions: () =>
    @spamBtn.addClass('disabled').removeClass('btn-warning')
    @hamBtn.addClass('disabled').removeClass('btn-warning')
    @deleteBtn.addClass('disabled').removeClass('btn-danger')

$.fn.actsAsMessagesTable = () ->
  @each ->
    checkboxable = new Checkboxable($(this))
    new MessagesTable($(this), checkboxable)

jQuery ->
  $("table.messages.js-checkboxable").each ->
    $(this).actsAsMessagesTable()