# Apache Installation

## Commands

```bash
sudo dnf update -y
sudo dnf install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
```

## Web Page

```bash
echo "<h1>Enterprise Landing Zone</h1><p>Cloud Platform Engineering Project</p>" | sudo tee /var/www/html/index.html
```

## Validation

```bash
curl localhost
```
