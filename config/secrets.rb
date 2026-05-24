secrets_file = File.expand_path('~/.secret')
return unless File.exist?(secrets_file)

File.foreach(secrets_file) do |line|
  line.strip!
  next if line.empty? || line.start_with?('#') || !line.include?('=')
  key, value = line.split('=', 2)
  ENV[key.strip] ||= value.strip
end
