Things Done:

- Setup Gitlab to run behind a reverse proxy
  ```
  external_url 'https://gitlab.home.giodamelio.com'
  nginx['listen_port'] = 80
  nginx['listen_https'] = false
  # gitlab-ctl reconfigure
  ```

- Setup Gitlab to send email via Fastmail
```
# Email Server Settings
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.fastmail.com"
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = "<fastmail username with domain>"
gitlab_rails['smtp_password'] = "<app password>"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
gitlab_rails['smtp_openssl_verify_mode'] = 'peer'

### Email Settings
gitlab_rails['gitlab_email_from'] = 'gitlab@giodamelio.com'
gitlab_rails['gitlab_email_display_name'] = 'Homelab Gitlab'
gitlab_rails['gitlab_email_reply_to'] = 'noreply@giodamelio.com'
```