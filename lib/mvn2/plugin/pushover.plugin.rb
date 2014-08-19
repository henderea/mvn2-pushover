require 'everyday-plugins'
include EverydayPlugins
require 'pushover'
class GrowlPlugin
  extend Plugin
  extend PluginType

  register :option_with_param, sym: :pushover_token, names: %w(--pushover-token), desc: 'use pushover.net with the specified user token'

  register(:notification, order: 20) { |options, _, _, message_text|
    if options[:pushover_token]
      path = File.basename(Dir.getwd)
      Pushover.notification(message: message_text, title: path, user: options[:pushover_token], token: 'aV6NxV11TLQJyVfmRvk1Rrv3xoWnGy')
    end
  }
end