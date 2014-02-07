class Kandan.Modifiers
  @modifiers: []

  @register: (regex, callback)->
    @modifiers.push({regex: regex, callback: callback})

  @all: ()->
    @modifiers

  @process: (activity)->
    message = activity.content
    if $('body').data('user-lang') == 'EN' and activity.content_en
      message = activity.content_en
    if $('body').data('user-lang') == 'TL' and activity.content_tl
      message = activity.content_tl

    for modifier in @modifiers
      if message.match(modifier.regex) != null
        message = modifier.callback(message, activity)

    return message
