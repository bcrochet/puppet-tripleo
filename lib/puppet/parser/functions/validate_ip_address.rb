# TODO(devvesa): Remove the validation function once puppetlabs-stdlib maintainers
# accept the pull request: https://github.com/puppetlabs/puppetlabs-stdlib/pull/546
# This project should not maintain it.
module Puppet::Parser::Functions

  newfunction(:validate_ip_address, :doc => <<-ENDHEREDOC
    Validate that all values passed are valid IP addresses,
    regardless they are IPv4 or IPv6
    Fail compilation if any value fails this check.
    The following values will pass:
    $my_ip = "1.2.3.4"
    validate_ip_address($my_ip)
    validate_bool("8.8.8.8", "172.16.0.1", $my_ip)

    $my_ip = "3ffe:505:2"
    validate_ip_address(1)
    validate_ip_address($my_ip)
    validate_bool("fe80::baf6:b1ff:fe19:7507", $my_ip)

    The following values will fail, causing compilation to abort:
    $some_array = [ 1, true, false, "garbage string", "3ffe:505:2" ]
    validate_ip_address($some_array)
    ENDHEREDOC
  ) do |args|

    require "ipaddr"
    rescuable_exceptions = [ ArgumentError ]

    if defined?(IPAddr::InvalidAddressError)
      rescuable_exceptions << IPAddr::InvalidAddressError
    end

    unless args.length > 0 then
      raise Puppet::ParseError, ("validate_ip_address(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    args.each do |arg|
      unless arg.is_a?(String)
        raise Puppet::ParseError, "#{arg.inspect} is not a string."
      end

      begin
        unless IPAddr.new(arg).ipv4? or IPAddr.new(arg).ipv6?
          raise Puppet::ParseError, "#{arg.inspect} is not a valid IP address."
        end
      rescue *rescuable_exceptions
        raise Puppet::ParseError, "#{arg.inspect} is not a valid IP address."
      end
    end

  end

end