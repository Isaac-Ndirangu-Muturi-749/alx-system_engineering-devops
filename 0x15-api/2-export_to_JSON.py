#!/usr/bin/python3
"""
Python script that, using this REST API, for a given employee ID,
exports information about his/her TODO list progress to a json file.
"""

import json
import requests
import sys

if __name__ == '__main__':
    main_url = 'https://jsonplaceholder.typicode.com'
    employee_id = sys.argv[1]
    todo_url = main_url + "/user/{}/todos".format(employee_id)
    user_url = main_url + "/users/{}".format(employee_id)
    todo_result = requests.get(todo_url).json()
    user_result = requests.get(user_url).json()

    user_id = user_result.get("id")
    username = user_result.get("name")

    user_tasks = ([
        {"task": todo.get("title"),
        "completed": todo.get("completed"),
        "username": username}
        for todo in todo_result
        ])

    filename = f"{user_id}.json"
    with open(filename, "w") as json_file:
        json.dump({user_id: user_tasks}, json_file)
