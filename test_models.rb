# Test script for Secret Santa models
# Run with: bin/rails runner test_models.rb

puts "🎅 Testing Secret Santa Models\n\n"

# Create test users
puts "Creating test users..."
alice = User.find_or_create_by!(email: 'alice@example.com') do |u|
  u.name = 'Alice'
  u.password = 'password123'
end

bob = User.find_or_create_by!(email: 'bob@example.com') do |u|
  u.name = 'Bob'
  u.password = 'password123'
end

charlie = User.find_or_create_by!(email: 'charlie@example.com') do |u|
  u.name = 'Charlie'
  u.password = 'password123'
end

diana = User.find_or_create_by!(email: 'diana@example.com') do |u|
  u.name = 'Diana'
  u.password = 'password123'
end

puts "✅ Created 4 users: Alice, Bob, Charlie, Diana\n\n"

# Create an event
puts "Creating Secret Santa event..."
event = Event.create!(
  name: 'Office Secret Santa 2025',
  description: 'Annual office gift exchange',
  event_date: Date.today + 30,
  budget: 50.00,
  created_by: alice
)
puts "✅ Event created: #{event.name}\n\n"

# Add participants
puts "Adding participants..."
event.add_participant(alice)
event.add_participant(bob)
event.add_participant(charlie)
event.add_participant(diana)
puts "✅ Added 4 participants\n\n"

# Add block list (Alice and Bob are a couple)
puts "Adding block list (Alice ↔ Bob are a couple)..."
event.add_block(alice, bob)
puts "✅ Block added\n\n"

# Test blocked pairing
puts "Testing blocked pairing..."
puts "  Alice blocked from Bob? #{event.blocked_pairing?(alice, bob)}"
puts "  Bob blocked from Alice? #{event.blocked_pairing?(bob, alice)}"
puts "  Alice blocked from Charlie? #{event.blocked_pairing?(alice, charlie)}\n\n"

# Generate assignments
puts "Generating Secret Santa assignments..."
if event.generate_assignments!
  puts "✅ Assignments generated successfully!\n\n"

  puts "Assignments:"
  event.secret_santa_assignments.each do |assignment|
    puts "  #{assignment.giver.name} → #{assignment.receiver.name}"
  end
  puts "\n"

  # Verify no blocked pairings
  puts "Verifying no blocked pairings..."
  blocked_found = false
  event.secret_santa_assignments.each do |assignment|
    if event.blocked_pairing?(assignment.giver, assignment.receiver)
      puts "  ❌ BLOCKED PAIRING FOUND: #{assignment.giver.name} → #{assignment.receiver.name}"
      blocked_found = true
    end
  end
  puts "  ✅ No blocked pairings found!" unless blocked_found
  puts "\n"

  # Test user methods
  puts "Testing user helper methods..."
  puts "  Alice's receiver: #{alice.receiver_for_event(event)&.name}"
  puts "  Bob's receiver: #{bob.receiver_for_event(event)&.name}"
  puts "  Alice participating? #{alice.participating_in?(event)}"
  puts "  Alice created event? #{alice.created?(event)}\n\n"

else
  puts "❌ Failed to generate assignments\n\n"
end

# Test reset
puts "Testing reset assignments..."
event.reset_assignments!
puts "✅ Assignments reset"
puts "  Assignments generated? #{event.assignments_generated}"
puts "  Assignment count: #{event.secret_santa_assignments.count}\n\n"

puts "🎉 All tests complete!"
