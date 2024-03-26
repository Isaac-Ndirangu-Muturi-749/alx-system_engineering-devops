#!/usr/bin/python3
"""
Python script that, using this REST API, for a given employee ID,
returns information about his/her TODO list progress.
"""
import requests
import sys


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 {} <employee_id>".format(sys.argv[0]))
        sys.exit(1)

    employee_id = sys.argv[1]
    base_url = "https://jsonplaceholder.typicode.com"
    user_url = "{}/users/{}".format(base_url, employee_id)
    todo_url = "{}/todos?userId={}".format(base_url, employee_id)

    try:
        user_response = requests.get(user_url)
        user_data = user_response.json()
        username = user_data.get("username")
    except Exception as e:
        print("Error retrieving user data:", e)
        sys.exit(1)

    try:
        todo_response = requests.get(todo_url)
        todo_data = todo_response.json()
        total_tasks = len(todo_data)
        done_tasks = [task for task in todo_data if task.get("completed")]
        num_done_tasks = len(done_tasks)
    except Exception as e:
        print("Error retrieving TODO data:", e)
        sys.exit(1)

    print("Employee {} is done with tasks({}/{}):".format(
        username, num_done_tasks, total_tasks))
    for task in done_tasks:
        print("\t ", task.get("title"))
