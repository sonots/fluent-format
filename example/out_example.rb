class Fluent::ExampleOutput < Fluent::Output
  Fluent::Plugin.register_output('example', self)

  config_param :param, :string, :default => nil

  def configure(conf)
    super

    raise Fluent::ConfigError, "bad param" if @param == "bad"
  end

  def emit(tag, es, chain)
    chain.next
  end
end
