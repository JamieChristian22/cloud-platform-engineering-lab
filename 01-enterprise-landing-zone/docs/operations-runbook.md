# Operations Runbook

## Purpose

This runbook provides operational steps for managing the Enterprise Landing Zone.

## Validate EC2 Instance

1. Go to EC2.
2. Select `enterprise-web-server`.
3. Confirm instance state is `Running`.
4. Confirm status checks are `2/2 passed`.

## SSH Into Instance

```bash
cd ~/Downloads
ssh -i enterprise-keypair.pem ec2-user@PUBLIC-IP
```

## Check Apache Status

```bash
sudo systemctl status httpd
```

Expected:

```text
active (running)
```

## Restart Apache

```bash
sudo systemctl restart httpd
```

## Validate Website Locally

```bash
curl localhost
```

## Validate Website Publicly

Open:

```text
http://PUBLIC-IP
```

## Check CloudWatch Alarm

1. Go to CloudWatch.
2. Open Alarms.
3. Select `enterprise-high-cpu-alarm`.
4. Confirm SNS topic action.

## Check CloudTrail

1. Go to CloudTrail.
2. Open `enterprise-trail`.
3. Confirm logging is on.
4. Confirm recent log delivery.

## Stop EC2 to Reduce Cost Risk

1. Go to EC2.
2. Select instance.
3. Instance state.
4. Stop instance.
