# webhook (https://github.com/adnanh/webhook)

### install

```bash
sudo apt-get install webhook
```

or 

```bash
go get -v github.com/adnanh/webhook
```

### Use

```bash
webhook -verbose -hooks=/home/ubuntu/go/src/zhcppy/webhooks.json -port 2000
```

### webhooks.json

[webhook.json](webhooks.json ':include :type=code json')

### execute script

[run.sh](run.sh ':include :type=code bash')
