def map_time_to_emoji(time_str):
    # Define a dictionary mapping digits to time emojis
    time_emoji = {
        '1': '🕐',
        '2': '🕑',
        '3': '🕒',
        '4': '🕓',
        '5': '🕔',
        '6': '🕕',
        '7': '🕖',
        '8': '🕗',
        '9': '🕘',
        '10': '🕙',
        'A': '🕚',
        'B': '🕛',
        'C': ':',
        'D': '',
        'E': '',
        'F': ''
    }
    
    # Initialize an empty result string
    result = ""
    
    # Iterate over each character in the input string
    for char in time_str.split():
        if char in time_emoji:
            result += time_emoji[char] + " "
        else:
            result += char + " "
    
    return result.strip()

# Example usage
time_str = ""
emoji_str = map_time_to_emoji(time_str)
print(emoji_str)

