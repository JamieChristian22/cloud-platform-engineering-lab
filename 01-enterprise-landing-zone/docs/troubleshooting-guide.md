# Troubleshooting Guide

## EC2 Instance Connect Fails

Possible causes:
- No public IPv4 address
- Public subnet not associated with public route table
- Internet Gateway not attached
- Security group missing SSH rule
- Instance is not running

## SSH Permission Error

Run:

```bash
chmod 400 enterprise-keypair.pem
```

Then retry SSH.

## SSH Times Out

Check:
- Public IP exists
- SSH inbound rule allows My IP
- Route table has `0.0.0.0/0` to Internet Gateway
- Instance is in public subnet

## Website Does Not Load

Check Apache:

```bash
sudo systemctl status httpd
```

Start Apache:

```bash
sudo systemctl start httpd
```

Check security group:
- HTTP port 80 must allow inbound traffic.

## curl localhost Works but Browser Fails

Likely cause:
- Security group missing HTTP inbound rule
- Wrong public IP used
- Instance public IP changed after stop/start

## CloudWatch Alarm Has Insufficient Data

This can be normal immediately after alarm creation. Wait a few minutes.

## SNS Email Not Received

Check:
- Email subscription confirmed
- Correct email address used
- Spam folder
- SNS subscription status says Confirmed
