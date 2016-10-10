exports.loadMessages = (params, callback) ->
  if @isId params
    params = teamId: params
  else unless params and typeof params is 'object'
    throw new TSArgsError 'teamsnap.loadMessages', 'must provide a
      teamId or query parameters'

  @loadItems 'message', params, callback

exports.markMessageAsRead = (params, callback) ->
  if typeof params is 'object'
    params = id: params.id
  else if @isId params
    params = id: params
  else
    throw new TSArgsError 'teamsnap.markMessageAsRead',
      'a message `id` or `message` object must be provided'

  @collections.messages.exec('markMessageAsRead', params)
    .pop().callback callback

exports.bulkDeleteMessages = (params, callback) ->
  if Array.isArray params
    if params[0]? and typeof params[0] is 'object' and
    @isItem params[0], 'message'
      params = id: params.map (item) -> item.id
    else if @isId params[0]
      params = id: params
    else
      throw new TSArgsError 'teamsnap.bulkDeleteMessages',
        'Must provide an `array` of message `ids` or `message` objects'
  else if typeof params is 'object' and @isItem params, 'message'
    params = id: params.id
  else if @isId params
    params = id: params
  else
    throw new TSArgsError 'teamsnap.bulkDeleteMessages',
      'Must provide an `array` of message `ids`, an `id` or a `message` object'

  @collections.messages.exec('bulkDelete', params).callback callback
