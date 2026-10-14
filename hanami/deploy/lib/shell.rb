# frozen_string_literal: true

require "open3"

# Small shell-command helpers shared by the deploy/* scripts. Every
# command is passed as an argv array (never a shell string), so none of
# this needs manual quoting the way the equivalent bash did.
module Shell
  module_function

  def log(message)
    puts "==> #{message}"
  end

  # Run a command, streaming its output, raising if it fails.
  def run(*cmd)
    puts "+ #{cmd.join(' ')}"
    system(*cmd) || raise("command failed: #{cmd.join(' ')}")
  end

  # Run a command and return its stdout, raising if it fails.
  def capture(*cmd)
    out, status = Open3.capture2(*cmd)
    raise("command failed: #{cmd.join(' ')}") unless status.success?

    out
  end

  # Run a command, discarding output, returning whether it succeeded.
  def success?(*cmd)
    system(*cmd, out: File::NULL, err: File::NULL)
  end
end
