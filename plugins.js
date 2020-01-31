window.$docsify.plugins = [
    function (hook) {
        let footer = [
            '<hr/>',
            '<footer>',
            '<span><a href="https://github.com/zhcppy">zhcppy</a> &copy;2020.</span>',
            '<span>Proudly published with <a href="https://github.com/docsifyjs/docsify" target="_blank">docsify</a>.</span>',
            '</footer>'
        ].join('');

        hook.afterEach(function (html) {
            return html + footer;
        });
    }
];