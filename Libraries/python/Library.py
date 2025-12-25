import random

class Library:
    def generate_4_digit_id(self):
        """
        Generate 4 random numeric characters
        contoh: 0384, 9271
        """
        return f"{random.randint(0, 9999):04d}"


