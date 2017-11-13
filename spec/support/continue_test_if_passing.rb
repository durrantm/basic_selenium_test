before :all do
  CONTINUE_SPEC= true
end

around :each do |example|
  if CONTINUE_SPEC
    CONTINUE_SPEC = false
    example.run
    CONTINUE_SPEC = true unless example.exception
  else
    example.skip
  end
end
