class Kandan.Views.User extends Backbone.View
  template: JST['user_item']
  tagName: 'li'
  className: 'user'

  events:
    "click": 'createPersonalChannel'

  render: ->
    @$el.user_id = @options.user_id
    @$el.user_name = @options.name
    @$el.html @template
      user_id: @options.user_id,
      name: @options.name,
      admin: @options.admin,
      avatarUrl: @options.avatarUrl
    @

  createPersonalChannel: (event) ->
    current_user = Kandan.Helpers.Users.currentUser()
    if @$el.user_id isnt current_user.id
      channel = new Kandan.Models.Channel
        name: "#{@$el.user_name}-#{current_user.username}",
        private_channel: true,
        guess_id: @$el.user_id

      channel.save {},
        error: (model, response)->
          _.each(JSON.parse(response.responseText), alert)

    false
