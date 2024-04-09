#!/usr/bin/python3
""" queries the Reddit API and returns the number of subscribers
 (not active users, total subscribers) for a given subreddit"""

import requests


def number_of_subscribers(subreddit):
    """
    Queries the Reddit API and returns the number of subscribers for a given subreddit.

    Args:
        subreddit: A string representing the subreddit name.

    Returns:
        The number of subscribers for the subreddit, or 0 if the subreddit is invalid.
    """
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = {'User-Agent': 'Mozilla/5.0 Isaac'}
    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        return data['data']['subscribers']
    else:
        return 0


if __name__ == "__main__":
    # Test cases
    print(number_of_subscribers("programming"))  # Example valid subreddit
    print(number_of_subscribers("this_is_a_fake_subreddit"))  # Example invalid subreddit
