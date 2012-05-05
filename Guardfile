group :spec do
  guard 'rspec', :version => 2, :cli => '--color --require spec_helper' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/unit/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }
  end
end
