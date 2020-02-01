# JavaScript

```js
let jqry = document.createElement('script');
jqry.src = "https://code.jquery.com/jquery-3.4.1.js";
document.getElementsByTagName('head')[0].appendChild(jqry);
jQuery.noConflict();

function AjaxReq() {
    $.ajax({
        url: "https://famousmotto.codeday.me/api/getRandom",
        type: 'GET',
        dataType: 'JSON',
        success: function (data) {
            console.log(data);
        },
        error: function (err) {
            console.log(err);
        }
    });
}

for (let i = 0; i < 1000; i++) {
    AjaxReq()
}

// new WebSocket("ws://192.169.20.18:8080/api/v1/ws");
```
