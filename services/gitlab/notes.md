Things Done:

- Setup Gitlab to run behind a reverse proxy
  ```
  external_url 'https://gitlab.home.giodamelio.com'
  nginx['listen_port'] = 80
  nginx['listen_https'] = false
  # gitlab-ctl reconfigure
  ```
