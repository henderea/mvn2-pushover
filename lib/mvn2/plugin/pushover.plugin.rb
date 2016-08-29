require 'everyday-plugins'
include EverydayPlugins
require 'pushover'
class PushoverPlugin
  extend Plugin
  extend PluginType

  register :option_with_param, sym: :pushover_token, names: %w(--pushover-token), desc: 'use pushover.net with the specified user token'
  register :option, sym: :pushover_lock_check, names: %w(--pushover-lock-check), desc: 'skip the pushover notification when the screen is unlocked'

  register(:notification, order: 20) { |options, _, _, message_text|
    if options[:pushover_token]
      path = File.basename(Dir.getwd)
      if options[:pushover_lock_check]
        mod = '3' if `which python3`.include?('python3')
        rval = `python#{mod} -c 'import sys,Quartz; d=Quartz.CGSessionCopyCurrentDictionary(); print(d.get("CGSSessionScreenIsLocked", 0))'`.chomp.to_s.downcase
        if %w(0 1 true false).include?(rval)
          unlocked = %w(0 false).include?(rval)
        else
          unlocked = false
          puts <<-EOS
You can enable the ability to skip the pushover message when your Mac is unlocked by running
$ pip#{mod} install pyobjc-framework-Quartz
to install the Python libraries needed to check the screen lock status.

This is a Mac only feature
EOS
        end
      else
        unlocked = false
      end
      failures = Plugins.get_var :failures
      message_text = "#{message_text} (#{failures} failed)" if failures && failures > 0
      Pushover.notification(message: message_text, title: path, user: options[:pushover_token], token: 'aV6NxV11TLQJyVfmRvk1Rrv3xoWnGy') unless unlocked
    end
  }
end