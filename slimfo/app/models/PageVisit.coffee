utils = require 'lib/utils'
Config = require 'config'
Model = require 'models/base/model'

module.exports = class PageVisit extends Model
  initialize: () ->
    @set 'created_at', (new Date()).getTime()
    @subscribeEvent 'add', @categorize

  created_at: null

  url: null

  category: null

  defaults:
    category: "Other"

  validate: (attrs, options) ->
    isChromeUrl = /^chrome/i.test attrs.url
    if isChromeUrl
      return "Not a valid URL."

  # callback that is called with a newly added PageVisit, and categorizes it
  categorize: (pageVisit) ->
    pageUrl = pageVisit.attributes.url
    return if pageUrl == null
    console.log "trying to categorize #{pageUrl}"
    $.ajax(
      url: Config.categorizerEndpoint + "?url=#{utils.removeProtocol(pageUrl)}"
    ).done (data) ->
      pageVisit.save
        category: data.category