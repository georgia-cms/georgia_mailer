class @MessagesTable

  constructor: (element) ->
    @element          = $(element)
    @checkboxes       = @element.find("input:checkbox")
    @deleteBtn        = @element.find('.js-delete')
    @spamBtn          = @element.find('.js-spam')
    @hamBtn           = @element.find('.js-ham')
    @setBindings()

  setBindings: () =>
    @checkboxes.on('change', @update)
    @deleteBtn.on('click', @delete)
    @spamBtn.on('click', @spam)
    @hamBtn.on('click', @ham)

  update: () =>
    if @getChecked().length then @enableActions() else @disableActions()

  delete: (event) =>
    @stopEvent(event)
    $.ajax(
      url: "/admin/messages/#{@getIds()}"
      type: 'DELETE'
    )

  spam: (event) =>
    @stopEvent(event)
    $.ajax(
      type: "POST"
      dataType: "JSON"
      url: "/admin/messages/#{@getIds()}/spam"
      success: (data) =>
        $.each data, (i, message_id) => @removeMessage(message_id)
    )

  ham: (event) =>
    @stopEvent(event)
    $.ajax(
      type: "POST"
      dataType: "JSON"
      url: "/admin/messages/#{@getIds()}/ham"
      success: (data) =>
        $.each data, (i, message_id) => @removeMessage(message_id)
    )

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

  stopEvent: (event) ->
    event.stopPropagation()
    event.preventDefault()

  getChecked: () => @element.find("input:checkbox:checked[data-checkbox='child']")
  getId:      (c) => $(c).data('id')
  getIds:     () => $.map(@getChecked(), (c) => @getId(c))

$.fn.actsAsMessagesTable = () ->
  @each ->
    new MessagesTable($(this))

jQuery ->
  $("table.messages.js-checkboxable").each ->
    $(this).actsAsMessagesTable()