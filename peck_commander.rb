#!/usr/bin/env ruby

include 'peck_client.rb'
require 'commander/import'


class MyApplication
  include Commander::Methods


    program :name, 'Peck Command Line Interface'
    program :version, '0.0.1'
    program :description, 'A command line interface for interacting with the Peck rails application running on the servers'

  def run

    command :create_user do |c|
      c.syntax = 'peckcli create_user [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Create_user
      end
    end

    command :destroy_user do |c|
      c.syntax = 'peckcli destroy_user [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Destroy_user
      end
    end

    command :get_events do |c|
      c.syntax = 'peckcli get_events [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Get_events
      end
    end

    command :get_athletics do |c|
      c.syntax = 'peckcli get_athletics [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Get_athletics
      end
    end

    command :get_dining do |c|
      c.syntax = 'peckcli get_dining [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Get_dining
      end
    end

    command :get_annoucements do |c|
      c.syntax = 'peckcli get_annoucements [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Get_annoucements
      end
    end

    command :get_explore do |c|
      c.syntax = 'peckcli get_explore [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Get_explore
      end
    end

    command :get_circles do |c|
      c.syntax = 'peckcli get_circles [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Get_circles
      end
    end

    command :create_event do |c|
      c.syntax = 'peckcli create_event [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Create_event
      end
    end

    command :create_announcement do |c|
      c.syntax = 'peckcli create_announcement [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Create_announcement
      end
    end

    command :create_circle do |c|
      c.syntax = 'peckcli create_circle [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--some-switch', 'Some switch that does something'
      c.action do |args, options|
        # Do something or c.when_called Peckcli::Commands::Create_circle
      end
    end

    run!
  end
end
