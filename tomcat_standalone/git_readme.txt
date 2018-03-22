#
GIT REPO = https://github.com/divlv/playbooks.git

The point of this helper is to reduce the number of times you must type your username or password. For example:

path/to/anslible_task_files git config credential.helper store
path/to/anslible_task_files git push https://github.com/divlv/playbooks.git
Username: <type your username>
Password: <type your password>

!!!RESET ALL LOCAL CHANGES:
git checkout .
