board  = Denko::Board.new
buzzer = Denko::PulseIO::Buzzer.new board: board, pin: 3

# Note frequencies.
C4 = 262
D4 = 294
E4 = 330

# Melody to play.
notes = [
        [E4, 1], [D4, 1], [C4, 1], [D4, 1], [E4, 1], [E4, 1], [E4, 2],
        [D4, 1], [D4, 1], [D4, 2],          [E4, 1], [E4, 1], [E4, 2],
        [E4, 1], [D4, 1], [C4, 1], [D4, 1], [E4, 1], [E4, 1], [E4, 1], [E4, 1],
        [D4, 1], [D4, 1], [E4, 1], [D4, 1], [C4, 4],
        ]

# Calculate length of one beat.
bpm = 180
beat_time = 60.to_f / bpm

# Play the melody.
notes.each do |note|
  buzzer.tone(note[0])
  board.micro_delay(note[1] * beat_time * 1_000_000)

  # Drop frequency low for a bit to improve note separation. Will add a better way to do this.
  buzzer.stop
  board.micro_delay(5000)
end

# Turn the buzzer off.
buzzer.stop
