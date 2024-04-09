#!/usr/bin/python3
"""
Recursively queries the Reddit API, parses the titles of all hot articles,
and prints a sorted count of given keywords.
"""

import requests


def count_words(subreddit, word_list, hot_list=[], after=None):
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
        count_words(subreddit, word_list, hot_list, after)
    else:
        word_count = {}
        for title in hot_list:
            for word in word_list:
                if word.lower() in title.lower().split():
                    word_count[word.lower()] = word_count.get(word.lower(), 0) + 1

        sorted_word_count = sorted(word_count.items(), key=lambda x: (-x[1], x[0]))
        for word, count in sorted_word_count:
            print(f"{word}: {count}")

if __name__ == "__main__":
    subreddit = input("Enter subreddit name: ")
    word_list = input("Enter list of keywords (separated by space): ").split()
    count_words(subreddit, word_list)
