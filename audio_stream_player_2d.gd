extends AudioStreamPlayer2D

func randomize():
	pitch_scale = randf_range(0.9, 1.1)
	volume_db = randf_range(1.0, 3.0)
