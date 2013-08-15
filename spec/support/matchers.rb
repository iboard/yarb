RSpec::Matchers.define :match_exactly do |expected_match_count, selector|
  match do |context|
    matching = context.all(selector)
    @matched = matching.size
    @matched == expected_match_count
  end

  failure_message_for_should do
    "expected '#{selector}' to match exactly #{expected_match_count} elements, but matched #{@matched}"
  end

  failure_message_for_should_not do
    "expected '#{selector}' to NOT match exactly #{expected_match_count} elements, but it did"
  end
end

RSpec::Matchers.define :match_at_least do |minumum_match_count, selector|
  match do |context|
    matching = context.all(selector)
    @matched = matching.size
    @matched >= minumum_match_count
  end

  failure_message_for_should do
    "expected '#{selector}' to match at least #{minumum_match_count} elements, but matched #{@matched}"
  end

  failure_message_for_should_not do
    "expected '#{selector}' to NOT match at least #{minumum_match_count} elements, but it did"
  end
end

