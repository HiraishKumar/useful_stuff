import datetime

# Get current date and time
now = datetime.datetime.now()

# Format the date and time correctly
formatted_date = now.strftime("%y-%m-%d %H:%M:%S")

# Print the formatted date and time
print("Current Date and Time:", formatted_date)

# Create a datetime object for a specific date (Christmas 2024 at midnight)
birthday = datetime.datetime(2025, 3, 30)

# Calculate the time difference between now and the birthday
time_until_birthday = birthday - now

# Print the time difference
print("Time until Birthday:", time_until_birthday)
