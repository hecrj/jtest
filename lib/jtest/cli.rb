require "thor"
require "thor/group"
require "jtest/commands"

module Jtest
  class CLI < Thor
    include Thor::Actions

    add_runtime_options!

    register Jtest::Commands::New, "new", "new [ID]",
    "Creates a workspace to solve problem with the given id"
    tasks["new"].options = Jtest::Commands::New.class_options

    register Jtest::Commands::Test, "test", "test",
    "Performs tests for all the problems on the current working directory"
    tasks["test"].options = Jtest::Commands::Test.class_options

    register Jtest::Commands::Update, "update", "update",
    "Downloads the samples for every problem in the current working directory"
    tasks["update"].options = Jtest::Commands::Update.class_options
  end
end
