Things Done:

- Setup Gitlab to run behind a reverse proxy
  ```
  external_url 'http://gitlab.home.giodamelio.com'
  nginx['listen_port'] = 80
  nginx['listen_https'] = false
  # gitlab-ctl reconfigure
  ```