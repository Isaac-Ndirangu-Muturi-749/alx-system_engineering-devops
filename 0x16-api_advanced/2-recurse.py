#!/usr/bin/python3
"""
Recursively queries the Reddit API and returns a list containing the titles
of all hot articles for a given subreddit.
"""

import requests


def recurse(subreddit, hot_list=[], after=None):
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=100"
    headers = {'User-Agent': 'Mozilla/5.0'}
    params = {'after': after} if after else {}

    response = requests.get(url, headers=headers, params=params,
                            allow_redirects=False)
    if response.status_code != 200:
        return None

    data = response.json()
    if 'data' not in data or 'children' not in data['data']:
        return None

    children = data['data']['children']
    for child in children:
        hot_list.append(child['data']['title'])

    after = data['data']['after']
    if after is not None:
        recurse(subreddit, hot_list, after)

    return hot_list


if __name__ == "__main__":
    subreddit = input("Enter subreddit name: ")
    result = recurse(subreddit)
    if result is not None:
        print(len(result))
    else:
        print("None")
