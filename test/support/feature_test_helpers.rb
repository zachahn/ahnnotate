def config_with_fallback
  if respond_to?(:config)
    config
  else
    nil
  end
end
